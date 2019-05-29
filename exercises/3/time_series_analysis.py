import prophet
import pandas as pd
import os
from matplotlib import pyplot as plt


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
        # 1. 1.

        # Ensure only to consider products having been bought during the most recent 4 weeks in timespan covered in
        # records.
        valid_product_ids = transactions.groupby("UPC")[["WEEK_END_DATE"]].max()
        valid_product_ids = set(
            valid_product_ids[
                valid_product_ids.WEEK_END_DATE >= transactions.max()["WEEK_END_DATE"] - pd.Timedelta(4, unit='w')
            ].index.values
        )
        valid_transactions = transactions[transactions.UPC.isin(valid_product_ids)]

        by_sales = valid_transactions[["UPC", "UNITS"]].groupby("UPC").sum().sort_values("UNITS", ascending=False)
        top5_prods_by_sales = by_sales.head(5).join(products)

        # 1. 2.
        salescount_by_week = transactions[
            transactions.UPC.isin(set(top5_prods_by_sales.index.values))
        ][["UPC", "WEEK_END_DATE", "UNITS"]].groupby(["UPC", "WEEK_END_DATE"]).sum()

        pd.pivot_table(
            salescount_by_week.join(products)[["DESCRIPTION", "UNITS"]].reset_index().drop(columns=["UPC"]),
            index="WEEK_END_DATE",
            columns=["DESCRIPTION"]
        ).reset_index().plot(x="WEEK_END_DATE", y="UNITS")
        plt.show()

        # 1. 3.
        # use chi2 test with contingency table -> avg. number of products sold with and w/o (type of) promotion per week?
        # columns -> product types, rows -> (1) w/o promotion, (2) w/ promotion.
        # one contingency table per promotion type.
        # add lines in plot in weeks where promotion was offered.
