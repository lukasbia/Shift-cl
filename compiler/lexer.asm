global _start

section .data
    source_code   db "function", 0
    kw_function   db "function", 0
    msg_keyword   db "TOKEN: KEYWORD (function)", 10
    msg_ident     db "TOKEN: IDENTIFIER", 10

section .text
_start:
    mov rsi, source_code
    mov rdi, kw_function
    xor rcx, rcx

compare_loop:
    mov al, byte [rsi + rcx]
    mov bl, byte [rdi + rcx]

    cmp al, bl
    jne not_a_keyword

    cmp al, 0
    je found_keyword

    inc rcx
    jmp compare_loop

found_keyword:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_keyword
    mov rdx, 27
    syscall
    jmp exit

not_a_keyword:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ident
    mov rdx, 17
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
