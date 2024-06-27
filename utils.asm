global cargarPartida
global guardarPartida
extern fopen
extern fclose
extern fread
extern fwrite


section .data

    nombreArchivo db "saved_game.dat",0
    modoLeer  db "rb",0
    modoGuardar  db "wb",0
    
section .bss
    auxTablero resb 100 
    handleArchivo resq 1
    tempTableroDir resq 1

section .text


cargarPartida: ; Parametros: rdi ->  direccion del tablero

    mov     [tempTableroDir], rdi
    mov     rdi,nombreArchivo   
    mov     rsi,modoLeer 
    sub     rsp,8
    call    fopen
    add     rsp,8

    cmp		rax,0
	jle		errorAlAbrir
	mov     [handleArchivo],rax

    mov     rdi,[tempTableroDir]    
    mov     rsi,59                 
    mov     rdx,1                   
	mov		rcx,[handleArchivo]    
	sub		rsp,8  
	call    fread
	add		rsp,8

    jmp      cerrarArchivo
    
guardarPartida: ; Parametros: rdi ->  direccion del tablero
    mov     [tempTableroDir], rdi
    mov     rdi,nombreArchivo   
    mov     rsi,modoGuardar
    sub     rsp,8
    call    fopen
    add     rsp,8

    cmp		rax,0
	jle		errorAlAbrir
	mov     [handleArchivo],rax

    mov     rdi,[tempTableroDir]    
    mov     rsi,59                 
    mov     rdx,1                   
	mov		rcx,[handleArchivo]    
	sub		rsp,8  
	call    fwrite
	add		rsp,8

    jmp      cerrarArchivo


errorAlAbrir: 
    mov rax, -1
    ret

cerrarArchivo:
    mov     rdi,[handleArchivo]
    sub     rsp,8
    call    fclose
    add     rsp,8

    mov rax, 0
    ret