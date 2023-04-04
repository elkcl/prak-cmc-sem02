extern fopen, fscanf, printf

section .rodata
    ifmt: db "%d"
    ofmt: db "%d\n"
    filename: db "data.in"

section .bss
    handle: resd 1

section .text
global main
main:
    enter 8, 0
    
    xor eax, eax
    leave
    ret
