extern io_get_dec, io_print_dec

section .bss
    x: resd 1
    n: resd 1
    m: resd 1
    y: resd 1

section .text
global main
main:
    call io_get_dec
    mov [x], eax
    call io_get_dec
    mov [n], eax
    call io_get_dec
    mov [m], eax
    call io_get_dec
    sub eax, 2011
    mov [y], eax
    mov eax, [n]
    mul dword [y]
    add [x], eax
    mov eax, [m]
    mul dword [y]
    sub [x], eax
    mov eax, [x]
    call io_print_dec
    mov eax, 0
    ret
