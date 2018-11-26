[org 0x0100]

start: mov cl, 16 
mov bx, 1 
checkbit: test bx, [multiplier] 
jz skip 
mov ax, [multiplicand]
add [result], ax
mov ax, [multiplicand+2]
adc [result+2], ax 
skip: shl word [multiplicand], 1
rcl word [multiplicand+2], 1 
shl bx, 1 
dec cl 
jnz checkbit 

mov ax, 0x4c00
int 0x21

multiplicand: dd 1300 ; 16bit multiplicand 32bit space
multiplier: dw 500 ; 16bit multiplier
result: dd 0 ; 32bit result
