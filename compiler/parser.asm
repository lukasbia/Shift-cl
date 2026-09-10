section .data
    kw_variable db "variable", 0
    kw_constant db "constant", 0
    kw_func     db "func", 0
    err_keyword db "Syntax Error: Unknown keyword or invalid structure", 10, 0
    err_kw_len  equ $ - err_keyword

section .text
    global parse_tokens

parse_tokens:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rsi, token_buffer

.parse_loop:
    mov al, byte [rsi]
    cmp al, 0
    je .parse_success

    cmp al, 'v'
    je .check_variable

    cmp al, 'c'
    je .check_constant

    cmp al, 'f'
    je .check_func

    inc rsi
    jmp .parse_loop

.check_variable:
    mov rdi, kw_variable
    call match_string
    cmp rax, 1
    jne .syntax_error
    jmp .parse_loop

.check_constant:
    mov rdi, kw_constant
    call match_string
    cmp rax, 1
    jne .syntax_error
    jmp .parse_loop

.check_func:
    mov rdi, kw_func
    call match_string
    cmp rax, 1
    jne .syntax_error
    jmp .parse_loop

.match_string:
    push rsi
    push rdi
.match_loop:
    mov al, byte [rdi]
    cmp al, 0
    je .match_ok
    mov bl, byte [rsi]
    cmp al, bl
    jne .match_fail
    inc rsi
    inc rdi
    jmp .match_loop
.match_ok:
    pop rdi
    pop rsi
    mov rax, 1
    ret
.match_fail:
    pop rdi
    pop rsi
    xor rax, rax
    ret

.syntax_error:
    mov rax, 1
    mov rdi, 2
    mov rsi, err_keyword
    mov rdx, err_kw_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

.parse_success:
    pop r12
    pop rbx
    pop rbp
    ret
