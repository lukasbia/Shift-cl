section .data
    msg_start   db "=== Assembly-C Bootstrap Compiler ===", 10, 0
    msg_start_len equ $ - msg_start
    
    err_syntax  db "[COMPILER ERROR] Invalid keyword or syntax structure.", 10, 0
    err_len     equ $ - err_syntax

section .bss
    token_buffer resb 2048

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_start
    mov rdx, msg_start_len
    syscall

    mov rsi, sample_source_code

    call parse_asmc_stream

    mov rax, 60
    xor rdi, rdi
    syscall

parse_asmc_stream:
    push rbp
    mov rbp, rsp

.lex_loop:
    mov al, byte [rsi]
    
    cmp al, 0
    je .lex_done

    cmp al, 60
    je .skip_comment

    cmp al, ' '
    je .next_char
    cmp al, 9
    je .next_char
    cmp al, 10
    je .next_char

.next_char:
    inc rsi
    jmp .lex_loop

.skip_comment:
    inc rsi
    mov al, byte [rsi]
    cmp al, 0
    je .lex_done
    cmp al, 10
    je .next_char
    jmp .skip_comment

.lex_done:
    pop rbp
    ret

section .data
    sample_source_code:
        db "< Test program source", 10
        db "func main() {", 10
        db "    variable balance: Int = 1250", 10
        db "    print(string: \"Hello\", length: 5)", 10
        db "    exit(code: 0)", 10
        db "}", 10, 0
