.PHONY: all clean

BUILD_DIR = build

ASM_SRCS = $(wildcard */*.asm)
C_SRCS = $(wildcard */*.c)

ASM_PROGS = $(patsubst %.asm,$(BUILD_DIR)/%,$(ASM_SRCS))
C_PROGS = $(patsubst %.c,$(BUILD_DIR)/%,$(C_SRCS))


all: $(ASM_PROGS) $(C_PROGS)

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR)/macro.o: macro.c
	mkdir -p $(BUILD_DIR)
	gcc -c -g -ggdb -Og -Wfatal-errors -fno-pie -no-pie -m32 -o $(BUILD_DIR)/macro.o macro.c

$(BUILD_DIR)/%: %.asm $(BUILD_DIR)/macro.o
	mkdir -p $(dir $@)
	nasm -g -f elf32 -DUNIX -F dwarf -o $@.o $<
	gcc -g -ggdb -Og -fno-pie -no-pie -m32 -o $@ $@.o $(BUILD_DIR)/macro.o
	rm $@.o
	
$(BUILD_DIR)/%: %.c
	mkdir -p $(dir $@)
	gcc -Og -Wall -Wformat-security -Wignored-qualifiers -Winit-self -Wswitch-default -Wfloat-equal -Wpointer-arith -Wtype-limits -Wempty-body -Wno-logical-op -Wstrict-prototypes -Wold-style-declaration -Wold-style-definition -Wmissing-parameter-type -Wmissing-field-initializers -Wnested-externs -Wno-pointer-sign -Wno-unused-result -std=gnu99 -lm -g -ggdb -m32 -o $@ $<
