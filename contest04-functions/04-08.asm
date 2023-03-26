extern io_print_udec, io_get_udec, io_newline

section .bss
    last: resd 1
    n: resd 1
    k: resd 1
    ans: resd 1

section .text
global main
main:
    enter 0, 0
    call io_get_udec
    mov [n], eax
    call io_get_udec
    mov [k], eax
    
    ; do-while last != n
    .L1:
        push dword [k]
        push dword [n]
        call digit_sum
        add esp, 8
        mov ebx, [last]
        add [ans], ebx
        mov ebx, [n]
        mov [last], ebx
        mov [n], eax
        
        cmp eax, ebx
        jne .L1
    
    add [ans], ebx
    add eax, [ans]
    call io_print_udec
    call io_newline
    
    xor eax, eax
    leave
    ret
    
; n: u32  (ebp + 8)
; k: u32  (ebp + 12)
; -> u32
digit_sum:
    enter 0, 0
    xor edx, edx
    mov eax, [ebp + 8]
    test eax, eax
    jz .EXIT
    div dword [ebp + 12]
    push edx
    push dword [ebp + 12]
    push eax
    call digit_sum
    add esp, 8
    pop edx
    add eax, edx
.EXIT:
    leave
    ret
