global emit_code
section .data
    msg_emit_start db "Emitter: Generating output assembly...", 10
    msg_emit_len   equ $ - msg_emit_start

section .text
emit_code:
    ; rsi points to the processed buffer (from parser/optimizer)
    push rsi

    ; 1. Print status indicator
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_emit_start
    mov rdx, msg_emit_len
    syscall

    ; 2. Calculate string length of the buffer to emit
    pop rsi
    push rsi
    xor rdx, rdx

.calc_len_loop:
    mov al, byte [rsi + rdx]
    test al, al
    jz .do_write
    inc rdx
    cmp rdx, 4096       ; Max buffer limit check
    jge .do_write
    jmp .calc_len_loop

.do_write:
    ; 3. Write final code via sys_write(stdout, buffer, length)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout file descriptor
    pop rsi             ; restore buffer pointer
    syscall             ; rdx already holds the calculated length

    ret
