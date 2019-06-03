import pandas as pd
import os
from matplotlib import pyplot as plt
from scipy.stats import binom_test
from pprint import pprint
from fbprophet import Prophet
import numpy as np
import itertools
from tqdm import tqdm
import utils
from multiprocessing.pool import ThreadPool, Pool
import psutil


if __name__ == '__main__':
    # Read/pre-process data.
    products: pd.DataFrame = pd.read_csv("data_products_lookup.csv", index_col="UPC")
    products["extended_description"] = products["DESCRIPTION"] + " (" + products.index.astype(str) + ")"
    stores: pd.DataFrame = pd.read_csv("data_store_lookup.csv", index_col="STORE_ID")
    if not os.path.isfile("transactions.pkl"):
        transactions: pd.DataFrame = pd.read_csv("data_transactions.csv")
        transactions.WEEK_END_DATE = pd.to_datetime(transactions.WEEK_END_DATE, infer_datetime_format=True)
        transactions.to_pickle("transactions.pkl")
    else:
        transactions: pd.DataFrame = pd.read_pickle("transactions.pkl")

    # Adress questions in exercise 3.
    with pd.option_context('display.max_rows', None, 'display.max_columns', None, 'display.width', None):
        #################################
        # 1. 1.
        #################################

        # Ensure only to consider products having been bought during the most recent 4 weeks in timespan covered in
        # records.
        valid_product_ids = transactions.groupby("UPC")[["WEEK_END_DATE"]].max()
        valid_product_ids = set(
            valid_product_ids[
                valid_product_ids.WEEK_END_DATE >= transactions.max()["WEEK_END_DATE"] - pd.Timedelta(4, unit='w')
            ].index.values
        )
        valid_transactions = transactions[transactions.UPC.isin(valid_product_ids)]

        by_sales = valid_transactions[["UPC", "SPEND"]].groupby("UPC").sum().sort_values("SPEND", ascending=False)
        top5_prods_by_sales = by_sales.head(5).join(products)

        #################################
        # 1. 2.
        #################################

        salescount_by_week = utils.compute_salescount_per_week(transactions, set(top5_prods_by_sales.index.values))
        products["extended_description"] = products["DESCRIPTION"] + " (" + products.index.astype(str) + ")"
        salescount_by_week_plot_df = utils.compute_salescount_per_week_plot_df(salescount_by_week, products)

        # plt.figure(figsize=(20, 10))
        # plt.plot(salescount_by_week_plot_df.WEEK_END_DATE, salescount_by_week_plot_df.UNITS)
        # plt.gca().legend([
        #     desc[1] for desc in salescount_by_week_plot_df.reset_index().columns.values if desc[0] == "UNITS"
        # ])
        # plt.title("Sales count per week")
        # plt.grid()
        # plt.show()

        #################################
        # 1. 3.
        #################################

        # Binomial test with p = 0.5 and H_0 = promotions don't make a difference.
        # for column in ("FEATURE", "DISPLAY", "TPR_ONLY"):
        #     contingency_table_units = transactions[["UNITS"]].groupby(transactions[column]).mean()
        #     print(
        #         column + ":",
        #         str(
        #             binom_test(
        #                 contingency_table_units.loc[0].UNITS,
        #                 n=contingency_table_units.UNITS.sum(),
        #                 p=0.5,
        #                 alternative='greater'
        #             )
        #         )
        #     )

        # Plot occurence of promotions - one plot per promotion and top 5 product.
        for column in ("FEATURE", "DISPLAY", "TPR_ONLY"):
            for ix, row in top5_prods_by_sales.iterrows():
                extended_description = row.DESCRIPTION + " (" + str(ix) + ")"
                salescount_by_week_plot = salescount_by_week.join(
                    products
                )[["extended_description", "UNITS"]].reset_index().drop(
                    columns=["UPC"], errors="ignore"
                ).plot(
                    x="WEEK_END_DATE",
                    y="UNITS",
                    title="Sales count per week with " + column + " promotions for \n " + extended_description
                )

                for dt in transactions[(transactions.UPC == ix) & (transactions[column] == 1)].WEEK_END_DATE.unique():
                    salescount_by_week_plot.axvline(dt, color='r', linestyle='--', lw=1)

                plt.grid()
                plt.show()

        #################################
        # 1. 4.
        #################################

        # W/o any tuning:
        for ix in top5_prods_by_sales.index.values:
            # Split in train and test set..
            base_df = salescount_by_week.loc[ix].reset_index().rename(columns={"WEEK_END_DATE": "ds", "UNITS": "y"})
            split_date = base_df.max()["ds"] - pd.Timedelta(4, unit='w')
            train_set = base_df[base_df.ds <= split_date]
            test_set = base_df[base_df.ds > split_date]

            proph = Prophet()
            proph.fit(train_set)
            future = proph.make_future_dataframe(periods=4, freq="W")
            forecast = proph.predict(future)
            # proph.plot(forecast)
            # proph.plot_components(forecast)
            # plt.show()

            # MSE
            mse = np.mean(np.power(test_set.y - forecast.yhat.tail(4), 2))
            print(mse)

        base_dfs = {
            upc: salescount_by_week.loc[upc].reset_index().rename(columns={"WEEK_END_DATE": "ds", "UNITS": "y"})
            for upc in top5_prods_by_sales.index.values
        }

        if not os.path.isfile("ts_gridsearch_results.pkl"):
            # Hyperparameter tuning:
            hyperparameters = [
                # yearly_seasonality
                [True, False],
                # custom monthly_seasonality
                [True, False],
                # weekly_seasonality
                [True, False],
                # daily_seasonality
                [True, False],
                # seasonality_mode
                ["additive", "multiplicative"],
                # n_changepoints
                [5, 15, 25, 35, 50],
            ]
            prophet_configs = [
                (upc, hp_config, base_dfs[upc])
                for upc in top5_prods_by_sales.index.values
                for hp_config in [
                    config for config in itertools.product(*hyperparameters)
                ]
            ]

            # Hyperparameter grid search.
            with Pool(psutil.cpu_count(logical=True)) as thread_pool:
                config_results = list(
                    tqdm(
                        thread_pool.imap(utils.run_prophet_configuration_wrapper, prophet_configs),
                        total=len(prophet_configs)
                    )
                )

            ts_gridsearch_results = pd.DataFrame(config_results)
            ts_gridsearch_results.to_pickle("ts_gridsearch_results.pkl")
        else:
            ts_gridsearch_results = pd.read_pickle("ts_gridsearch_results.pkl")

        for upc in top5_prods_by_sales.index.values:
            print(ts_gridsearch_results[ts_gridsearch_results.UPC == upc].sort_values("MSE", ascending=True).head(5))
            print("-" * 32)

        # yes, hyperparameter settings do make a difference. it's not drastic, but noticeable.

        best_configs_by_upc = {
            upc: ts_gridsearch_results[ts_gridsearch_results.UPC == upc].sort_values("MSE", ascending=True).iloc[0][[
                "yearly_seasonality",
                "monthly_seasonality",
                "weekly_seasonality",
                "daily_seasonality",
                "seasonality_mode",
                "n_changepoints",
                "MSE"
            ]]
            for upc in top5_prods_by_sales.index.values
        }

        # Use holidays.
        for upc in best_configs_by_upc:
            config = best_configs_by_upc[upc]
            result_without_holidays = utils.evaluate_prophet_configuration(
                upc,
                [
                    config.yearly_seasonality,
                    config.monthly_seasonality,
                    config.weekly_seasonality,
                    config.daily_seasonality,
                    config.seasonality_mode,
                    config.n_changepoints
                ],
                base_dfs[upc]
            )["MSE"]
            result_with_holidays = utils.evaluate_prophet_configuration(
                upc,
                [
                    config.yearly_seasonality,
                    config.monthly_seasonality,
                    config.weekly_seasonality,
                    config.daily_seasonality,
                    config.seasonality_mode,
                    config.n_changepoints
                ],
                base_dfs[upc],
                holidays=pd.concat([
                    pd.DataFrame({
                        'holiday': promotion_type,
                        'ds': transactions[
                            (transactions.UPC == upc) & (transactions[promotion_type] == 1)
                        ].WEEK_END_DATE.unique(),
                        'lower_window': 0,
                        'upper_window': 0,
                    })
                    for promotion_type in ("FEATURE", "DISPLAY", "TPR_ONLY")
                ])
            )["MSE"]

            relative_MSE_delta = (result_without_holidays - result_with_holidays) / result_without_holidays
            print(f"Delta for UPC #{upc}: {relative_MSE_delta}")
            print(f"Without holidays: MSE = {result_without_holidays}, with holidays: MSE = {result_with_holidays}")
            print("-" * 30)





