[org 0x100]

	jmp START

; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30

PCB: dw 16*16  
TSTACK: dw 256*16
maxPCB: dw 16h 
THREND: dw 0

;nextPCB: dw 1 ; index of next free PCB
CURRENT: dw 0

AXOFFSET equ 4
BXOFFSET equ 6
CXOFFSET equ 8
DXOFFSET equ 10
SIOFFSET equ 12
DIOFFSET equ 14
BPOFFSET equ 16
SPOFFSET equ 18
IPOFFSET equ 20
CSOFFSET equ 22
;FLAGSOFFSET equ 24
DSOFFSET equ 26
ESOFFSET equ 28
SSOFFSET equ 30


SAVESTATE:
	push bp
	mov bp,sp
	push ax
	push bx
	mov bx,[cs:CURRENT]
	shl bx,5
	mov [cs:PCB+CXOFFSET + bx],cx
	mov [cs:PCB+DXOFFSET + bx],dx
	mov [cs:PCB+SIOFFSET + bx],si
	mov [cs:PCB+DIOFFSET + bx],di
	mov [cs:PCB+BPOFFSET + bx],bp
	mov [cs:PCB+SPOFFSET + bx],sp
	;mov [cs:PCB+IPOFFSET + bx],ip
	mov [cs:PCB+DSOFFSET + bx],ds
	;mov [cs:PCB+FLAGSOFFSET + bx],flags
	mov [cs:PCB+CSOFFSET + bx],cs
	mov [cs:PCB+ESOFFSET + bx],es
	mov [cs:PCB+SSOFFSET + bx],ss

	mov ax,[bp-2]
	mov [cs:PCB+AXOFFSET + bx],ax
	mov ax,[bp-4]
	mov [cs:PCB+BXOFFSET + bx],ax

	pop bx
	pop ax
	pop bp
	ret

getNEXT:
	mov bx,ax
	shl bx,5
	mov ax,[cs:PCB+bx]
	and ax,0x0FF
	ret 

RESTORESTATE:
	mov [cs:CURRENT],ax
	mov bx,ax
	shl bx,5
	CLI
	mov ax,[cs:PCB+SSOFFSET]
	mov ss,ax
	mov ax,[cs:PCB+bx+SPOFFSET]
	mov sp,ax
	STI
	mov si,[cs:PCB+bx+SIOFFSET]
	mov di,[cs:PCB+bx+DIOFFSET]
	mov bp,[cs:PCB+bx+CSOFFSET]
	mov cx,[cs:PCB+bx+CXOFFSET]
	mov dx,[cs:PCB+bx+DXOFFSET]
	mov es,[cs:PCB+bx+ESOFFSET]
	mov ds,[cs:PCB+bx+DSOFFSET]
	mov ax,[cs:PCB+bx+CSOFFSET]
	push ax
	mov ax,[cs:PCB+bx+IPOFFSET]
	push ax
	mov al,0x20
	out 20h,al
	mov ax,[cs:PCB+bx+BXOFFSET]
	push ax
	mov ax,[cs:PCB+bx+AXOFFSET]
	push ax
	pop bx
	iret
	; end of restore

GETFREEPCB:
	mov cx,1

nPCB:
	mov bx,cx
	shl bx,5
	cmp word[cs:PCB+bx],0xFFFF
	je proceed

	inc cx
	cmp cx,maxPCB
	je PCBfull
	jmp nPCB

proceed:
	mov ax, bx
	ret

PCBfull:	
	mov ax,0xFFFF
	ret

initPCB:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push si

	call GETFREEPCB
	cmp ax,0xFFFF
	jz EXITFAIL
	mov bx,ax
	push ax
	shl bx,5

	mov ax,[bp+8]
	mov [cs:PCB+bx+CSOFFSET],ax
	mov ax,[bp+6]
	mov [cs:PCB+bx+IPOFFSET],ax
	mov ax,[bp+10]
	mov [cs:PCB+bx+ESOFFSET],ax
	mov ax,[bp+12]
	mov [cs:PCB+bx+DSOFFSET],ax
	mov [cs:PCB+bx+SSOFFSET],cs

	pop ax
	push ax
	mov ah,al
	xor al,al
	inc ah
	add ax,[TSTACK]
	mov si,ax

	mov ax,[bp+4]
	mov [cs:si],ax
	sub si,2
	mov ax,[bp+2]
	mov [cs:si],cs
	sub si,2
	mov [cs:si],cs
	sub si,2
	mov word[cs:si],THREND
	mov [cs:PCB+bx+SPOFFSET],si

	xor ax,ax
	mov [cs:PCB+bx+AXOFFSET],ax
	mov [cs:PCB+bx+BXOFFSET],bx
	mov [cs:PCB+bx+CXOFFSET],cx
	mov [cs:PCB+bx+DXOFFSET],dx
	mov [cs:PCB+bx+SIOFFSET],si
	mov [cs:PCB+bx+DIOFFSET],di
	mov [cs:PCB+bx+BPOFFSET],bp
	pop ax

	pop si
	pop cx
	pop bx
	pop ax

	pop bp
	ret 12

insertPCB:
	mov bx,ax
	push ax
	shl bx,5
	mov ax,[cs:PCB]
	mov word[cs:PCB+bx+0],0  ; set 0 to previous
	mov [cs:PCB+bx+1],al
	mov al,[cs:PCB+bx+2]
	or al,0x01 ; activate flag=1
	pop ax
	CLI
	mov [cs:PCB],al
	STI
	ret

@@001: ;create thread 0x01 subservice
	push ds
	push es
	push cx
	push bx
	push si
	push di

	call initPCB
	ret

MYINT21:
	cmp ah,0xFF
	je MYCANDIDATE
	jmp EXITFAIL

MYCANDIDATE:
	pusha
	cmp al,0x01
	je @@001
	jmp EXITFAIL
	popa
	iret	

START:
	xor ax,ax
	mov es,ax
	CLI
	mov word[cs:21*4],MYINT21
	mov word[cs:(21*4)+2],cs
	STI
	mov al,0x01
	int 21h

EXITFAIL:
	mov ax,4c00h
	int 21h