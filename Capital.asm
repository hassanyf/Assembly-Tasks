[org 0x0100]

jmp START

ALPHAS: dd 0

CLRSCREEN:
	push es
	push ax
	push cx
	push di
	mov ax,0xb800
	mov es,ax
	XOR di,di
	mov ax,0x720
	mov cx,4000
	rep STOSW
	pop di
	pop cx
	pop ax
	pop es
	ret

MYINT:
	
	pushf
	push cs
	push RETURN

	jmp far [ALPHAS]

RETURN:
	cmp al,27
	je EXIT

	sub al,0x20

EXIT:
	iret

START:
	call CLRSCREEN 
	XOR ax,ax
	mov es,ax
	
	mov ax,[es:16h*4]
	mov [ALPHAS],ax
	mov ax,[es:16h*4+2]
	mov [ALPHAS+2],ax
	cli
	mov word[es:16h*4],MYINT
	mov [es:16h*4+2],cs
	sti

	mov ax,0xb800
	mov es, ax
HERE:
	mov ah,0
	int 0x16

	cmp al,27
	je TERMINATE

	mov ah,0x07
	mov [es:0],ax
	
	jmp HERE

TERMINATE:

	mov ax,[ALPHAS]
	mov [es:16h*4],ax
	mov ax,[ALPHAS+2]
	mov [es:16h*4+2],ax

	mov ax,0x4c00
	int 0x21