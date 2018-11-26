[org 0x100]

mov ax,[num1+2]
mov bx,[num2+2]
mul bx
mov word[temp1],dx;corrected
mov word[temp1+2],ax;corrected
mov ax,[num1]
mul bx
add word[temp1],dx	
add word[temp1+2],ax	;add [temp1],dx:ax
mov ax,[num1+2]
mov bx,[num2+1]
mul bx
mov word[temp2],dx
mov word[temp2+2],ax
mov ax,[num1]
mul bx
add word[temp2],dx
add word[temp2+2],ax
shl word[temp2],1
rcl word[temp1+2],1
mov dx,[temp2]
mov ax,[temp2+2]

add [temp1],dx
add [temp1+2],ax

mov ax,0x4c00
int 0x21

num1: dw 5,7
num2: dw 9,8
temp1: dd 0,0
temp2: dd 0,0