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



section .data
    msjInicioDelJuego   db "--EL ZORRO Y LAS OCAS",10,10,"Elija una opcion para jugar",10,"1 - Nueva Partida",10,"2 - Salir del juego",10,0


section .bss
    auxIngreso  resb 20 ;Guarda el ultimo ingreso por teclado


section .text
main:
    mPrintf     msjInicioDelJuego

    mGets       auxIngreso

    mPrintf     auxIngreso



ret