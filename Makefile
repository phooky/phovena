# Architectures: armv7, 64b?
#isa ?= armv7
#chip ?= imx6

arch ?= cortex-a9
kernel := build/kernel-$(arch).bin
image := build/img-$(arch)

fits_src := src/arch/$(arch)/phovena.its

rust_os := target/$(target)/debug/libdumbos.a

tool_prefix ?= arm-none-eabi
assembler := $(tool_prefix)-as
linker := $(tool_prefix)-ld

linker_script := src/arch/$(arch)/linker.ld
asm_src := $(wildcard src/arch/$(arch)/*.asm)
asm_obj := $(patsubst src/arch/$(arch)/%.asm, \
	build/arch/$(arch)/%.o, $(asm_src))

.PHONY: all clean run iso

all: $(kernel)

clean:
	@rm -r build

run: $(image)
	qemu-system-arm -M vexpress-a9 -m 1024M -nographic -kernel u-boot

debug: $(image)
	qemu-system-arm -M vexpress-a9 -m 1024M -nographic -s -S -kernel u-boot

image: $(image)

kernel: $(kernel)

$(image): $(kernel)
	$(tool_prefix)-objcopy --only-section=.text -O binary $(kernel) $(image)
	@cp $(image) /var/lib/tftpboot

old-$(image): $(kernel) $(fits_src)
	@mkdir -p build
	@cp $(fits_src) build
	mkimage -f build/$(notdir $(fits_src)) $(image)
	@cp $(image) /var/lib/tftpboot

$(kernel): $(asm_obj) $(linker_script)
	$(linker) -n --gc-sections -o $(kernel) -T $(linker_script) $(asm_obj)

build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	$(assembler) $< -o $@

cargo:
	@cargo rustc --target=$(target) -- -Z no-landing-pads

