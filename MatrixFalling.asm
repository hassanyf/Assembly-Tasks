[org 0x0100]


jmp start
clrscr:
	push es
	push ax
	push cx
	push di
	mov ax,0xb800;load video memory
	mov es,ax
	mov cx,4000;to the end of screen
	mov di,0;point to start of screen
	mov ax,0x720;blank
here:
	mov word[es:di],ax;print on current location
	add di,2;increment to next position
	loop here
	pop di
	pop cx
	pop ax
	pop es
	ret
scrool:
	push si
	push di
	push cx
	push ax
	mov ax,0xb800
	mov es,ax
	mov ds,ax
	mov di,0
	mov si,160
	mov cx,4000
	cld
	rep movsw
	mov ax,0x720
	mov di,80*24*2
	cld
	mov cx,160
	rep stosw
	pop ax
	pop cx
	pop di
	pop si
	ret
Prnt:
	push es
	push ax
	push cx
	push di
	mov ax,0xb800;load video memory
	mov es,ax
	mov di,0;point to start of screen
	mov ah,0x0f
	mov al,0x30
	mov cx,2000
A001:
	push cx
	mov cx,65000
	push cx
	mov cx,65000
A004:
	loop A004
	pop cx
A002:
	loop A002
	pop cx
	mov word[es:di],ax;print on current location
	call scrool
	cmp al,0x31
	jne skip
	mov al,0x30
	jmp skip001
skip:
	add al,1
skip001:
	push ax
	mov ax,0x2
	mul cx
	mov bx,ax
	pop ax
	add di,bx
	loop A001
	Jmp A001
	pop di
	pop cx
	pop ax
	pop es
	ret

start:
	call clrscr
	call Prnt
	mov ax,0x4c00
	int 0x21