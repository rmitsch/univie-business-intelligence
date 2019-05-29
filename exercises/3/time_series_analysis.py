import prophet
import pandas as pd


if __name__ == '__main__':
    transactions: pd.DataFrame = pd.read_csv("data_transactions.csv")
    products: pd.DataFrame = pd.read_csv("data_products_lookup.csv", index_col="UPC")
    stores: pd.DataFrame = pd.read_csv("data_store_lookup.csv", index_col="STORE_ID")

    with pd.option_context('display.max_rows', None, 'display.max_columns', None, 'display.width', None):
        print(transactions.head(100))
        print(len(transactions))
