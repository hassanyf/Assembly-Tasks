[org 0x0100]
	
	xor di, di
	mov ax,0xb800
	mov es,ax
	mov cx,25*80
	mov ax,0x748
	rep STOSW

	STD
	mov ax, 0xb800
	mov es, ax
	mov ds, ax
	xor di, di
	mov si, 24*80*2
	mov cx, 24*80
	rep MOVSW

	mov ax, 0x720
	mov cx, 80*2
	mov di,24*80*2
	RCR di, 1
	CLD
	rep STOSW

mov ax, 0x4c00 
INT 0x21