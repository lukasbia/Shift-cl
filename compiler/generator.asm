global generate_code
section .data
    out_asm db "global _start", 10, "section .text", 10, "_start:", 10, "    mov rax, 60", 10, "    xor rdi, rdi", 10, "    syscall", 10

section .text
generate_code:
    mov rax, 1
    mov rdi, 1
    mov rsi, out_asm
    mov rdx, 49
    syscall
    ret
