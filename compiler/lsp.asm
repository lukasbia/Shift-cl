global _start

section .data
    ; LSP Initialization Response JSON payload with Content-Length header
    init_res    db "Content-Length: 114", 13, 10, 13, 10, '{"jsonrpc": "2.0","id": 1,"result": {"capabilities": {"textDocumentSync": 1}}}'
    init_len    equ $ - init_res

    ; Keywords to match from editor requests
    str_init    db "initialize", 0
    str_open    db "textDocument/didOpen", 0

section .bss
    buffer      resb 4096

section .text
_start:
lsp_loop:
    ; 1. Read from stdin (sys_read(0, buffer, 4096))
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin descriptor
    mov rsi, buffer     ; destination buffer
    mov rdx, 4096       ; max bytes
    syscall

    test rax, rax       ; check if connection closed or error
    jle exit

    ; 2. Check if request contains "initialize"
    mov rsi, buffer
    mov rdi, str_init
    call check_match
    cmp rax, 1
    je send_initialize_response

    jmp lsp_loop

send_initialize_response:
    ; 3. Write initialization capabilities response (sys_write(1, init_res, init_len))
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout descriptor
    mov rsi, init_res
    mov rdx, init_len
    syscall
    jmp lsp_loop

exit:
    ; 4. Exit gracefully (sys_exit(0))
    mov rax, 60
    xor rdi, rdi
    syscall

; Helper routine to check if substring (rdi) exists in buffer (rsi)
; Returns rax = 1 if found, 0 if not
check_match:
    push rsi
    push rdi
    mov rcx, rsi        ; buffer ptr

.outer_loop:
    mov al, byte [rcx]
    test al, al
    jz .not_found
    
    mov rsi, rcx
    mov rdi, [rsp]      ; target string
    call .strmatch
    cmp rax, 1
    je .found

    inc rcx
    jmp .outer_loop

.strmatch:
    push rcx
    xor rcx, rcx
.match_loop:
    mov al, byte [rdi + rcx]
    test al, al
    jz .match_success
    cmp al, byte [rsi + rcx]
    jne .match_fail
    inc rcx
    jmp .match_loop

.match_success:
    pop rcx
    mov rax, 1
    ret

.match_fail:
    pop rcx
    xor rax, rax
    ret

.found:
    pop rdi
    pop rsi
    mov rax, 1
    ret

.not_found:
    pop rdi
    pop rsi
    xor rax, rax
    ret
