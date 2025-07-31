#!/bin/bash

# example: run_fault_finder.sh v7m fault-is

VOLUME_OPTS="-v $(pwd)/eval:/usr/src/faultfinder/eval -v $(pwd)/../../dataset/binary:/usr/src/faultfinder/eval/bins"

ARCH="$1"  # v7m, PIE, x86
MODE="$2"  # golden, stats, fault-is, fault-bf-reg, fault-bf-inst
INIT="$3"  # no-init, ""  ; no-init means no rehosting
echo $ARCH
echo $INIT

case "$MODE" in
  golden) MODE="goldenrun_full" ;;
  *) MODE="${MODE//-/_}" ;;
esac

if [ -n "$INIT" ]; then
  INIT="_no_init"
fi

JSON_FILE="my_research/${ARCH}/jsons/${MODE}${INIT}.json"
# OUTPUT_FILE="my_research/${ARCH}/outputs/${MODE}/0000.txt"
OUTPUT_DIR="my_research/${ARCH}/outputs/${MODE}"
SUCCESS_FILE="my_research/res_${ARCH}_${MODE}${INIT}.txt"

echo $JSON_FILE

time docker run --rm -it $VOLUME_OPTS faultfinder "$JSON_FILE"

if [[ "$MODE" = "fault"* ]]; then
  time python success_check.py $OUTPUT_DIR > $SUCCESS_FILE
  cat $SUCCESS_FILE
fi
