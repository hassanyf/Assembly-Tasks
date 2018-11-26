[org 0x0100]
	
	mov cl, 130
	mov al, 250
	xor dx, dx
	ip:
	sub cl, al
	inc cl
	inc dx
	jc ip


INT 0x21