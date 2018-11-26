;moving two astericks
[org 0x0100]
jmp start
clrscreen:
	push ax
	push es
	push di
	
	xor di,di
	mov ax,0xb800
	mov es,ax

	mov ax,0x0720
	mov cx,4000
	cld
	rep stosw
	
	pop ax
	pop es
	pop di
	ret
Forward:
	push bp
	mov bp,sp
	push ax
	push cx
	push di
	
	xor di,di
	mov ax,0xb800
	mov es,ax
	mov di,960
	mov cx,40
here:
	mov ax,0x072a
	push cx
	mov cx,60000
delay:
	loop delay
	pop cx
	dec di
	dec di
	push ax
	mov ax,0x0720
	mov word[es:di],ax
	pop ax
	inc di
	inc di
	cmp cx,0
	cld
	stosw
	loop here
	
	push ax
	push cx
	mov di,1120
	mov cx,40
where:
	
	mov ax,0x072a
	push cx
	mov cx,60000
	
delay1:
	loop delay1
	pop cx
	inc di
	inc di
	push ax
	mov ax,0x0720
	mov word[es:di],ax
	pop ax
	dec di
	dec di
	cmp cx,0
	std
	stosw
	cmp cx,0
	loop where
	
	push ax
	push cx
	mov di,1040
	mov cx,40
	
Khere:
	
	mov ax,0x072a
	push cx
	mov cx,60000
	
delay2:
	loop delay2
	pop cx
	inc di
	inc di
	push ax
	mov ax,0x0720
	mov word[es:di],ax
	pop ax
	dec di
	dec di
	cmp cx,0
	std
	stosw
	cmp cx,0
	loop Khere
	
	push ax
	push cx
	mov di,1040
	mov cx,40
Nhere:
	mov ax,0x072a
	push cx
	mov cx,60000
	
delay3:
	loop delay3
	pop cx
	dec di
	dec di
	push ax
	mov ax,0x0720
	mov word[es:di],ax
	pop ax
	inc di
	inc di
	cmp cx,0
	cld
	stosw
	cmp cx,0
	loop Nhere
	
	pop di
	pop cx
	pop ax
	pop bp
	ret
	
start:
	
infinite:
	call clrscreen
	call Forward
	jmp infinite
	
	mov ax,0x4c00
	INT 0X21