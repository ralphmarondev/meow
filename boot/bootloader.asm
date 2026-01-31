[org 0x7C00]
[bits 16]

start:
    mov [BOOT_DRIVE], dl   ; ✅ save boot drive

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, welcome_msg
.print:
    lodsb
    cmp al, 0
    je load_kernel
    mov ah, 0x0E
    int 0x10
    jmp .print

load_kernel:
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]   ; ✅ correct drive
    mov bx, 0x1000
    int 0x13

    jc disk_error

    jmp 0x0000:0x1000

disk_error:
    hlt
    jmp disk_error

welcome_msg db "Booting MeowOS...", 0
BOOT_DRIVE db 0

times 510-($-$$) db 0
dw 0xAA55
