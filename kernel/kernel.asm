[org 0x1000]
[bits 16]

start:
    call print_welcome

main_loop:
    call print_prompt
    call read_line
    call newline
    call handle_command
    jmp main_loop

; ==========================
; Printing
; ==========================
print_welcome:
    mov si, welcome
    call print_string
    call newline
    ret

print_prompt:
    mov si, prompt
    call print_string
    ret

print_string:
.next:
    lodsb
    cmp al, 0
    je .end
    mov ah, 0x0E
    int 0x10
    jmp .next
.end:
    ret

newline:
    mov ah, 0x0E
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    ret

; ==========================
; Keyboard input
; ==========================
read_line:
    mov di, buffer
.read:
    mov ah, 0x00
    int 0x16          ; wait for key
    cmp al, 13        ; Enter?
    je .done

    cmp al, 8         ; Backspace
    je .backspace

    mov [di], al
    inc di

    mov ah, 0x0E
    int 0x10          ; echo char
    jmp .read

.backspace:
    cmp di, buffer
    je .read

    dec di
    mov ah, 0x0E
    mov al, 8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10
    jmp .read

.done:
    mov byte [di], 0
    ret

; ==========================
; Command handling
; ==========================
handle_command:
    mov si, buffer
    mov di, cmd_help
    call strcmp
    cmp ax, 0
    je .help

    mov si, buffer
    mov di, cmd_clear
    call strcmp
    cmp ax, 0
    je .clear

    ; default message (cute me hehe)
    mov si, cute_msg
    call print_string
    call newline
    ret


.help:
    mov si, help_msg
    call print_string
    call newline
    ret

.clear:
    ; will this work?
    call clear_screen
    ret

; ==========================
; Utilities
; ==========================
strcmp:
.next:
    lodsb
    mov bl, [di]
    inc di
    cmp al, bl
    jne .noteq
    cmp al, 0
    jne .next
    xor ax, ax      ; equal :)
    ret

.noteq:
    mov ax, 1
    ret

clear_screen:
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    ret

; ==========================
; Data
; ==========================
welcome db "Welcome to MeowOS", 0
prompt  db "meowOS~$ ", 0

cmd_help db "help", 0
cmd_clear db "clear", 0

help_msg db "Commands: help clear", 0
cute_msg db "ralphmaron is cute", 0

buffer  times 128 db 0
