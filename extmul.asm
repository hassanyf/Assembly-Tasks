; 16bit multiplication
[org 0x0100]
 
	mov cl, 16 
	mov dx, [multiplier] 
checkbit: 
	SHR dx, 1 
	jnc here 
	mov ax, [multiplicand]
	add [result], ax 
	mov ax, [multiplicand + 2]
	adc [result + 2], ax 
here: 
	SHL word [multiplicand], 1
	RCL word [multiplicand + 2], 1 
	dec cl 
	jnz checkbit 

mov ax, 0x4c00 
INT 0x21

multiplicand: dd 1300
multiplier: dw 500
result: dd 0 