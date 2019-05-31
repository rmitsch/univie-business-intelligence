import prophet
import pandas as pd
import os
from matplotlib import pyplot as plt
from scipy.stats import binom_test


def compute_salescount_per_week(transactions: pd.DataFrame, allowed_product_ids: set) -> pd.DataFrame:
    """
    Computes sales counts per week for specified set of products.
    :param transactions:
    :param allowed_product_ids:
    :return: Dataframe with sales counts per week, separated by product ID.
    """

    return transactions[
        transactions.UPC.isin(allowed_product_ids)
    ][["UPC", "WEEK_END_DATE", "UNITS"]].groupby(["UPC", "WEEK_END_DATE"]).sum()


def compute_salescount_per_week_plot_df(salescount_by_week: pd.DataFrame, products: pd.DataFrame) -> pd.DataFrame:
    """
    Auxiliary method to prepare dataframe holding weekly sales count data for plotting.
    :param salescount_by_week:
    :param products:
    :return: Dataframe that can be used for plotting.
    """

    return pd.pivot_table(
        salescount_by_week.join(products)[["extended_description", "UNITS"]].reset_index().drop(
            columns=["UPC"], errors="ignore"
        ),
        index="WEEK_END_DATE",
        columns=["extended_description"]
    ).reset_index()


if __name__ == '__main__':
    # Read/pre-process data.
    products: pd.DataFrame = pd.read_csv("data_products_lookup.csv", index_col="UPC")
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

        salescount_by_week = compute_salescount_per_week(transactions, set(top5_prods_by_sales.index.values))
        products["extended_description"] = products["DESCRIPTION"] + " (" + products.index.astype(str) + ")"
        salescount_by_week_plot_df = compute_salescount_per_week_plot_df(salescount_by_week, products)
        salescount_by_week_plot_df.plot(x="WEEK_END_DATE", y="UNITS", title="Sales count per week")
        plt.grid()
        plt.show()

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

