[org 0x1000]
[bits 16]

start:
    call print_welcome

main_loop:
    call print_prompt
    call read_line
    call newline
    jmp main_loop

; -------------------------

print_welcome:
    mov si, welcome
    call print_string
    call newline
    ret

print_prompt:
    mov si, prompt
    call print_string
    ret

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

welcome db "Welcome to MeowOS", 0
prompt  db "meowOS~$ ", 0
buffer  times 128 db 0
