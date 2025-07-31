# Makefile script with commands to generate the benchmark assembly and binaries.
# Description of the targets:
# x86-ptc: produce lazart object files with oracle PTC
# x86-auth: produce lazart object files with oracle AUTH
# clean: clean generated files, including output binaries

.PHONY: clean copy x86 x86_FIS x86_sleep

TARGET = verifypin_0_$@
FILES = src/countermeasure.c src/initialize.c src/oracle.c src/code.c src/main.c

INC_DIR = -I../share -Iinclude
BIN_DIR = bin

CFLAGS = $(INC_DIR) -Wl,-Map,$(BIN_DIR)/$(TARGET).map
CFLAGS += -g -O0

LDFLAGS = -static

ASM_DIR = asm
ASMFLAGS = $(INC_DIR) -Wall -Wpedantic -std=c11 -O0

DMP = objdump

common:
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(ASM_DIR)

x86: common
	$(CC) -DAUTH $(FILES) $(CFLAGS) -o $(BIN_DIR)/$(TARGET).elf
	$(DMP) -D $(BIN_DIR)/$(TARGET).elf > $(BIN_DIR)/$(TARGET).dump

	$(CC) $(ASMFLAGS) -E $(FILES) > $(ASM_DIR)/$(TARGET).i
	$(CC) $(ASMFLAGS) -S $(ASM_DIR)/$(TARGET).i -o $(ASM_DIR)/$(TARGET).S

# for FaultInjectionSimulator
x86_FIS: common
	$(CC) -DFAULT_INJECTION_SIMULATOR $(LDFLAGS) $(FILES) $(CFLAGS) -o $(BIN_DIR)/$(TARGET).elf
	$(DMP) -D $(BIN_DIR)/$(TARGET).elf > $(BIN_DIR)/$(TARGET).dump

	$(CC) $(ASMFLAGS) -E $(FILES) > $(ASM_DIR)/$(TARGET).i
	$(CC) $(ASMFLAGS) -S $(ASM_DIR)/$(TARGET).i -o $(ASM_DIR)/$(TARGET).S

x86_sleep: common
	$(CC) -DSLEEP $(LDFLAGS) $(FILES) $(CFLAGS) -o $(BIN_DIR)/$(TARGET).elf
	$(DMP) -D $(BIN_DIR)/$(TARGET).elf > $(BIN_DIR)/$(TARGET).dump

	$(CC) $(ASMFLAGS) -E $(FILES) > $(ASM_DIR)/$(TARGET).i
	$(CC) $(ASMFLAGS) -S $(ASM_DIR)/$(TARGET).i -o $(ASM_DIR)/$(TARGET).S

copy:
	cp $(BIN_DIR)/* /home/nashimoto/FIA/target/binary/

clean:
	@rm -rf $(BIN_DIR)
