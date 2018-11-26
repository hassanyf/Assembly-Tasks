[org 0x0100]
jmp start

flag  : dw 0x0

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
A002:
	mov di,318
	mov cx,40
	mov bx,160
	add word[flag],1
A001:
	mov [es:di],ax
	push di
	mov di,bx
	mov [es:di],ax
	push cx
	mov cx,3
rep004:
	push cx
	mov cx,65000
rep003:
	loop rep003
	pop cx
	loop rep004
	pop cx
	add bx,2
	pop di
	sub di,2
	loop A001
	mov ax,0x720
	cmp word[flag],1
	je A002
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