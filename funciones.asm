global imprimirTablero

%macro mprintf 1
    mov     rdi,%1
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
%macro mprintf 2
    mov     rdi,%1
    mov     rsi,%2
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
extern printf

section .data
    msgCoordenadasColumna db "   A B C D E F G",10,0  
    formatoElemento db "%c ",0
    formatoFila db "%d  ",0
    msgSaltoDeLinea db "",10,0
    
    longitudElemento dq 1
    longitudFila dq 7
    longitudColumna dq 7

section .bss
    dirVec      resq   1
    indiceColumna resq 1
    indiceFila resq 1
    tableroOffset resq 1

section .text

imprimirTablero: ; Parametros: rdi -> direccion del tablero
    mov qword[dirVec], rdi

    mprintf msgCoordenadasColumna ; Imprimo la primera linea

    mov qword[indiceFila],0
    mov qword[indiceColumna],0

    imprimirFila:
        cmp qword[indiceFila], 7; Verifico condicion de corte del loop externo
        je finImprimirTablero

        mprintf msgSaltoDeLinea

        mov rax,qword[indiceFila] ; Imprimo el numero de fila
        inc rax
        mprintf formatoFila, rax

        mov rax,qword[indiceFila] ;me desplazo de fila
        imul rax, qword[longitudFila] 
        mov [tableroOffset], rax 

        mov qword[indiceColumna],0 ;reseteo indice de columna e incremento el de fila
        inc qword[indiceFila]

    imprimirElemento: 
        cmp qword[indiceColumna], 7; Verifico condicion de corte del loop interno
        je imprimirFila;  ;avanzo en el loop externo

        mov rbx, qword[dirVec]; Me situo al inicio del tablero


        mov rax,qword[indiceColumna] ;
        imul rax, qword[longitudElemento] ;me desplazo de columna
        add rcx,rax

        add rax, [tableroOffset] ;sumo los desplazamientos
        add rbx, rax ;me posicione en la matriz


        mprintf formatoElemento, [rbx]

        inc qword[indiceColumna]
        jmp imprimirElemento ;avanzo en el loop interno

    finImprimirTablero:

        mprintf msgSaltoDeLinea
        mprintf msgSaltoDeLinea

    ret

realizarMovimientoDelZorro:
