import re
import sys
import glob

def summarize_mask(res_list):
    sum_mask = {}

    for res in res_list:
        try:
            tmp, mask = res.split('0x')
        except ValueError:
            return res_list

        try:
            model, op, reg = tmp.strip().split(' ')
        except ValueError:
            model, op = tmp.strip().split(' ')
            reg = 'inst'

        if reg in sum_mask:
            sum_mask[reg] += int(mask, 16)
        else:
            sum_mask[reg] = int(mask, 16)

    li = []
    for reg, mask in sum_mask.items():
        li.append(f'{model} {op} {reg} 0x{mask:x}')

    return li


def extract_fault_addresses(filename, extracted_addresses={}):
    with open(filename, "r") as file:
        data = file.read()

    # Split block for each run
    blocks = data.split("##### Starting new run.")

    for block in blocks:
        if "Reached a hard stop address" in block:
            # Fault Address の値を検索
            address = re.search(r"Address:\s+(0x[0-9a-fA-F]+)\.", block).group(1)
            model_target = re.search(r"Faulting Target:\s+(.+?)\.", block).group(1)
            op = re.search(r"Operation:\s+(.+?)\.", block).group(1)

            match = re.search(r"Reg#:\s+(.+?)\.", block)
            reg = match.group(1) if match else ''

            match = re.search(r"Mask:\s+(0x[0-9a-fA-F]+)\.", block)
            mask = match.group(1) if match else ''

            result = f"{model_target} {op} {reg} {mask}"

            if address in extracted_addresses:
                extracted_addresses[address].append(result)
                extracted_addresses[address] = list(set(extracted_addresses[address]))  # 重複削除
            else:
                extracted_addresses[address] = [result]
    return extracted_addresses


def print_fault_result(extracted_addresses: dict):
    if extracted_addresses:
        print(f"Extracted Fault Addresses: {len(extracted_addresses)}")
        # print("\n".join(sorted(extracted_addresses.keys())))

        # unique_len = len([len(x) for x in extracted_addresses.values()])

        for key, res_list in sorted(extracted_addresses.items()):
            print(key, end='  : ')
            space = ' ' * (len(key) + 4)
            # if len(res_list) != 1:
            res_list = summarize_mask(set(res_list))

            for itr, res in enumerate(set(res_list)):
                if itr > 0:
                    print(space + res)
                else:
                    print(res)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        # print(f"Usage: {sys.argv[0]} <filename>")
        # sys.exit(1)
        dir_name = './eval/PIE/outputs'
    else:
        dir_name = sys.argv[1]

    addresses = {}
    for fname in glob.glob(f'{dir_name}/[0-9][0-9][0-9][0-9].txt'):
        print(fname)
        addresses = extract_fault_addresses(fname, extracted_addresses=addresses)
    # Check all items
    all_items = [x for sub in addresses.values() for x in sub]
    print(f'#extracted: {len(all_items)}')
    print_fault_result(addresses)
