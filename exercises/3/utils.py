import os
import pandas as pd
from fbprophet import Prophet
import numpy as np
import matplotlib.pyplot as plt


class suppress_stdout_stderr(object):
    """
    A context manager for doing a "deep suppression" of stdout and stderr in
    Python, i.e. will suppress all print, even if the print originates in a
    compiled C/Fortran sub-function.
       This will not suppress raised exceptions, since exceptions are printed
    to stderr just before a script exits, and after the context manager has
    exited (at least, I think that is why it lets exceptions through).
    Source: https://stackoverflow.com/questions/11130156/suppress-stdout-stderr-print-from-python-functions.
    """

    def __init__(self):
        # Open a pair of null files
        self.null_fds = [os.open(os.devnull, os.O_RDWR) for x in range(2)]
        # Save the actual stdout (1) and stderr (2) file descriptors.
        self.save_fds = (os.dup(1), os.dup(2))

    def __enter__(self):
        # Assign the null pointers to stdout and stderr.
        os.dup2(self.null_fds[0], 1)
        os.dup2(self.null_fds[1], 2)

    def __exit__(self, *_):
        # Re-assign the real stdout/stderr back to (1) and (2)
        os.dup2(self.save_fds[0], 1)
        os.dup2(self.save_fds[1], 2)
        # Close the null files
        os.close(self.null_fds[0])
        os.close(self.null_fds[1])


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


def run_prophet_configuration_wrapper(args) -> dict:
    """
    Wrapper for multiprocessing runs of run_prophet_configuration().
    :param args:
    :return:
    """
    return evaluate_prophet_configuration(*args)


def evaluate_prophet_configuration(
        upc: int, config: list, base_df: pd.DataFrame, holidays: pd.DataFrame = None
) -> dict:
    """
    Runs and evaluates specified Prophet configuration.
    :param upc:
    :param config:
    :param base_df:
    :param holidays:
    :return:
    """
    # Split in train and test set.
    split_date = base_df.max()["ds"] - pd.Timedelta(4, unit='w')
    train_set = base_df[base_df.ds <= split_date]
    test_set = base_df[base_df.ds > split_date]

    with suppress_stdout_stderr():
        proph = Prophet(
            yearly_seasonality=config[0],
            weekly_seasonality=config[2],
            daily_seasonality=config[3],
            seasonality_mode=config[4],
            n_changepoints=config[5],
            holidays=holidays
        )
        if config[1]:
            proph.add_seasonality(name='monthly', period=30.5, fourier_order=3)
        proph.fit(train_set)
        future = proph.make_future_dataframe(periods=4, freq="W")

    # Return configuration + MSE result.
    return {
        "UPC": upc,
        "yearly_seasonality": config[0],
        "monthly_seasonality": config[1],
        "weekly_seasonality": config[2],
        "daily_seasonality": config[3],
        "seasonality_mode": config[4],
        "n_changepoints": config[5],
        "MSE": np.mean(np.power(test_set.y - proph.predict(future).yhat.tail(4), 2))
    }


def plot_salescount_per_week(
        transactions: pd.DataFrame, products: pd.DataFrame, upcs: set, title: str
):
    """
    Plot salescount per week.
    :param transactions:
    :param products:
    :param upcs: UPCs to be drawn.
    :param title:
    :return:
    """

    salescount_by_week = compute_salescount_per_week(transactions, upcs)
    salescount_by_week_plot_df = compute_salescount_per_week_plot_df(salescount_by_week, products)

    plt.figure(figsize=(20, 10))
    ax = plt.plot(salescount_by_week_plot_df.WEEK_END_DATE, salescount_by_week_plot_df.UNITS)
    plt.gca().legend([
        desc[1] for desc in salescount_by_week_plot_df.reset_index().columns.values if desc[0] == "UNITS"
    ])
    plt.title(title)

    return ax
