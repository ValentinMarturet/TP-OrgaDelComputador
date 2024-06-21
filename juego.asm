%macro mPrintf 1
    mov     rdi,%1
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets
    add     rsp,8
%endmacro

global main

;funciones externas de C
extern printf
extern gets
extern imprimirTablero


section .data
    ;Mensajes
    msjInicioDelJuego           db "--EL ZORRO Y LAS OCAS",10,10,"Elija una opcion para jugar",10,"1 - Nueva Partida",10,"2 - Salir del juego",10,0
    msjComienzoNuevaPartida     db "Usted ha comenzado una nueva partida.",10,0
    msjSalidaDelJuego           db "Saliendo del juego.",10,0


    msjErrorDeValidacion        db "No se pudo validar ninguna de las opciones",10,0

    ;opciones de la partida
    opcionNuevaPartida  db "1",0
    opcionSalirJuego    db "2",0

    turnoActual         db "O"

    CANT_FILAS       equ 7
    CANT_COLUMNAS    equ 7
    
    tablero     db -1, -1, 1, 1, 1, -1, -1
                db -1, -1, 1, 1, 1, -1, -1
                db  1,  1, 1, 1, 1,  1,  1
                db  1,  0, 0, 0, 0,  0,  1
                db  1,  0, 0, 2, 0,  0,  1
                db -1, -1, 0, 0, 0, -1, -1
                db -1, -1, 0, 0, 0, -1, -1

    simboloZorro    db "O"
    simboloOca      db "X"

    rows equ 7
    cols equ 7

    newline db 10, 0      ; newline character
    empty_space db '.', 0 ; empty space character
    goose db 'O', 0       ; goose character
    fox db 'X', 0         ; fox character


section .bss
    auxIngreso  resb 20 ;Guarda el ultimo ingreso por teclado
    auxValidacion   resb 1 ;auxiliar en las opciones de validacion


section .text
main:
    mPrintf     msjInicioDelJuego

    mGets       auxIngreso

    jmp         validarIngreso


    



ret

validarIngreso:

    mov     al,[auxIngreso]
    mov     [auxValidacion],al

    mov     al,[opcionNuevaPartida]
    cmp     al,[auxValidacion]
    je      comienzoNuevaPartida

    mov     al,[opcionSalirJuego]
    cmp     al,[auxValidacion]
    je      salirDelJuego

    mPrintf msjErrorDeValidacion

    ret

salirDelJuego:
    mPrintf     msjSalidaDelJuego
    ret

comienzoNuevaPartida:
    mPrintf     msjComienzoNuevaPartida

    ;Esto se puede loopear
    mov rdi, tablero
    sub rsp, 8
    call        imprimirTablero
    add rsp,8

;    principioLoop:
;    call        preguntarPorMovimientoAlZorro
;
;    call        validarMovimientoDelZorro
;
;    cmp         rax,-1
;    je          principioLoop
;
;
;    call        realizarMovimientoDelZorro
;
;    call        verificaCondicionDeFinDePartida
;
;    ;fin del loop
;
;
;
;
;    call        imprimirTablero
;
;    call        preguntarPorMovimientoAOca
;
;    call        validarMovimientoDeOca
;
;    call        realizarMovimientoDeOca
;
;    call        verificaCondicionDeFinDePartida





    ret
