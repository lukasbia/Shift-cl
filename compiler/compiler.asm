global _start

section .data
    source      db "function compute(value:x,step:y)", 0
    keyword     db "function ", 0
    opt_asm     db "global main", 10, "section .text", 10, "main:", 10, "    lea rax, [rdi + rsi]", 10, "    ret", 10
    std_asm     db "global main", 10, "section .text", 10, "main:", 10, "    mov rax, rdi", 10, "    add rax, rsi", 10, "    ret", 10
    msg_err     db "Syntax Error", 10

section .text
_start:
    mov rsi, source
    mov rdi, keyword
    xor rcx, rcx

match_kw:
    mov al, byte [rdi + rcx]
    test al, al
    jz parse_body
    cmp al, byte [rsi + rcx]
    jne err
    inc rcx
    jmp match_kw

parse_body:
    add rsi, rcx
    xor rcx, rcx

scan_loop:
    mov al, byte [rsi + rcx]
    test al, al
    jz err
    cmp al, '('
    je found_open
    inc rcx
    jmp scan_loop

found_open:
    inc rcx

parse_args:
    mov al, byte [rsi + rcx]
    cmp al, ':'
    je found_colon
    cmp al, ')'
    je run_optimizer
    test al, al
    jz err
    inc rcx
    jmp parse_args

found_colon:
    inc rcx

parse_val:
    mov al, byte [rsi + rcx]
    cmp al, ','
    je found_comma
    cmp al, ')'
    je run_optimizer
    test al, al
    jz err
    inc rcx
    jmp parse_val

found_comma:
    inc rcx
    jmp parse_args

run_optimizer:
    mov rsi, opt_asm
    mov rdx, 61
    jmp generate_code

generate_code:
    mov rax, 1
    mov rdi, 1
    syscall
    jmp exit

err:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_err
    mov rdx, 13
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

