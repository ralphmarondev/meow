[org 0x1000]
[bits 16]

start:
    call clear_screen
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
    mov si, welcome_msg1
    call print_string
    call newline
    mov si, welcome_msg2
    call print_string
    call newline
    mov si, welcome_msg3
    call print_string
    call newline
    call newline
    ret

print_prompt:
    push ax
    mov si, prompt
.print_prompt_loop:
    lodsb
    cmp al, 0
    je .done_prompt
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x0B    ; cyan
    int 0x10
    jmp .print_prompt_loop
.done_prompt:
    pop ax
    ret

print_string:
.next:
    lodsb
    cmp al, 0
    je .end
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x0E    ; yellow
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
    mov bh, 0x00
    mov bl, 0x0A
    int 0x10
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
    mov di, cmd_version
    call strcmp
    cmp ax, 0
    je .version

    mov si, buffer
    mov di, cmd_clear
    call strcmp
    cmp ax, 0
    je .clear

    ; default message
    mov si, notfound_msg
    call print_string
    call newline
    ret


.help:
    mov si, help_msg1
    call print_string
    call newline
    mov si, help_msg2
    call print_string
    call newline
    mov si, help_msg3
    call print_string
    call newline
    ret

.version:
    mov si, version_msg
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
    ; Clear entire screen
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    
    ; Move cursor to top-left (0, 0) 
    ; -> coz we're cute right?
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x00
    mov dl, 0x00
    int 0x10

    ret

; ==========================
; Data
; ==========================
welcome_msg1 db "Welcome to MeowOS", 0
welcome_msg2 db "Developed by: Ralph Maron Eda", 0
welcome_msg3 db "Type 'help' to show commands.", 0
prompt  db "[ralphmaron@meow]-$ ", 0

cmd_help db "help", 0
cmd_clear db "clear", 0
cmd_version db "version", 0

help_msg1 db "help    - Show available commands", 0
help_msg2 db "clear   - Clear the screen", 0
help_msg3 db "version - Print version", 0

version_msg db "MeowOS v0.1", 0
notfound_msg db "Cutiee", 0

buffer  times 128 db 0
