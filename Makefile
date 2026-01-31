all: build/meow.img

# Assemble bootloader
build/bootloader.bin: boot/bootloader.asm
	nasm -f bin boot/bootloader.asm -o build/bootloader.bin

# Compile kernel
build/kernel.bin: kernel/kernel.c
	gcc -m32 -ffreestanding -c kernel/kernel.c -o build/kernel.o
	gcc -m32 -Ttext 0x1000 -ffreestanding -O2 -nostdlib build/kernel.o -o build/kernel.bin

# Create bootable disk image
build/meow.img: build/bootloader.bin build/kernel.bin
	dd if=/dev/zero of=build/meow.img bs=512 count=2880
	dd if=build/bootloader.bin of=build/meow.img conv=notrunc
	dd if=build/kernel.bin of=build/meow.img bs=512 seek=1 conv=notrunc

# Run MeowOS in QEMU
run: build/meow.img
	qemu-system-x86_64 -drive format=raw,file=build/meow.img

clean:
	rm -rf build/*
