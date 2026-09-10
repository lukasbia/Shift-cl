global _start

section .data
    compiler_out db "global _start", 10, "section .text", 10, "_start:", 10, "    mov rax, 60", 10, "    xor rdi, rdi", 10, "    syscall", 10

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, compiler_out
    mov rdx, 61
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
