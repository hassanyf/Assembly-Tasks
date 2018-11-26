;TSR

[org 0x0100]

jmp start

oldisr: dd 0

kbsir:
	push ax
	push es

	mov ax, 0xb800
	mov es, ax

	in al, 0x60
	cmp al, 0x2a
	jne nextcmp

	mov byte [es:0], 'L'
	jmp exit

nextcmp:
	cmp al, 0x36
	jne nextcmp2
	
	mov byte [es:0], 'R'
	jmp exit

nextcmp2:
	cmp al, 0xaa
	jne nextcmp3

	mov byte [es:0], ' '
	jmp exit

nextcmp3:
	cmp al, 0xb6
	jne nomatch

	mov byte [es:2], ' '
	jmp exit

nomatch:
	pop es
	pop ax
	jmp far [cs:oldisr]

exit:
	mov al, 0x20
	out 0x20, al

	pop es
	pop ax
	iret

start:
	xor ax, ax
	mov es, ax
	mov ax, [es:9*4]
	mov [oldisr], ax
	mov ax, [es:9*4+2]
	mov [oldisr+2], ax
	cli
	mov word [es:9*4], kbsir
	mov [es:9*4+2], cs
	sti

	mov dx, start
	add dx, 15
	mov cl, 4
	shr dx, cl
	mov ax, 0x3100
	int 0x21