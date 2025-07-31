#!/bin/bash
ARCH="v7m"
MODE="$1"  # is, bf-inst, bf-reg

MODE="${MODE//-/_}"

postfix="_"$ARCH"_"$MODE

time python3 ../controller.py --worker 6 --fault fault"$postfix".json  --qemu qemuconf_"$ARCH".json outputs/output"$postfix".hdf5 
time python3 check_result.py $MODE
# > outputs/console"$postfix".txt 2>&1
