extern io_get_dec, io_print_char

section .data
    rank: db "23456789TJQKA"
    suit: db "SCDH"

section .text
global main
main:
    call io_get_dec
    sub eax, 1
    mov edx, 0
    mov ecx, 13
    div ecx
    mov ebx, eax
    mov eax, edx
    movzx eax, byte [rank + eax]
    call io_print_char
    movzx eax, byte [suit + ebx]
    call io_print_char
    mov eax, 0
    ret
