[org 0x0100]

jmp START
	
CLRSCREEN:
	push ax
	push es
	mov ax, 0xb800
	mov es,ax
	mov cx, 4000
	mov ax, 0x0720
	CLD
	rep stosw
	in al,0x60
	cmp al,0x48		;up scan code
	jne nextcmp
	call UP
	jmp nomatch
nextcmp:
	cmp al,0x4B
	jne nextcmp1
	call LEFT
	jmp nomatch
nextcmp1:
	cmp al,0x4D
	jne nextcmp2
	call RIGHT
	jmp nomatch
nextcmp2:
	cmp al,0x50
	jne nomatch
	call DOWN
	
nomatch:
	mov al, 0x20
	out 0x20, al ; send EOI to PIC
	pop es
	pop ax
	iret

RIGHT:
	push ax
	push es
	mov ax, 0xb800
	mov es,ax
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
	pop es
	pop ax
	ret

DOWN:
	push ax
	push es
	mov ax, 0xb800
	mov es,ax
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
	pop es
	pop ax
	ret

LEFT:
	push ax
	push es
	mov ax, 0xb800
	mov es,ax
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
	pop es
	pop ax
	ret
	
UP:
	push ax
	push es
	mov ax, 0xb800
	mov es,ax
	
	mov di, 3840
	mov cx, 25
there1:
	mov ax, 0x075e
	push cx
	mov cx, 60000
delay5:
	loop delay5
	pop cx
	add di, 160
	push ax
	mov ax, 0x0720
	mov word[es:di], ax
	pop ax
	sub di, 160
	;CLD
	stosw
	sub di, 158
	loop there1
	pop es
	pop ax
	ret

START:
xor ax,ax
mov es,ax
cli
mov word[es:9*4],CLRSCREEN
mov [es:9*4+2],cs
sti
l1:
jmp l1
;lr:

;	call CLRSCREEN
;	call RIGHT
;	call DOWN
;	call LEFT
;	call UP
;call lr
;mov ax, 0x4c00
;INT 0x21