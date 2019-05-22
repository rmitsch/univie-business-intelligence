import pandas as pd
import numpy as np
from logistic_regression import evaluate
from sklearn.model_selection import train_test_split
from typing import Tuple


def compute_bootstrap_accuracy(
        X: np.ndarray,
        y: np.ndarray,
        alpha: float = 0.95,
        n_bootstraps: int = 50,
        n_train: float = 0.5,
        learning_rate: float = 0.0005
) -> Tuple[float, float]:
    """
    Compute bootstrap-confidence interval for classification of test set with confidence as specified.
    Parameters similar to sklearn's sklearn.cross_validation.Bootstrap.
    :param X:
    :param y:
    :param alpha:
    :param n_bootstraps:
    :param n_train:
    :param learning_rate:
    :return:
    """

    # Compute statistics.
    stats = []
    for i in range(n_bootstraps):
        print("  Iteration #" + str(i))
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=1 - n_train)
        tp, fp, tn, fn = evaluate(X_train, y_train, X_test, y_test, learning_rate=learning_rate)
        stats.append((tp + tn) / (tp + tn + fp + fn))
        print((tp + tn) / (tp + tn + fp + fn))

    # Compute confidence interval.
    return \
        max(0.0, np.percentile(stats, ((1.0 - alpha) / 2.0) * 100)) * 100, \
        min(1.0, np.percentile(stats, (alpha + ((1.0 - alpha) / 2.0)) * 100)) * 100


if __name__ == '__main__':
    wine_df = pd.read_csv("winequality_binary.csv").drop(columns=["Unnamed: 0"])
    features = wine_df.drop(columns=["quality"])
    labels = wine_df[["quality"]]

    #############################################################
    # Confidence interval of prediction accuracy.
    #############################################################

    print("*** Bootstrapping ***")
    print(compute_bootstrap_accuracy(features.values, labels.values, n_bootstraps=50, n_train=0.7))

    """
    Results for 0.95 confidence interval with 50 iterations: (70.09375, 75.78645833333333).
    """