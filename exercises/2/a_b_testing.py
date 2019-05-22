import pandas as pd
from scipy.stats import chi2_contingency, binom_test
from scipy.special import ndtr
import numpy as np


if __name__ == '__main__':
    df = pd.read_csv("ab_data.csv")
    num_new_page = len(df[df.landing_page == "new_page"])
    num_old_page = len(df[df.landing_page == "old_page"])
    num_conversions = len(df[df.converted == 1])
    num_conversions_old = len(df[(df.landing_page == "old_page") & (df.converted == 1)])
    num_conversions_new = len(df[(df.landing_page == "new_page") & (df.converted == 1)])
    contingency_table = pd.crosstab(df.landing_page, df.converted)

    with pd.option_context('display.max_rows', None, 'display.max_columns', None, 'display.width', None):
        print(df.head(10))
        print(len(df))
        print()

    # 2.1a. In what proportion did the company split the landing page?

    print(
        "2.1a. In what proportion did the company split the landing page?\n",
        str(num_new_page) + ":" + str(num_old_page),
        "= " + str(num_new_page / len(df) * 100) + "% of all visits were redirected to the new page. "
    )

    # 2.1b. What is the conversion rate for each version of the landing page?
    print(
        "2.1b. What is the conversion rate for each version of the landing page?\n",
        " Old page: " + str(num_conversions_old / num_old_page) + ".",
        "\n  New page: " + str(num_conversions_new / num_new_page) + ".",
    )

    # 2.2. Under the hypothesis that the probability of conversion does not depend on the version of the landing page
    # with the help of a binomial-test find how likely it is to observe the number of conversions as extreme as the one
    # for the old landing page and the one for the new landing page.
    print(
        "\n2.2. Probability of observing observed number of conversations if probability of conversation does not "
        "depend on landing page version.\n",
        " Old page: " + str(binom_test(num_conversions_old, n=num_conversions, p=0.5, alternative='two-sided')) + ".",
        "\n  New page: " + str(binom_test(num_conversions_new, n=num_conversions, p=0.5, alternative='two-sided')) + "."
    )
    # p = 1.2634942448572834e-113.
    # Interpretation: We can reject H_0 (probability of conversion does not depend on landing page version).

    # 2.3. Under the same null hypothesis use the χ-squared test and the normal-test to measure the significance of the
    # difference in the conversion-rates of the landing page versions. Same H_0 as in 2.2.

    t_a = num_conversions_old / num_old_page
    t_b = num_conversions_new / num_new_page
    z = (t_a - t_b) / np.sqrt(
        np.std(df[df.landing_page == "old_page"].converted) / num_old_page +
        np.std(df[df.landing_page == "new_page"].converted) / num_new_page
    )

    stat, p_chi2, dof, expected = chi2_contingency(contingency_table.values)
    print(
        "\n2.3. Significances in differences in conversion rates w.r.t. landing page versions.\n",
        "χ2: p = " + str(p_chi2) +
        "normality test: p = " + str(ndtr(z))
    )
    # Interpretation: Both computed p-values are low, certainly lower than a reasonable alpha, hence we reject H_0 (that
    # conversions do not depend on the landing page version).

"""
Hi,

I have a question regarding task 2 in exercise 3 - I don't quite understand how to apply a test of normality to measure the significance in difference of conversion rates, since the it only measures how likely the normal distribution is for a given data series.

I'd appreciate any hints - thanks!
"""