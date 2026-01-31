# MeowOS 🐱

**MeowOS** is a tiny, fun, weekend OS project maintained by **kernelcatz**.  
This is a minimal OS written in C and x86 assembly that boots in QEMU and prints a welcome message.

---

## Features

- Minimal bootloader in x86 assembly  
- Simple kernel written in C  
- Prints `Booting MeowOS...` and `Welcome to MeowOS!` to the screen  
- Runs in QEMU (x86_64)  

---

## File Structure

```

MeowOS/
├── boot/          # Bootloader source
│   └── bootloader.asm
├── kernel/        # Kernel source in C
│   └── kernel.c
├── build/         # Compiled binaries and disk image
├── Makefile       # Build and run commands
└── README.md      # Project info

````

---

## Build & Run

1. Make sure dependencies are installed:
```bash
sudo apt update
sudo apt install build-essential gcc-multilib nasm qemu-system-x86 make git
````

2. Build and run MeowOS:

```bash
make run
```

---
