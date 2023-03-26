extern io_get_udec, io_print_string

section .rodata
    yes: db `YES\n\0`
    no: db `NO\n\0`

section .text
global main
main:
    enter 0, 0
    call io_get_udec
    mov ebx, eax
    ; do-while ebx != 0
    .L1:
        call io_get_udec
        push eax
        call div3
        add esp, 4
        mov edx, no
        mov ecx, yes
        test eax, eax
        cmovz edx, ecx
        mov eax, edx
        call io_print_string
        
        dec ebx
        test ebx, ebx
        jnz .L1
        
    xor eax, eax
    leave
    ret

; n: u32 (ebp + 8)
; -> u32 (возаращает остаток от деления на 3)
div3:
    enter 0, 0
    mov eax, [ebp + 8]
    cmp eax, 3
    jb .EXIT
    mov edx, eax
    shr edx, 1
    and eax, 0x55555555
    and edx, 0x55555555
    ; eax - нечётные биты, edx - чётные
    
    mov ecx, eax
    shr ecx, 2
    and eax, 0x33333333
    and ecx, 0x33333333
    add eax, ecx
    
    mov ecx, edx
    shr ecx, 2
    and edx, 0x33333333
    and ecx, 0x33333333
    add edx, ecx
    
    mov ecx, eax
    shr ecx, 4
    and eax, 0x0f0f0f0f
    and ecx, 0x0f0f0f0f
    add eax, ecx
    
    mov ecx, edx
    shr ecx, 4
    and edx, 0x0f0f0f0f
    and ecx, 0x0f0f0f0f
    add edx, ecx
    
    mov ecx, eax
    shr ecx, 8
    and eax, 0x00ff00ff
    and ecx, 0x00ff00ff
    add eax, ecx
    
    mov ecx, edx
    shr ecx, 8
    and edx, 0x00ff00ff
    and ecx, 0x00ff00ff
    add edx, ecx
    
    mov ecx, eax
    shr ecx, 16
    and eax, 0x0000ffff
    and ecx, 0x0000ffff
    add eax, ecx
    
    mov ecx, edx
    shr ecx, 16
    and edx, 0x0000ffff
    and ecx, 0x0000ffff
    add edx, ecx
    
    sub eax, edx
    jns .NS
    neg eax
.NS:
    push eax
    call div3
    add esp, 4
.EXIT:
    leave
    ret
