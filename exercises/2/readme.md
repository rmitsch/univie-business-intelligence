# Exercise 3

## 1. Bayes' Theorem

Note: We assume that 0.5% of the population are drug users, not 0.05% - otherwise the percentages of drug users and non-users don't add up to 100.

P(A|B) = P(B|A)P(A) / P(B)

Here: 
* P(A|B) -> Probability of observing that a randomly selected individual is not a drug user given a positive drug test. P(A|B) = ?
* A -> Not a drug user. P(A) = 0.995, P(¬A) = 1 - P(A) = 0.005.
* B -> Positive drug test. P(B) = P(A) * 0.01 + P(¬A) * 0.99 = 0.995 * 0.01 + 0.005 * 0.99 = 0.00995 + 0.00495 = 0.0149.
* P(B|A) -> Probability of observing a positive drug test given a non-user. P(B|A) = 0.01.

Hence:
P(A|B) = 0.01 * 0.995 / 0.0149 = 0.6677852349 ~ 66.7%

Interpretation: Due to the group of non-users being the vast majority, the test (with a sensitivity of 99%) generates more false positives than true positives. 