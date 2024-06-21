CC= gcc
AS = nasm
ASFLAGS= -f elf64 -g
CFLAGS= -no-pie -g

all: juego 

juego: juego.o
	$(CC) juego.o -o juego $(CFLAGS)

juego.o: juego.asm
	$(AS) juego.asm $(ASFLAGS)

clean: rm -f juego