import csv
import re
import sys
import pandas as pd

def parse_nop(fname: str) -> list:
    results = []
    # Read the CSV file and process each row
    with open(fname, 'r') as f:
        reader = csv.reader(f)
        for row in reader:
            # row[2] is text (need change depending on file format)
            text = row[2]
            if text in ['', b'']:
                continue
            # Extract "g_authenticated" with regex
            match_auth = re.search(r'g_authenticated\s*=\s*(\d+)', text)
            #print(text, row)
            if match_auth and int(match_auth.group(1)) != 0:
                # Extract "nop_0x???" from row[1]
                match_nop = re.search(r'nop_(0x[0-9a-fA-F]+)-', row[1])
                if match_nop:
                    # Format to "FLP, 0xNUM", add it toresults
                    results.append(f"FLP:{match_nop.group(1)}")
    return results


def parse_flp(fname: str) -> list:
    df = pd.read_csv(fname, names=['elf', 'addr_bit', 'stdout', 'stderr', 'return code', 'timeout']).fillna('')

    df_valid = df[(~df['stdout'].str.contains('g_authenticated = 0')) & (df['stdout'].str.contains('g_authenticated'))]
    df_valid = df_valid[['addr_bit', 'stdout']]
    df_valid['addr'] = df_valid['addr_bit'].str.extract(r'0x([0-9a-f]+)')
    df_valid['mask'] = df_valid['addr_bit'].str.extract(r'sgnf_(\d+)')

    # df_valid['mask'] = df_valid['mask'].apply(lambda x: 1 << int(x))
    df_valid['g_authenticated'] = df_valid['stdout'].str.extract(r"g_authenticated\s*=\s*([0-9a-f]+)")

    df_valid.drop(['stdout', 'addr_bit'], axis=1, inplace=True)
    df_valid = df_valid.sort_values(['addr', 'mask'])

    # Apply 4-byte alignment
    df_valid["aligned_addr"] = df_valid["addr"].apply(lambda x: int(x, 16) & ~0x3)

    # Update mask (4 + 8 * (original_addr - aligned_addr))
    df_valid["adjusted_mask"] = df_valid.apply(lambda row: int(row["mask"]) + 8 * (int(row["addr"], 16) - row["aligned_addr"]), axis=1)

    df_valid['mask'] = df_valid['adjusted_mask'].apply(lambda x: 1 << int(x))
    df_valid["addr"] = df_valid["aligned_addr"].apply(hex)
    df_valid = df_valid[['addr', 'mask']]

    df_group = df_valid.groupby("addr", as_index=False)["mask"].sum()
    df_group['mask'] = df_group['mask'].apply(lambda x: hex(x))

    li = df_group.apply(lambda row: f"{row['addr']}:{row['mask']}", axis=1).tolist()
    return li

if __name__== '__main__':
    arch = sys.argv[1]  # x86, arm_PIE
    model = sys.argv[2]  # flp, nop

    fname = f'results-verifypin_0_{arch}.elf-{model}.csv'

    match model:
        case 'flp':
            res = parse_flp(fname)
        case 'nop':
            res = parse_nop(fname)
        case _:
            print('error')
            res = []

    print(len(res))
    for line in sorted(res):
        print(line)