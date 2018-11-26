[org 0x0100]

mov ax, [NUM1 + 2]
mov bx, [NUM2 + 2]
mul bx

mov [temp1], dx:ax
mov ax, [NUM1]
mul bx

add [temp1], dx:ax
mov ax, [NUM1 + 2]
mov bx, [NUM2 + 1]
mul bx

mov [temp2], dx:ax
mov ax, [NUM1]
mul bx

SHL dx:ax, 1 
add [temp1], dx:ax

mov ax, 0x4c00
INT 0x21

NUM1: dw 2, 4
NUM2: dw 1, 6

temp1: dd 0
temp2: dd 0