section .data
    err_syntax db "Parser Error: Unexpected token structure", 10, 0
    err_syn_len equ $ - err_syntax

section .text
    global run_parser

run_parser:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    xor r12, r12

.parse_loop:
    mov al, byte [token_stream + r12]
    cmp al, 0
    je .parse_success

    cmp al, 1
    je .parse_variable

    cmp al, 2
    je .parse_constant

    cmp al, 3
    je .parse_func

    inc r12
    jmp .parse_loop

.parse_variable:
    inc r12
    mov al, byte [token_stream + r12]
    cmp al, 99
    jne .syntax_error
    inc r12
    jmp .parse_loop

.parse_constant:
    inc r12
    mov al, byte [token_stream + r12]
    cmp al, 99
    jne .syntax_error
    inc r12
    jmp .parse_loop

.parse_func:
    inc r12
    mov al, byte [token_stream + r12]
    cmp al, 99
    jne .syntax_error
    inc r12
    jmp .parse_loop

.syntax_error:
    mov rax, 1
    mov rdi, 2
    mov rsi, err_syntax
    mov rdx, err_syn_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

.parse_success:
    pop r12
    pop rbx
    pop rbp
    ret
