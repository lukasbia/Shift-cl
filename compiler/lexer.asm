global lexer_scan

section .text
lexer_scan:
    mov al, byte [rsi + rcx]
    test al, al
    jz lexer_done
    cmp al, ' '
    je lexer_skip
    cmp al, ':'
    je lexer_colon
    cmp al, ','
    je lexer_comma
    cmp al, '('
    je lexer_open_paren
    cmp al, ')'
    je lexer_close_paren
lexer_skip:
    inc rcx
    jmp lexer_scan
lexer_colon:
    inc rcx
    jmp lexer_scan
lexer_comma:
    inc rcx
    jmp lexer_scan
lexer_open_paren:
    inc rcx
    jmp lexer_scan
lexer_close_paren:
    inc rcx
    jmp lexer_scan
lexer_done:
    ret
