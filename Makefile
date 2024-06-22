CC= gcc
AS = nasm
ASFLAGS= -f elf64 -g
CFLAGS= -no-pie -g

all: juego 

juego: juego.o funciones.o validaciones.o
	$(CC) juego.o funciones.o validaciones.o -o juego $(CFLAGS)

juego.o: juego.asm
	$(AS) juego.asm $(ASFLAGS)

funciones.o: funciones.asm
	$(AS) funciones.asm $(ASFLAGS)

validaciones.o: validaciones.asm
	$(AS) validaciones.asm $(ASFLAGS)
	
clean: rm -f juego