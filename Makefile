.PHONY: all clean

SRCS = $(wildcard contest02-arithmetic/*.asm)
SRCS += $(wildcard contest03-conditionals/*.asm)

PROGS = $(patsubst %.asm,%,$(SRCS))

BUILD_DIR = build

all: $(PROGS)

clean:
	rm -rf $(BUILD_DIR)

macro.o: macro.c
	mkdir -p $(BUILD_DIR)
	gcc -c -g -Wfatal-errors -fno-pie -no-pie -m32 -o $(BUILD_DIR)/macro.o macro.c

%: %.asm macro.o
	mkdir -p $(BUILD_DIR)
	nasm -g -f elf32 -DUNIX -F dwarf -o $(BUILD_DIR)/$(notdir $@.o) $<
	gcc -fno-pie -no-pie -m32 -o $(BUILD_DIR)/$(notdir $@) $(BUILD_DIR)/$(notdir $@.o) $(BUILD_DIR)/macro.o
	rm $(BUILD_DIR)/$(notdir $@.o)
