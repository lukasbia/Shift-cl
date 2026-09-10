global _start

section .data
    token_stream  db 1, 2, 3, 4, 5, 6, 0
    parse_ok      db "PARSER: Syntax Valid", 10
    parse_err     db "PARSER: Syntax Error", 10

section .text
_start:
    mov rsi, token_stream
    xor rcx, rcx

parse_function:
    mov al, byte [rsi + rcx]
    cmp al, 1
    jne syntax_error
    inc rcx

    mov al, byte [rsi + rcx]
    cmp al, 2
    jne syntax_error
    inc rcx

    mov al, byte [rsi + rcx]
    cmp al, 3
    jne syntax_error
    inc rcx

    mov al, byte [rsi + rcx]
    cmp al, 4
    jne syntax_error
    inc rcx

    mov al, byte [rsi + rcx]
    cmp al, 5
    jne syntax_error
    inc rcx

    mov al, byte [rsi + rcx]
    cmp al, 6
    jne syntax_error

    jmp success

success:
    mov rax, 1
    mov rdi, 1
    mov rsi, parse_ok
    mov rdx, 22
    syscall
    jmp exit

syntax_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, parse_err
    mov rdx, 22
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
