extern io_get_dec, io_print_dec

section .bss
    a: resd 1
    b: resd 1

section .text
global main
main:
    call io_get_dec
    sub eax, 1
    mov [a], eax
    call io_get_dec
    mov [b], eax
    mov eax, 1
    and eax, [a]
    mov ecx, 41
    mul ecx
    add [b], eax
    mov eax, [a]
    shr eax, 1
    mov ecx, 83
    mul ecx
    add eax, [b]
    call io_print_dec
    
    mov eax, 0
    ret
