global imprimirTablero
global realizarMovimientoDelZorro

global realizarMovimientoDeOca

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
    msgCoordenadasColumna db 10,"   A B C D E F G",10,0  
    formatoElemento db "%c ",0
    formatoFila db "%li  ",0
    formatoByte db "%hhi  ",0

    msgSaltoDeLinea db "",10,0
    
    longitudElemento dq 1
    longitudFila dq 7
    longitudColumna dq 7

    caracterZorro db 90 
    caracterEspacio db 32

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

        mov rax,qword[indiceFila] 
        imul rax, qword[longitudFila] 
        mov [tableroOffset], rax ;me guardo cuanto tengo que desplazarme para llegar a esta

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

realizarMovimientoDelZorro: ; Parametros: rdi -> direccion del tablero
                            ;             rsi -> coordenada
                            ;             


    buscarZorroEnTablero:
        mov qword[dirVec], rdi
        mov rcx, rsi
        mov rax, [dirVec]

    proximoCasillero:
        cmp     byte[rax], 90
        je      escribirCasilleroActual
        inc     rax ; asumiendo longitud elemento = 1
        jmp     proximoCasillero

    escribirCasilleroActual:

        mov byte[rax], 32

    escribirCasilleroNuevo:
        imul rcx, [longitudFila]  
        add rax, rcx
 
        add rax, rdx

        cmp rax, 0
        je terminarMovimiento

        mov byte[rax], 90
        

    terminarMovimiento:
    ret

realizarMovimientoDeOca: ; Parametros: rdi -> direccion del tablero
                         ;             rsi -> coordenada de la oca
                         ;             rdx -> direccion horizontal
                         ; Devuelve
                         
    mov qword[dirVec], rdi

obtenerDireccionOca:    
    mov rax, 0
    mov rcx, 0
    
    mov al, byte[rsi]
    sub rax, 65

    inc rsi
    mov cl, byte[rsi]

    sub rcx, 49
    imul rcx, [longitudFila]

    add rax, rcx
    
    add rax, [dirVec]

    cmp byte[rax], 79 ;No es una oca
    jne movimientoInvalido

    mov byte[rax], 32

    cmp rdx, 0 ; Si el movimiento horizontal es cero se mueve para adelante
    je ocaMovimientoVertical

    add rax, rdx
    mov byte[rax], 79
    ret


ocaMovimientoVertical:
    add rax, [longitudFila]
    mov byte[rax], 79

    ret

movimientoInvalido:
    mov rax, -1
    ret