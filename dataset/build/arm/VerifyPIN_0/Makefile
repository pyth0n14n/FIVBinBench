
# Makefile script with commands to generate the benchmark assembly and binaries.
# Description of the targets:
# x86-ptc: produce lazart object files with oracle PTC
# x86-auth: produce lazart object files with oracle AUTH
# clean: clean generated files, including output binaries

.PHONY: clean copy v7m PIE

TARGET = verifypin_0_arm_$@
FILES = $(wildcard src/*.c)
LDSCRIPT = ./linker_v7m.ld

INC_DIR = -I../share -Iinclude
BIN_DIR = bin

DMP = arm-none-eabi-objdump

CFLAGS = $(INC_DIR) -Wl,-Map,$(BIN_DIR)/$(TARGET).map
CFLAGS += -g -O0

ASM_DIR = asm
ASMFLAGS = $(INC_DIR) -Wall -Wpedantic -std=c11 -O0

# commonized
CC_V7M = arm-none-eabi-gcc
CC_PIE = arm-linux-gnueabi-gcc

CFLAGS_V7M = $(CFLAGS) -mcpu=cortex-m3 -mthumb -march=armv7-m -Wl,-static -nostartfiles -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group -T $(LDSCRIPT)
CFLAGS_PIE = $(CFLAGS) -fPIE -march=armv7-a -marm -pie -lc

ASMFLAGS_V7M = $(ASMFLAGS) -mcpu=cortex-m3 -mthumb
ASMFLAGS_PIE = $(ASMFLAGS) -fPIE -march=armv7-a -marm -pie -lc

common:
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(ASM_DIR)

v7m: common
	$(CC_V7M) -DAUTH $(FILES) $(CFLAGS_V7M) -o $(BIN_DIR)/$(TARGET).elf
	$(DMP) -D $(BIN_DIR)/$(TARGET).elf > $(BIN_DIR)/$(TARGET).dump

	$(CC_V7M) $(ASMFLAGS_V7M) -E $(FILES) > $(ASM_DIR)/$(TARGET).i
	$(CC_V7M) $(ASMFLAGS_V7M) -S $(ASM_DIR)/$(TARGET).i -o $(ASM_DIR)/$(TARGET).S

PIE: common
	$(CC_PIE) -DPRINTF $(FILES) $(CFLAGS_PIE) -o $(BIN_DIR)/$(TARGET).elf
	$(DMP) -D $(BIN_DIR)/$(TARGET).elf > $(BIN_DIR)/$(TARGET).dump

	$(CC_PIE) $(ASMFLAGS_PIE) -E $(FILES) > $(ASM_DIR)/$(TARGET).i
	$(CC_PIE) $(ASMFLAGS_PIE) -S $(ASM_DIR)/$(TARGET).i -o $(ASM_DIR)/$(TARGET).S

copy:
	cp $(BIN_DIR)/*.elf /home/nashimoto/FIA/target/binary/
	cp $(BIN_DIR)/*.dump /home/nashimoto/FIA/target/binary/
	cp $(BIN_DIR)/*.map /home/nashimoto/FIA/target/binary/

clean: 
	@rm -rf $(BIN_DIR) $(ASM_DIR)