# Exercise 3

## 1. Bayes' Theorem

Note: We assume that 0.5% of the population are drug users, not 0.05% - otherwise the percentages of drug users and non-users don't add up to 100.
No code is provided for this example, results were computed manually.

P(A|B) = P(B|A)P(A) / P(B)

Here: 
* P(A|B) -> Probability of observing that a randomly selected individual is not a drug user given a positive drug test. P(A|B) = ?
* A -> Not a drug user. P(A) = 0.995, P(¬A) = 1 - P(A) = 0.005.
* B -> Positive drug test. P(B) = P(A) * 0.01 + P(¬A) * 0.99 = 0.995 * 0.01 + 0.005 * 0.99 = 0.00995 + 0.00495 = 0.0149.
* P(B|A) -> Probability of observing a positive drug test given a non-user. P(B|A) = 0.01.

Hence:
P(A|B) = 0.01 * 0.995 / 0.0149 = 0.6677852349 ~ 66.7%  

**Interpretation**: Due to the group of non-users being the vast majority, the test (with a sensitivity of 99%) generates more false positives than true positives. 

## A-B Testing

Code can be found in `a_b_testing.py`. 

### Traffic Split and Conversion Rate
*(a) In what proportion did the company split the landing page?*  
40000:60000 = 40.0% of all visits were redirected to the new page.   

*(b) What is the conversion rate for each version of the landing page?*  
* Old page: `0.12063333333333333`. 
* New page: `0.1191`.

### Binomial Test 
We phrase H_0 as follows: The probability of observing the specified number of conversions with the specified landing 
page version is not higher than 50%. This is a rephrased variant of the original hypothesis of "the probability of 
conversion does not depend on the landing page". We used `p = 0.5` to reflect the equaliy assumption in H_0.

Probability of observing observed number of conversations given the assumptions above and using scipy's binomial test:
* Old page: `6.317471224286417e-114`. 
* New page: `0.9999999999999999`.

Assuming a significance level of 0.05, we can interpret this result as follows: 
* The probability for the old landing page is lower than our alpha. This means we can reject H_0 - 
that the old landing page's chance of success is not higher than 50% when compare with the new landing page.
* The probability for the new landin page is higher than our alpha. This means we cannot reject H_0 and the new landing 
page's chance of success compared to the old version is indeed not higher than 50%.

Intuitively speaking, this makes sense - the number of conversions stemming from the old landing page are considerably 
higher than the one from the new one and we have thousands of samples, so we would expect the old landing page having a 
more than even chance of success when compared to the new version.
  
### Chi-squared and Normal Test
We assume H_0 to state that there is no significant difference in conversion rates between landing page versions.

Significances in differences in conversion rates w.r.t. landing page versions.
* χ2: `p = 0.4709069331806466`.
* normality test: `p = 0.6616312516159468`.

The χ2 result was computed by aggregating the available data to a contingency table before using scipy's 
`chi2_contingency`. The normal test was computed manually by following the equation in the slides - computing 
`t_a, t_b, z` as consequence of the number of successes and the numbers of tries and then retrieving the p-value 
via the computed z-score.

We can interpret both (χ2 and normal test) results the same way: We can hence reject H_0, i. e. the claim that there is
significant differences in conversion rates between landing pages is false.
This conclusion is in agreement with both the result from the binomial tests and our intuition.

## Logistic Regression

Code can be found in `logistic_regression.py`.

We compared our implementation with sklearn's `sklearn.linear_model.LogisticRegression` and mimicked parts of its 
interfaces. While our model takes considerably longer to converge, it approximates sklearn's accuracy closely when the 
right learning rate is chosen. We choose the F1 score to reflect the quality of the prediction for our evaluation. Our 
implementation stops whenver the maximum number of iterations is reached or the result of the loss function converges to 
a value that is lower than the specified threshold. We used a train-test split with a proportion of 2/3 : 1/3.

Utilizing a grid search, the best learning rate seems to be 0.001. In the following a list of tried learning rate values 
together with the computed F1-score:
```
0.05:    0.5840340647924539
0.01:    0.5380163567042477
0.005:   0.614820755370253
0.001:   0.7642765172368294
0.0005:  0.7660003151664713
0.0001:  0.7514410109570223
sklearn: 0.7708290874277166
```
As can be seen here, sklearn's implementation beats our vanilla implementation (using a learning rate of 0.001)
by a tiny fraction, but the difference is marginal. Note that we didn't optimize the hyperparameters for sklearn's LR 
however.

## Confidence Interval of the Prediction Accuracy

We assumed a confidence level of 0.95 and ran all tests with our vanilla implementatin of logistic regresion and the 
optimal learning rate found in the previous task. We implemented pseudocode for bootstrapping we found online and the
same evaluation methds as for the previous task to gather a accuracy statistic. Following that, we pick the alpha-/
confidence level-percentiles from this statistic.

We used a train-test split with a proportion of 0.5 : 0.5, following sklearn's default values. We ran 50 iterations. 
Predicting the results with these pre-conditions yields a 0.95-confidence of `(70.09375, 75.78645833333333)`.