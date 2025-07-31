import tables
import pandas as pd
import sys

def read_hdf(hdfpath):
    return tables.open_file(hdfpath, 'r')

def read_fault_hdf(hdfpath):
    f = read_hdf(hdfpath)
    fault = f.root.fault
    return fault, f

def child_to_fault_df(child):
    return pd.DataFrame(child['faults'].read())

def child_to_pc(child):
    df = pd.DataFrame(child.armregisters.read())
    # Translate to hex only for non-zero values
    return [hex(x) for x in df['pc'] if x != 0]

def is_succeeded(pcs, target_addrs=None):
    if target_addrs is None:
        target_addrs = ['0x8000178', '0x800017a', '0x800017c']
    return any(pc in target_addrs for pc in pcs)

def is_info_if_succeeded(child):
    if is_succeeded(child_to_pc(child)):
        df = child_to_fault_df(child)
        return df[['fault_address']].iloc[0].to_dict()
    return None

def bf_inst_info_if_succeeded(child):
    if is_succeeded(child_to_pc(child)):
        df = child_to_fault_df(child)
        return df[['fault_address', 'fault_mask']].iloc[0].to_dict()
    return None

def bf_reg_info_if_succeeded(child):
    if is_succeeded(child_to_pc(child)):
        df = child_to_fault_df(child)
        return df[['trigger_address', 'fault_address', 'fault_mask']].iloc[0].to_dict()
    return None

def aggregate_mask(df):
    # Calulate fault_mask as a sum of all fault_address
    return df.groupby('fault_address', as_index=False)['fault_mask'].sum()\
             .set_index('fault_address')['fault_mask'].to_dict()

def aggregate_mask_with_reg(df):
    # Remove duplicates, aggregate by trigger_address and fault_address
    return df.drop_duplicates()\
             .groupby(['trigger_address', 'fault_address'], as_index=False)['fault_mask'].sum()

def print_df_bfr(df):
    arm_regs = [f'r{x}' for x in range(13)] + ['sp', 'lr', 'pc']
    for _, row in df.iterrows():
        print(f"{row['trigger_address']:x}: {arm_regs[int(row['fault_address'])]} 0x{row['fault_mask']:x}")

def check_result_is(fault) -> list:
    children = 'experiment{:03d}'
    suc = []
    for cid in range(len(fault._v_children)):
        child = fault[children.format(cid)]
        res = is_info_if_succeeded(child)
        if res is not None:
            suc.extend(hex(val) for _, val in res.items())
    return suc

def check_result_bf_inst(fault) -> dict:
    children = 'experiment{:04d}'
    suc_list = []
    for cid in range(len(fault._v_children)):
        child = fault[children.format(cid)]
        res = bf_inst_info_if_succeeded(child)
        if res is not None:
            suc_list.append(res)
    df = pd.DataFrame(suc_list).drop_duplicates()
    df.to_csv('test.csv')

    return aggregate_mask(df)

def check_result_bf_reg(fault) -> pd.DataFrame:
    children = 'experiment{:04d}'
    suc_list = []
    for cid in range(len(fault._v_children)):
        child = fault[children.format(cid)]
        res = bf_reg_info_if_succeeded(child)
        if res is not None:
            suc_list.append(res)
    df = pd.DataFrame(suc_list).drop_duplicates()
    return aggregate_mask_with_reg(df)

if __name__ == '__main__':
    model = sys.argv[1]  # fault model: is, bf_inst, bf_reg
    dname = 'outputs'
    hdfpath = f'{dname}/output_v7m_{model}.hdf5'
    fault, f = read_fault_hdf(hdfpath)

    match model:
        case 'is':
            suc = check_result_is(fault)
            print('fault address', len(suc))
            for i in sorted(suc):
                print(i)
        case 'bf_inst':
            suc = check_result_bf_inst(fault)
            print('fault address', len(suc))
            for addr, mask in sorted(suc.items(), key=lambda x: x[0]):
                print(f'{addr:x}:0x{mask:x}')
        case 'bf_reg':
            suc = check_result_bf_reg(fault)
            print_df_bfr(suc)

    f.close()
