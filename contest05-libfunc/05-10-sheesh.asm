; РАБОТА: написать ф-цию search. добавить в delete функционал обработки несуществующих элементов (возможно, немного укоротить код)

;====================================================ЗАДАЧА 10===========================================================;
; В задаче требуется организовать структуру данных (дерево) для хранения, поиска и удаления элементов определенного вида.;
; Каждый элемент имеет ключ и некоторые данные, ассоциированные с этим ключом.                                           ;
; Считается, что в структуре данных ключ однозначно определяет элемент.                                                  ;
; Определены следующие операции: сохранение нового элемента, удаление и поиск элемента по ключу.                         ;
; A key data - сохранить элемент с ключом key и данными data (если с таким ключом элемент уже существует - обновить)     ;
; D key - удалить элемент                                                                                                ;
; S key - поиск элемента по ключу, вывод на stdin пары key-data                                                          ;
; F - конец ввода                                                                                                        ;
;========================================================================================================================;

; Объявление Си-функций
extern malloc, free, printf, getchar, scanf

; Объявления переменных
section .bss
    root resd 1 ; указатель на всё дерево
    n resd 1 ; ячейки памяти для работы со scanf 
    m resd 1
section .data
    o_string db `%d %d\n`, 0 ; строка для printf
    i_string db '%d', 0 ; строка для scanf
;=======================================================ФУНКЦИИ==========================================================;
section .text
; Создать дерево из одного узла без потомков, вернуть указатель.
; create(int key, int data)
; Структура стека:
; -4 | int data
;  0 | int key
;  4 | адрес возврата
;  8 | pushed ebp
; 12 |
; 16 | 16 байт - для malloc
create:
    push ebp
    mov ebp, esp
    
    sub esp, 8 ; выравнивание стека для malloc
    mov dword[esp], 16 ; дерево занимает 16 байт
    call malloc
    
    mov ecx, [ebp + 8]
    mov [eax], ecx ; tree->key
    mov ecx, [ebp + 12]
    mov [eax + 4], ecx ; tree->data
    mov dword[eax + 8], 0 ; tree->leftson
    mov dword[eax + 12], 0 ; tree->rightson
    
    mov esp, ebp
    pop ebp
    ret

; Добавить в дерево поиска [root] узел (или обновить существующий).
; update(int key, int data)
; Структура стека:
; -4 | int data
;  0 | int key
;  4 | адрес возврата
;  8 | pushed ebp | <== esp
; 12 | сохранённый ebx
; в случае необходимости создать дерево:
; 16 |
; 20 |
; 24 |
; 28 | дубликат int data
; 32 | дубликат int key
update:
    push ebp
    mov ebp, esp
    push ebx
    
    mov ecx, [esp + 12]
    mov ebx, [root]
    ; ecx содержит ключ, который нужно записать. [ebx] - текущий проверяемый узел.
    .loop: ; цикл обхода дерева
        cmp ecx, [ebx]
        je .equality ; если равенство, то просто обновляем данные существующего узла
        jg .nullcheckr ; если узел больше, то проверяем правого потомка
        jl .nullcheckl ; если узел меньше, то проверяем левого потомка
            .equality: ; обновление данных существующего узла и выход из цикла
                mov eax, [esp + 16]
                mov [ebx + 4], eax
                jmp .end               
        .nullcheckr: ; проверяем, существует ли правый потомок. 
            cmp dword[ebx + 12], 0
            je .addr ; если не существует - выходим из цикла и добавляем его
            mov ebx, [ebx + 12] ; если существует - заменяем ebx на его правого потомка и продолжаем цикл
            jmp .loop
        .nullcheckl: ; проверяем, существует ли левый потомок
            cmp dword[ebx + 8], 0
            je .addl ; если не существует - выходим из цикла и добавляем его
            mov ebx, [ebx + 8] ; если существует - заменяем ebx на его левого потомка и продолжаем цикл
            jmp .loop
    ; Создание новых узлов: кладём на стек ключ и данные, вызываем create, линкуем с предыдущим деревом. 
        .addr:
            sub esp, 20 ; выравнивание стека
            mov [esp], ecx ; дублируем ключ
            mov eax, [ebp + 12] ; дублируем данные
            mov [esp + 4], eax
            call create ; создаём узел
            add esp, 20
            mov [ebx + 12], eax ; связываем с существующим
            jmp .end
        .addl:
            sub esp, 20
            mov [esp], ecx
            mov eax, [ebp + 12]
            mov [esp + 4], eax
            call create
            add esp, 20
            mov [ebx + 8], eax
            jmp .end
    .end:
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; Удаление узла с ключом key.
; delete (int key)
; Структура стека:
;  0 | int key
;  4 | адрес возврата
;  8 | pushed ebp
; 12 | saved ebx 
; 16 | saved esi
; 20 | saved edi
delete:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    mov ecx, [ebp + 8]
    mov ebx, [root]
    xor eax, eax 
    ; eax будет содержать адрес родителя. если он равен нулю, то происходит удаление первого узла. 
    xor edi, edi
    ; edi будет содержать 1, если текущий узел для родительского является правым, и -1, если левым. 
    ; ecx содержит ключ, по которому осуществляется поиск, [ebx] - текущий проверяемый узел
    .loop:
        cmp ecx, [ebx]
        je .equality ; если равенство - то мы дошли до ключа, который нужно удалить.
        jg .right ; если узел больше, то переходим к правому потомку
        jl .left ; если узел меньше, то переходим к левому потомку
            .right:
                ; проверяем, не уперлись ли мы в конец
                cmp dword[ebx + 12], 0
                je .end
                mov eax, ebx ; сохраняем родителя в eax
                mov ebx, [ebx + 12] ; заменяем ebx на его правого потомка и продолжаем цикл
                mov edi, 1
                jmp .loop
            .left:
                cmp dword[ebx + 8], 0
                je .end
                mov eax, ebx ; сохраняем родителя в eax
                mov ebx, [ebx + 8] ; заменяем ebx на его левого потомка и продолжаем цикл
                mov edi, -1
                jmp .loop
    .equality:
        ; сейчас в ebx лежит адрес ключа, который нужно удалить, а в eax - адрес родителя, потомков которого нужно изменить (либо 0, если удаляется корень).
        ; есть четыре случая: у удаляемого ключа нет потомков (leaf), есть только левый (saveleft), только правый (saveright) или оба (saveboth).
        mov esi, [ebx + 8] ; leftson
        or esi, [ebx + 12] ; rightson
        cmp esi, 0 ; если (rightson | leftson) == 0, то потомков нет, и нужно сделать удаление листа. 
        je .leaf
        mov esi, [ebx + 8] ; leftson
        cmp esi, 0
        je .saveright
        mov esi, [ebx + 12] ; rightson
        cmp esi, 0
        je .saveleft
        jmp .saveboth
    .leaf:
        cmp eax, 0
        je .leafroot ; удаление единственного узла, зачищение root-а. 
        cmp edi, 1
        je .leafright
        ;leafleft:
            mov dword[eax + 8], 0 ; убираем связь родителя с сыном
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            jmp .end
        .leafright:
            mov dword[eax + 12], 0 ; убираем связь родителя с сыном
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            jmp .end
        .leafroot:
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            mov dword[root], 0
            jmp .end
    .saveright:
        cmp eax, 0
        je .saverightroot ; замена root на его правого потомка
        cmp edi, 1
        je .saverightright
        ;saverightleft:
            mov esi, [ebx + 12]
            mov [eax + 8], esi
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            jmp .end
        .saverightright:
            mov esi, [ebx + 12]
            mov [eax + 12], esi
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            jmp .end
        .saverightroot:
            mov esi, [ebx + 12]
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            mov [root], esi
            jmp .end
    .saveleft:
        cmp eax, 0
        je .saveleftroot ; замена root на его левого потомка
        cmp edi, 1
        je .saveleftright
        ;saveleftleft:
            mov esi, [ebx + 8]
            mov [eax + 8], esi
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            jmp .end
        .saveleftright:
            mov esi, [ebx + 8]
            mov [eax + 12], esi
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            jmp .end
        .saveleftroot:
            mov esi, [ebx + 8]
            sub esp, 12
            mov [esp], ebx
            call free
            add esp, 12
            mov [root], esi
            jmp .end
    .saveboth:
        ; в случае наличия у удаляемого узла обоих потомков, следующий за удаляемым лист должен быть помещен на его место.
        ; регистров не хватает: кладём eax (родителя), ebx (удаляемый узел) и edi (параметр правого/левого сына) на стек. 
        push eax ; esp + 8
        push ebx ; esp + 4
        push edi ; esp 
        ; переходим направо:
        mov eax, ebx
        mov ebx, [ebx + 12]
        ; поиск листа спусками влево 
        .savebothloop:
            cmp dword[ebx + 8], 0
            je .links
            mov eax, ebx
            mov ebx, [ebx + 8]
        .links:
            ; в ebx - лист, в eax - его родитель
            ; обработаем особый случай, когда eax и есть удаляемый лист.
            mov esi, eax
            xor esi, [esp + 4]
            cmp esi, 0
            jne .ok
                mov esi, [esp + 4] ; прицепим к листу левого потомка удаляемого узла
                mov esi, [esi + 8]
                mov [ebx + 8], esi 
                jmp .bothparent
            .ok: 
            mov esi, [ebx + 12] ; перецепляем правого потомка листа
            mov [eax + 8], esi
            mov esi, [esp + 4] ; цепляем левого потомка удаляемого узла к листу
            mov esi, [esi + 8]
            mov [ebx + 8], esi
            mov esi, [esp + 4] ; цепляем правого потомка удаляемого узла к листу
            mov esi, [esi + 12]
            mov [ebx + 12], esi
            ; осталось прицепить родителя.
            .bothparent:
            mov edi, [esp] ; в edi - параметр 
            mov eax, [esp + 8] ; в eax - адрес изначального родителя
            mov esi, ebx ; в esi - адрес листа
            mov ebx, [esp + 4] ; в ebx - адрес удаляемого узла
            add esp, 12
            cmp eax, 0
            je .savebothroot
            cmp edi, 1
            je .savebothright
            ;savebothleft:
                mov [eax + 8], esi
                sub esp, 12
                mov [esp], ebx
                call free
                add esp, 12
                jmp .end
            .savebothright:
                mov [eax + 12], esi
                sub esp, 12
                mov [esp], ebx
                call free
                add esp, 12
                jmp .end
            .savebothroot:
                sub esp, 12
                mov [esp], ebx
                call free
                add esp, 12
                mov [root], esi
                jmp .end
            
    .end:
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; Поиск узла по значению в дереве root и вывод ключа и данных на стандартный поток через printf.
; search(int key)
; Структура стека:
;  0 | int key
;  4 | адрес вызова
;  8 | pushed ebp
; 12 | pushed ebx
; 16 |
; 20 |
; 24 | int data
; 28 | int key
; 32 | форматная строка printf
search:
    push ebp
    mov ebp, esp
    push ebx
    
    mov ecx, [ebp + 8] ; искомый ключ
    mov ebx, [root] ; текущий элемент дерева
    .loop:
        cmp ecx, [ebx]
        je .equality
        jg .right
        jl .left
        .right: ; заменяем на правого потомка и идём дальше
        ; проверяем, не уперлись ли мы в конец
            cmp dword[ebx + 12], 0
            je .end
            mov ebx, [ebx + 12] ; заменяем ebx на его правого потомка и продолжаем цикл
            jmp .loop
        .left: ; заменяем на левого потомка и идём дальше
            cmp dword[ebx + 8], 0
            je .end
            mov ebx, [ebx + 8] ; заменяем ebx на его левого потомка и продолжаем цикл
            jmp .loop
        
    .equality:
        sub esp, 20
        mov eax, [ebx]
        mov [esp + 4], eax
        mov eax, [ebx + 4]
        mov [esp + 8], eax
        mov dword[esp], o_string
        call printf
        add esp, 20
    .end:
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; Функция, рекурсивно обходящая всё дерево root и очищающая его.
; freetree(node)
; Структура стека:
;  0 | адрес элемента дерева
;  4 | адрес вызова
;  8 | pushed ebp
; 12 |
; 16 | адрес следующего элемента рекурсивного вызова
freetree:
    push ebp
    mov ebp, esp
    mov eax, [esp + 8]
    cmp dword[eax + 8], 0
    je .skipleft
        sub esp, 8
        mov ecx, [eax + 8]
        mov [esp], ecx
        call freetree
        add esp, 8
    .skipleft:
    mov eax, [esp + 8]
    cmp dword[eax + 12], 0
    je .skipright
        sub esp, 8
        mov ecx, [eax + 12]
        mov [esp], ecx
        call freetree
        add esp, 8
    .skipright:
        mov eax, [esp + 8]
        sub esp, 8
        mov [esp], eax
        call free
        add esp, 8 
    mov esp, ebp
    pop ebp
    ret

;============================================MAIN===================================================;
global main
main:
    mov ebp, esp; for correct debugging
    ; prologue
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    sub esp, 12
    .loop: ; основной цикл
        call getchar
        cmp eax, 'A'
        je .A
        cmp eax, 'D'
        je .D
        cmp eax, 'S'
        je .S
        cmp eax, 'F'
        je .F
        jmp .loop
        .A:
            mov dword[esp], i_string
            mov dword[esp + 4], n
            call scanf
            mov dword[esp + 4], m
            call scanf
            mov eax, [m]
            mov dword[esp + 4], eax
            mov eax, [n]
            mov [esp], eax
            cmp dword[root], 0
            jne .L1
                call create
                mov [root], eax
                jmp .loop
            .L1:
                call update
                jmp .loop
        .D:
            cmp dword[root], 0
            je .loop
            mov dword[esp], i_string
            mov dword[esp + 4], n
            call scanf
            mov eax, [n]
            mov [esp], eax
            call delete
            jmp .loop
        
        .S:
            cmp dword[root], 0
            je .loop
            mov dword[esp], i_string
            mov dword[esp + 4], n
            call scanf
            mov eax, [n]
            mov [esp], eax
            call search
            jmp .loop
        
        .F:
            cmp dword[root], 0
            je .epilogue
            mov eax, [root]
            mov [esp], eax
            call freetree
    .epilogue:
    add esp, 12
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret