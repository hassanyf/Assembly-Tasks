[org 0x0100]

	mov cx, 9
there:
	xor bx, bx
here:
	mov al, [NUMS + bx]
	cmp al, [NUMS + bx + 1]
	ja noswap
	mov ah, [NUMS + bx + 1]
	mov [NUMS + bx + 1], al
	mov [NUMS + bx], ah
	loop there
noswap:
	inc bx
	cmp bx, 9
	jne here
	loop there 

INT 0x21

NUMS: db 25h, 30h, 1h, 5h, 7h, 10h