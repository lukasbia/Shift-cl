section .data
    asm_header  db "global _start", 10, "section .text", 10, "_start:", 10, 0
    asm_head_len equ $ - asm_header
    asm_exit    db "    mov rax, 60", 10, "    xor rdi, rdi", 10, "    syscall", 10, 0
    asm_exit_len equ $ - asm_exit

section .text
    global run_generator

run_generator:
    push rbp
    mov rbp, rsp
    push rbx

    mov rax, 1
    mov rdi, 1
    mov rsi, asm_header
    mov rdx, asm_head_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, asm_exit
    mov rdx, asm_exit_len
    syscall

    pop rbx
    pop rbp
    ret
