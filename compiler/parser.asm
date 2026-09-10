global parser_validate
section .data
    err_msg db "Syntax Error", 10

section .text
parser_validate:
    test rsi, rsi
    jz parser_error
    ret
parser_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, 13
    syscall
    mov rax, 60
    mov rdi, 1
    syscall
