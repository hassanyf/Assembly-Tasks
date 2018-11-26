[org 0x0100]
jmp start

clrscr:
	push si
	push di
	push ax
	push ds
	push es
	mov ax,0xb800
	mov es,ax
	mov ax,0x720
	mov cx,4000
rep001:
	mov word[es:di],ax
	add di,2
	loop rep001
	pop es
	pop ds
	pop ax
	pop di
	pop si
	ret
PrntStars:
	push si
	push di
	push ax
	push ds
	push es
	mov ax,0xb800
	mov es,ax
	mov ax,0xf2A
	mov di,318
	mov cx,40
	mov bx,160
A001:
	push cx
	mov cx,3
rep004:
	push cx
	mov cx,65000
rep003:
	loop rep003
	pop cx
	loop rep004
	mov [es:di],ax
	push di
	mov di,bx
	mov [es:di],ax
	add bx,2
	pop di
	sub di,2
	pop cx
	loop A001
	pop es
	pop ds
	pop ax
	pop di
	pop si
	ret
start:
	call clrscr
	call PrntStars
	mov ax,0x4c00
	int 0x21