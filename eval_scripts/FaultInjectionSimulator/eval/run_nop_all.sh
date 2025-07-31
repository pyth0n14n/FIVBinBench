#!/bin/bash
TARGET=../../../dataset/binary/verifypin_0_x86_FIS.elf

for file_name in fault_list/*;do
    # echo ${file_name:17:6}
    ../simulator ${file_name} $TARGET > result/${file_name:17:6}.res 2>&1
done
