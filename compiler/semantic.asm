section .data
    err_mutation db "Semantic Error: Cannot modify a constant", 10, 0
    err_mut_len  equ $ - err_mutation

section .bss
    symbol_table resb 1024

section .text
    global run_semantic_pass

run_semantic_pass:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    xor r12, r12

.semantic_loop:
    mov al, byte [token_stream + r12]
    cmp al, 0
    je .semantic_success

    cmp al, 2
    je .check_constant_mutation

    inc r12
    jmp .semantic_loop

.check_constant_mutation:
    inc r12
    mov al, byte [token_stream + r12]
    cmp al, 99
    jne .semantic_error
    
    inc r12
    mov al, byte [token_stream + r12]
    cmp al, 61
    jne .semantic_loop

    mov rax, 1
    mov rdi, 2
    mov rsi, err_mutation
    mov rdx, err_mut_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

.semantic_error:
    pop r12
    pop rbx
    pop rbp
    ret

.semantic_success:
    pop r12
    pop rbx
    pop rbp
    ret
