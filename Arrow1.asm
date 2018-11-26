[org 0x0100]

old : dd 0
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
	mov di,0
	mov cx,4000
	rep stosw
	pop di
	pop cx
	pop ax
	pop es
	ret
Kb:
	push ax
	push es
	mov ax,0xb800
	mov es,ax
	in al,0x60
	cmp al,0x4D
	jne Nxt001
	mov ah,0x0f
	mov di,0
again001:
	mov al,0x2D
	stosw
	mov al,0x3E
	stosw
	mov cx,8
rep004:
	push cx
	mov cx,65000
rep003:
	loop rep003
	pop cx
	loop rep004
	call clrscr
	cmp di,160
	jne again001
Nxt001:
	in al,0x60
	cmp al,0x50
	jne Nxt002
	mov ah,0x0f
	mov di,158
again002:
	mov al,0x7C
	mov [es:di],ax
	mov al,0x56
	add di,160
	mov [es:di],ax
	add di,160
	mov cx,8
rep005:
	push cx
	mov cx,65000
rep006:
	loop rep006
	pop cx
	loop rep005
	call clrscr
	cmp di,3998
	jne again002
Nxt002:
	in al,0x60
	cmp al,0x4B
	jne Nxt003
	mov ah,0x0f
	mov di,3998
	STD
again003:
	mov al,0x2D
	mov [es:di],ax
	sub di,2
	mov al,0x3C
	mov [es:di],ax
	sub di,2
	mov cx,8
rep007:
	push cx
	mov cx,65000
rep008:
	loop rep008
	pop cx
	loop rep007
	push di
	add di,4
	mov word[es:di],0x720
	sub di,2
	mov word[es:di],0x720
	pop di
	cmp di,3838
	jne again003
Nxt003:
	in al,0x60
	cmp al,0x48
	jne exit
	mov ah,0x0f
	mov di,3840
again004:
	mov al,0x7c
	mov [es:di],ax
	mov al,0x5E
	sub di,160
	mov [es:di],ax
	sub di,160
	mov cx,8
rep009:
	push cx
	mov cx,65000
rep010:
	loop rep010
	pop cx
	loop rep009
	call clrscr
	cmp di,0
	jne again004
exit:	
	mov al,0x20
	out 0x20,al
	pop es
	pop ax
	jmp far [cs:old]
	;iret
start:
	call clrscr
	xor ax,ax
	mov es,ax
	mov ax,[es:9*4]
	mov [old],ax
	mov ax,[es:9*4+2]
	mov [old+2],ax
	cli
	mov word[es:9*4],Kb
	mov [es:9*4+2],cs
	sti
l1:
	mov ah,0
	int 0x16
	cmp al,27
	jne l1
	mov ax,[old]
	mov [es:9*4],ax
	mov ax,[old+2]
	mov [es:9*4+2],ax
	mov ax,0x4c00
	int 0x21