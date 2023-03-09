.PHONY: all clean

BUILD_DIR = build

SRCS = $(wildcard contest02-arithmetic/*.asm)
SRCS += $(wildcard contest03-conditionals/*.asm)

PROGS = $(patsubst %.asm,$(BUILD_DIR)/%,$(SRCS))


all: $(PROGS)

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR)/macro.o: macro.c
	mkdir -p $(BUILD_DIR)
	gcc -c -g -Wfatal-errors -fno-pie -no-pie -m32 -o $(BUILD_DIR)/macro.o macro.c

$(BUILD_DIR)/%: %.asm $(BUILD_DIR)/macro.o
	mkdir -p $(dir $@)
	nasm -g -f elf32 -DUNIX -F dwarf -o $@.o $<
	gcc -fno-pie -no-pie -m32 -o $@ $@.o $(BUILD_DIR)/macro.o
	rm $@.o
