[org 0x0100]
[org 0x0100]
jmp start
old : dd 0
tick: dw 0
flag: dw 0
News : db 'Muhammad Haseeb----',0
clrscr:
	pusha
	mov ax,0xb800;load video memory
	mov es,ax
	mov cx,4000;to the end of screen
	mov di,0;point to start of screen
	mov ax,0x720;blank
	mov di,0
	mov cx,4000
	rep stosw
	popa
	ret
prnt:
	pusha
	mov ax,0xb800
	mov es,ax
	mov bx,0
	mov di,318
	mov ah,0x0f
A001:
	mov al,[cs:News+bx]
	mov word[es:di],ax
	cmp al,0
	je exit
A002:
	push di
	mov di,160
	mov si,160+2
rep002:
	mov ax,[es:si]
	mov word[es:di],ax
	add di,2
	add si,2
	cmp di,318
	jne rep002
	pop di
	inc bx
	mov cx,3
rep004:
	push cx
	mov cx,65000
rep003:
	loop rep003
	pop cx
	loop rep004
	jmp A001
exit:
	mov word[cs:flag],1
	popa
	ret
timer:
	push ax
	inc word[cs:tick]
	cmp word[cs:tick],18*3
	jbe exit001
	mov word[cs:tick],0
	cmp word[cs:flag],0
	jne exit001
	call prnt
exit001:
	mov al,0x20
	out 0x20,al
	pop ax
	iret

Kb:
	push ax
	in al,0x60
	cmp al,0x2a
	jne nomatch
	mov word[cs:flag],1
	call clrscr
	jmp exit002
nomatch:
	mov word[cs:flag],0
	pop ax
	jmp far[cs:old]
exit002:
	mov al,0x20
	out 0x20,al
	pop ax
	iret
start:
	call clrscr
	xor ax,ax
	mov es,ax
	mov ax,[es:9*4]
	mov [old],ax
	mov ax,[es:9*4+2]
	mov [old+2],ax
	cli
	mov word[es:8*4],timer
	mov [es:8*4+2],cs
	mov word[es:9*4],Kb
	mov [es:9*4+2],cs
	sti
mov dx,start
add dx,15
mov cl,4
shr dx,cl
mov ax,0x3100
int 0x21