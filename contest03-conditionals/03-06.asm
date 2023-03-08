extern io_get_udec, io_print_udec

section .text
global main
main:
    enter 0, 0
    
    call io_get_udec
    mov edi, eax     ; edi = N
    call io_get_udec
    mov ecx, eax     ; ecx = K 
    mov ebx, 1
    shl ebx, cl
    sub ebx, 1       ; ebx = MASK
    mov edx, ecx
    mov ecx, 32
    sub ecx, edx
    mov esi, 0       ; esi = ANS
    
.L1:
    mov eax, edi
    and eax, ebx
    cmp eax, esi
    cmova esi, eax
    ror edi, 1
    loop .L1
    
    mov eax, esi
    call io_print_udec
    
    leave
    xor eax, eax
    ret
