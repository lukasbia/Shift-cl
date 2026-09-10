section .data
    kw_variable db "variable", 0
    kw_constant db "constant", 0
    kw_func     db "func", 0
    kw_if       db "if", 0
    kw_else     db "else", 0
    kw_while    db "while", 0
    kw_return   db "return", 0

section .bss
    lexeme_buffer resb 64
    token_stream  resb 4096

section .text
    global run_smart_lexer

run_smart_lexer:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13

    xor r12, r12
    xor r13, r13

.read_char:
    mov al, byte [rsi + r12]
    cmp al, 0
    je .lexer_done

    cmp al, 60
    je .skip_comment

    cmp al, ' '
    je .next_char
    cmp al, 9
    je .next_char
    cmp al, 10
    je .next_char

    cmp al, 'a'
    jl .check_symbol
    cmp al, 'z'
    jle .extract_identifier

.extract_identifier:
    xor rbx, rbx
.collect_loop:
    mov al, byte [rsi + r12]
    cmp al, 'a'
    jl .evaluate_identifier
    cmp al, 'z'
    jg .evaluate_identifier
    mov byte [lexeme_buffer + rbx], al
    inc rbx
    inc r12
    jmp .collect_loop

.evaluate_identifier:
    mov byte [lexeme_buffer + rbx], 0

    mov rdi, lexeme_buffer
    mov rsi, kw_variable
    call str_cmp
    cmp rax, 1
    je .emit_variable_token

    mov rdi, lexeme_buffer
    mov rsi, kw_constant
    call str_cmp
    cmp rax, 1
    je .emit_constant_token

    mov rdi, lexeme_buffer
    mov rsi, kw_func
    call str_cmp
    cmp rax, 1
    je .emit_func_token

    jmp .emit_identifier_token

.emit_variable_token:
    mov byte [token_stream + r13], 1
    inc r13
    jmp .read_char

.emit_constant_token:
    mov byte [token_stream + r13], 2
    inc r13
    jmp .read_char

.emit_func_token:
    mov byte [token_stream + r13], 3
    inc r13
    jmp .read_char

.emit_identifier_token:
    mov byte [token_stream + r13], 99
    inc r13
    jmp .read_char

.check_symbol:
    inc r12
    jmp .read_char

.skip_comment:
    inc r12
    mov al, byte [rsi + r12]
    cmp al, 0
    je .lexer_done
    cmp al, 10
    je .next_char
    jmp .skip_comment

.next_char:
    inc r12
    jmp .read_char

.str_cmp:
    push rsi
    push rdi
.cmp_loop:
    mov al, byte [rdi]
    mov bl, byte [rsi]
    cmp al, bl
    jne .cmp_notequal
    cmp al, 0
    je .cmp_equal
    inc rdi
    inc rsi
    jmp .cmp_loop
.cmp_equal:
    pop rdi
    pop rsi
    mov rax, 1
    ret
.cmp_notequal:
    pop rdi
    pop rsi
    xor rax, rax
    ret

.lexer_done:
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
