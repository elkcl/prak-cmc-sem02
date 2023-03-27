extern io_get_dec, io_get_string, io_print_string

%define BUF_SIZE 4096

section .text

f:
        push    ebp
        xor     eax, eax
        mov     ebp, esp
        push    esi
        mov     ecx, dword [ebp+12]
        push    ebx
        mov     edx, dword [ebp+16]
        mov     ebx, dword [ebp+8]
.L2:
        mov     byte [ebx+eax], al
        inc     eax
        cmp     eax, 255
        jne     .L2
        jmp     .L9
.L6:
        mov     al, byte [edx]
        test    al, al
        jne     .L4
        xor     eax, eax
        jmp     .L5
.L4:
        movzx   esi, byte [ecx]
        inc     edx
        inc     ecx
        mov     byte [ebx+esi], al
.L9:
        cmp     byte [ecx], 0
        jne     .L6
        xor     eax, eax
        cmp     byte [edx], 0
        sete    al
.L5:
        pop     ebx
        pop     esi
        pop     ebp
        ret

p:
        push    ebp
        mov     ebp, esp
        mov     edx, dword [ebp+8]
        mov     eax, dword [ebp+12]
        jmp     .L12
.L13:
        movzx   ecx, byte [eax]
        mov     cl, byte [edx+ecx]
        mov     byte [eax], cl
        inc     eax
.L12:
        cmp     byte [eax], 0
        jne     .L13
        pop     ebp
        ret

s:
        push    ebp
        mov     ebp, esp
        mov     eax, dword [ebp+8]
        mov     edx, dword [ebp+12]
        sub     edx, 1
        push    edx
        call    io_get_string
        pop     edx
        mov     byte [eax+edx], 0
        mov     al, 1
        pop     ebp
        ret


global main
main:
        push    ebp
        mov     ebp, esp
        sub     esp, 4880
        lea     eax, [esp+4624]
        mov     dword [esp], eax
        mov     dword [esp+4], 256
        call    s
        lea     eax, [esp+4368]
        mov     [esp], eax
        mov     dword [esp+4], 256
        call    s
        lea     eax, [esp+4112]
        mov     dword [esp], eax
        lea     eax, [esp+4624]
        mov     dword [esp+4], eax
        lea     eax, [esp+4368]
        mov     dword [esp+8], eax
        call    f
        test    eax, eax
        je      .L1
        mov     dword [esp+4108], ebx
        call    io_get_dec
        mov     ebx, eax
        lea     eax, [esp+12]
        mov     edx, BUF_SIZE
        call    io_get_string ; пропускаем перевод строки после введенного числа
.L8:
        test    ebx, ebx
        je      .L7
        lea     edx, [esp+12]
        mov     dword [esp], edx
        mov     dword [esp+4], BUF_SIZE
        call    s
        lea     edx, [esp+4112]
        mov     dword [esp], edx
        lea     edx, [esp+12]
        mov     dword [esp+4], edx
        call    p
        lea     eax, [esp+12]
        call    io_print_string
        dec     ebx
        jmp     .L8
.L7:
        mov     ebx, dword [esp+4108]
.L1:
        xor     eax, eax
        mov     esp, ebp
        pop     ebp
        ret
