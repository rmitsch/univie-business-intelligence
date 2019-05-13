import pandas as pd
from scipy.stats import chi2, chi2_contingency, norm, normaltest, binom_test


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
    # Interpretation: We can reject H_0 (probability of conversion does not depend on landing page version).

    # 2.3. Under the same null hypothesis use the χ-squared test and the normal-test to measure the significance of the
    # difference in the conversion-rates of the landing page versions.
    # scipy.stats.chi2.cd with df=1
    # scipy.stats.norm
    x = norm.rvs(size=100)
    print(x.shape)
    # todo how to compute normal test for significance test?
    print(contingency_table)
    stat, p_chi2, dof, expected = chi2_contingency(contingency_table.values)
    print(
        "\n2.3. Significances in differences in conversion rates w.r.t. landing page versions.\n",
        "χ2: p = " + str(p_chi2)
    )
