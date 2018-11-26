org 0x100;
	jmp start

timer:
	inc word [tickcount]
	cmp word [tickcount],18
	je reset
	jmp rettimer
	reset:
	mov word [tickcount],0
	call second1
	call print
	rettimer:
	mov al,0x20
	out 0x20,al
	iret
	
second1:
	inc byte [sec1]
	cmp byte [sec1],10
	jne retsec1
	call resetsecond1
	retsec1:
	ret
	
resetsecond1:
	mov byte [sec1],0
	call second2
	ret
	
second2:
	inc byte [sec2]
	cmp byte [sec2],6
	jne retsec2
	call resetsecond2
	retsec2:
	ret
	
resetsecond2:
	mov byte [sec2],0
	call minute1
	ret
	
minute1:
	inc byte [min1]
	cmp byte [min1],10
	jne retmin1
	call resetminute1
	retmin1:
	ret
	
resetminute1:
	mov byte [min1],0
	call minute2
	ret
	
minute2:
	inc byte [min2]
	cmp byte [min2],6
	jne retmin1
	call resetminute2
	retmin2:
	ret
	
resetminute2:
	mov byte [min2],0
	call hour1
	ret
	
hour1:
	inc byte [hr1]
	cmp byte [hr1],10
	jne rethr1
	call resethour1
	rethr1:
	ret
	
resethour1:
	mov byte [hr1],0
	ret

	
print:
	push ax
	push es
	push ds
	push di
	xor ax,ax
	mov ax,0xB800
	mov es,ax
	xor di,di
	mov di,12*160+40
	mov ah,0x07
	mov al,[hr1]
	add al,30h
	mov [es:di],ax
	add di,2
	mov al,3Ah
	mov [es:di],ax
	add di,2
	mov al,[min2]
	add al,30h
	mov [es:di],ax
	add di,2
	mov al,[min1]
	add al,30h
	mov [es:di],ax
	add di,2
	mov al,3Ah
	mov [es:di],ax
	add di,2
	mov al,[sec2]
	add al,30h
	mov [es:di],ax
	add di,2
	mov al,[sec1]
	add al,30h
	mov [es:di],ax
	add di,2
	xor di,di
	pop di	
	pop ds
	pop es
	pop ax
	ret

start:
	xor ax,ax
	mov es,ax
	cli
	mov word [es:8*4],timer
	mov [es:8*4+2],cs
	sti
	here:
	jmp here
	
	
	
tickcount: dw 0
sec1: db 0
min1: db 0
min2: db 0
hr1: db 0
sec2: db 0