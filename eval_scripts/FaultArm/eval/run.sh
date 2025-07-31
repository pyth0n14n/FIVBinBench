#!/bin/bash
# x86, arm_PIE, or arm_v7m
TARGET=verifypin_0_$@
DIR=../../../dataset/asm

time python ../main.py $DIR/$TARGET.S > result_$TARGET.txt

