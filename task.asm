[org 0x0100]

	jmp start
	XCHR :dw 0x741

ISROB:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push ds
	push es
	push cs
	pop ds
	
	mov ax,0xb800
	mov es,ax
	mov ax,[XCHR]
	mov [es:160],ax
	inc al
	mov [XCHR],ax
	mov al,0x20 
	out 0x20,al
	pop cs
	pop es
	pop ds
	pop bp	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret

start:
	XOR ax,ax
	mov es,ax
	CLI
	mov word[es:(0x08*4)],ISROB
	mov [es:(0x08*4)+2],cs
	STI

LCK001:
	jmp LCK001

mov 0x4c00
INT 0x21