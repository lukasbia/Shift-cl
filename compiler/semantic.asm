global semantic_analyze
section .data
    msg_semantic_err db "Semantic Error: Invalid argument or type definition", 10

section .text
semantic_analyze:
    ; rsi points to the source string buffer after the keyword
    xor rcx, rcx

sem_loop:
    mov al, byte [rsi + rcx]
    test al, al
    jz sem_success
    
    ; Ensure no empty argument names before colon
    cmp al, ':'
    je check_empty_label
    
    ; Ensure no empty type values after colon
    cmp al, ','
    je check_empty_type
    cmp al, ')'
    je sem_success
    
    inc rcx
    jmp sem_loop

check_empty_label:
    ; If the character immediately before ':' is '(' or ',' or space, it's an empty label
    dec rcx
    mov al, byte [rsi + rcx]
    cmp al, '('
    je sem_err
    cmp al, ','
    je sem_err
    cmp al, ' '
    je sem_err
    inc rcx
    inc rcx
    jmp sem_loop

check_empty_type:
    ; If the character immediately before ',' is ':', it's an empty type
    dec rcx
    mov al, byte [rsi + rcx]
    cmp al, ':'
    je sem_err
    inc rcx
    inc rcx
    jmp sem_loop

sem_success:
    ret

sem_err:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_semantic_err
    mov rdx, 51
    syscall
    mov rax, 60
    mov rdi, 1
    syscall
