[org 0x0100]
jmp start

News : db 'Foreign Policy Magazine --- ',0
flag : dw 0x0
crlscr:
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
PrntHealine:
	push si
	push di
	push ax
	push ds
	push es
	push ds
	mov ax,0xb800
	mov es,ax
	mov bx,0
	mov di,318+160
	mov ah,0x0f
A0001:
	mov al,[News+bx]
	mov word[es:di],ax
	cmp al,0
	je exit
A0002:
	push di
	mov di,160+160
	mov si,160+2+160
rep002:
	mov ax,[es:si]
	mov word[es:di],ax
	add di,2
	add si,2
	cmp di,318+160
	jne rep002
	pop di
	inc bx
	mov cx,3
rep0004:
	push cx
	mov cx,65000
rep0003:
	loop rep0003
	pop cx
	loop rep0004
	jmp A0001
exit:
	mov bx,0
	jmp A0001
	pop ds
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
	call crlscr
	call PrntStars
	call PrntHealine
mov ax,0x4c00
int 0x21