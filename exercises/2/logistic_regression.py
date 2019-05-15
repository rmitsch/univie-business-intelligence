import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression as SKLearnLogisticRegression
from typing import Tuple


class LogisticRegression:
    """
    Class for logistic regression. Modeled after sklearn's API.
    Implements gradient descent including learning rate as hyperparameter; cross-entropy as cost function.
    """
    def __init__(
            self,
            max_iter: int = 100,
            learning_rate: float = 0.1,
            tol: float = 1e-4,
            fit_intercept: bool = True,
            verbose: bool = False
    ):
        """
        Initialize LogisticRegression instance.
        :param max_iter: Number of iterations to fit weights/theta.
        :param learning_rate:
        :param tol: Tolerance for convergence criterion/cost function (cross entropy). If tolerance is reached,
        computation is stopped.
        :param fit_intercept:
        :param verbose:
        """
        self._max_iter = max_iter
        self._learning_rate = learning_rate
        self._theta = None
        self._tol = tol
        self._fit_intercept = fit_intercept
        self._verbose = verbose

    @staticmethod
    def _sigmoid(z: np.ndarray) -> np.ndarray:
        """
        Computes sigmoid function for computed z.
        :param z:
        :return:
        """
        return 1 / (1 + np.exp(-z))

    def fit(self, X: np.ndarray, y: np.ndarray):
        """
        Train model on x with class labels in y.
        :param X:
        :param y:
        :return:
        """

        assert X.shape[0] == y.shape[0], "Length of x, y has to be consistent."
        assert len(y.shape) == 1, "y has to be a two-dimensional vector with shape[1] == 1."

        # Add intercept, if specified.
        X = X if not self._fit_intercept else np.concatenate((np.ones((X.shape[0], 1)), X), axis=1)

        # Initialize attribute weights.
        self._theta = np.zeros(X.shape[1])

        # Iterate with gradient descent until convergence criterion is satisfied.
        stop = False
        prev_cost = 0
        epoch = 0
        while not stop:
            z = np.dot(X, self._theta)
            h = self._sigmoid(z)
            cost = (-y * np.log(h) - (1 - y) * np.log(1 - h)).mean()
            gradient = np.dot(X.T, h - y) / y.size
            self._theta -= self._learning_rate * gradient

            if epoch % (self._max_iter / 10) == 0 and self._verbose:
                print("Cross entropy at #" + str(epoch) + ": " + str(cost))

            stop = epoch == self._max_iter or abs(cost - prev_cost) < self._tol
            prev_cost = cost
            epoch += 1

        return self

    def predict_prob(self, X: np.ndarray) -> np.ndarray:
        """
        Predict class label probabilities.
        :param X:
        :return:
        """

        return self._sigmoid(np.dot(
            X if not self._fit_intercept else np.concatenate((np.ones((X.shape[0], 1)), X), axis=1),
            self._theta
        ))

    def predict(self, x: np.ndarray, threshold: float = 0.5) -> np.ndarray:
        """
        Predict target class labels for x based on set threshold and the computed probability.
        :param x:
        :param threshold:
        :return:
        """

        return self.predict_prob(x) >= threshold


def evaluate(
        X_train: np.ndarray,
        y_train: np.ndarray,
        X_test: np.ndarray,
        y_test: np.ndarray,
        use_own: bool = True,
        learning_rate: float = None
) -> Tuple[float, float, float, float]:
    """
    Trains and evaluates own or sklearn's logistic regression model.
    :param X_train:
    :param y_train:
    :param X_test:
    :param y_test:
    :param use_own:
    :param learning_rate:
    :return: Counts of true positives, false positives, true negatives, false negatives.
    """
    ground_truth = y_test.flatten()

    if use_own:
        assert learning_rate > 0, "Learning rate has to be set."
        logreg = LogisticRegression(max_iter=100000, learning_rate=learning_rate, tol=1e-16, fit_intercept=True)
        logreg.fit(X_train, y_train.flatten())
        predictions = logreg.predict(X_test)
    else:
        logreg = SKLearnLogisticRegression(max_iter=10000)
        logreg.fit(X_train, y_train.flatten())
        predictions = logreg.predict(X_test)

    return \
        np.count_nonzero(predictions[np.where(ground_truth == 1)]), \
        np.count_nonzero(predictions[np.where(ground_truth == 0)]), \
        np.count_nonzero(predictions[np.where(ground_truth == 0)] == 0), \
        np.count_nonzero(predictions[np.where(ground_truth == 1)] == 0)


if __name__ == '__main__':
    wine_df = pd.read_csv("winequality_binary.csv").drop(columns=["Unnamed: 0"])
    features = wine_df.drop(columns=["quality"])
    labels = wine_df[["quality"]]

    # Check distribution of class labels.
    unique, counts = np.unique(labels.values, return_counts=True)
    print(counts)

    # todo documentation (in readme.md?)

    #############################################################
    # 3. Logistic regression.
    #############################################################

    print("*** Evalution + hyperparameter search ***")

    # Search for best parameter for learning rate, compare with sklearn implementation.
    learning_rates = (5e-2, 1e-2, 5e-3, 1e-3, 5e-4, 1e-4)
    n_splits = 3
    f1_scores = {lr: 0 for lr in learning_rates}
    f1_scores["sklearn"] = 0

    for j in range(n_splits):
        print("  In split", j + 1)

        X_train, X_test, y_train, y_test = train_test_split(features.values, labels.values, test_size=0.33)

        # Evaluate own implementation with different parametrizations.
        for learning_rate in learning_rates:
            print("    learning rate =", learning_rate)
            tp, fp, tn, fn = evaluate(X_train, y_train, X_test, y_test, learning_rate=learning_rate)
            precision = tp / (tp + fp)
            recall = tp / (tp + fn)
            f1_scores[learning_rate] += 2 * precision * recall / (precision + recall)

        # Evaluate with sklearn.
        tp, fp, tn, fn = evaluate(X_train, y_train, X_test, y_test, use_own=False)
        precision = tp / (tp + fp)
        recall = tp / (tp + fn)
        f1_scores["sklearn"] += 2 * precision * recall / (precision + recall)

    print()
    for config in f1_scores:
        f1_scores[config] /= n_splits
        print("  " + str(config) + ": " + str(f1_scores[config]))

    """
    Results:
        0.05: 0.5840340647924539
        0.01: 0.5380163567042477
        0.005: 0.614820755370253
        0.001: 0.7642765172368294
        0.0005: 0.7660003151664713
        0.0001: 0.7514410109570223
        
        sklearn: 0.7708290874277166
    """
