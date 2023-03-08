extern io_get_hex, io_print_hex

section .bss
    a: resd 1
    b: resd 1

section .text
global main
main:
    call io_get_hex
    mov [a], eax
    call io_get_hex
    mov [b], eax
    call io_get_hex
    and [a], eax
    not eax
    and [b], eax
    mov eax, 0
    or eax, [a]
    or eax, [b]
    call io_print_hex
    mov eax, 0
    ret
