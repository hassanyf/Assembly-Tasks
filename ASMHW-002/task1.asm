[org 0x0100]

	mov ax,0xb800
	xor di, di
	mov es,ax
	mov cx,25*80
	mov ax,0x748
	rep STOSW
	
	mov ax, 0xb800
	STD
	mov ds, ax
	mov es, ax
	mov di, 24*80*2
	mov si, 24*80*2
	mov cx, 24*80
	rep MOVSW

	mov cx, 80*2
	mov ax, 0x720
	xor di, di
	CLD
	rep STOSW

mov ax, 0x4c00 
INT 0x21