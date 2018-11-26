[org 0x0100]

jmp START
	
CLRSCREEN:
	mov cx, 4000
	mov ax, 0x0720
	CLD
	rep stosw
	ret

RIGHT:
	xor di, di
	mov cx, 80
here:
	mov ax, 0x073E
	push cx
	mov cx, 60000
delay:
	loop delay
	pop cx
	dec di
	dec di
	push ax
	mov ax, 0x0720
	mov word[es:di], ax
	pop ax
	inc di
	inc di
	CLD
	stosw
	loop here
	ret

DOWN:
	mov di, 318
	mov cx, 25
there:
	mov ax, 0x0756
	push cx
	mov cx, 60000
delay1:
	loop delay1
	pop cx
	sub di, 160
	push ax
	mov ax, 0x0720
	mov word[es:di], ax
	pop ax
	add di, 160
	CLD
	stosw
	add di, 158
	loop there
	ret

LEFT:
	mov di, 4000
	mov cx, 80
where:
	mov ax, 0x073C
	push cx
	mov cx, 60000
delay3:
	loop delay3
	pop cx
	inc di
	inc di
	push ax
	mov ax, 0x0720
	mov word[es:di], ax
	pop ax
	dec di
	dec di
	STD
	stosw
	loop where
	ret

START:
	mov ax, 0xb800
	mov es,ax
	call CLRSCREEN
	call RIGHT
	call DOWN
	call LEFT

mov ax, 0x4c00
INT 0x21