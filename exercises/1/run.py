import pandas as pd
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str)
    args = parser.parse_args()

    df = pd.read_excel(args.input, sheet_name=0)
    with pd.option_context('display.max_rows', None, 'display.max_columns', None, 'display.width', None):
        print(df)
