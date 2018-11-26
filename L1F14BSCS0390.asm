[org 0x0100]

ISR08: 
	call SAMESTATE
	call GETNEXT
	call RESTORESTATE
	push ax
	mov al, 0x20
	out 20h, al
	pop ax
	iret

SAMESTATE:
	push bp
	mov bp, sp
	push ax
	push bx
	mov bx, cx:[CURRPROCESS]
	SHL bx, 5
	mov cs:[PCB + CXOFFSET + bx], cx
	mov cs:[PCB + DXOFFSET + bx], dx
	mov cx:[PCB + BXOFFSET + bx], bx
	mov ax, [bp - 2]
	mov cx:[PCB + AXOFFSET + bx], ax
	mov ax, [bp - 4]
	mov cs:[PCB + BXOFFSET + bx], ax
	pop bx
	pop ax
	pop bp

GETNEXT:
	mov bx, ax
	mov bx, [CURRPROCESS]
	SHL bx, 5
	mov ax, cs:[PCB + bx]
	and ax, 0x0FF
	ret

RESTORESTATE:
	mov cs:[CURRPROCESS], ax
	mov bx, ax
	SHL bx, 5
	CLI
	mov ax, cs:[PCB + bx + SSOFFSET]
	mov ss, ax
	mov ax, cs:[PCB + bx + SPOFFSET]
	mov sp, ax
	STI
	mov si, cs:[PCB + bx + SIOFFSET]
	mov di, cs:[PCB + bx + DIOFFSET]
	mov cs, cs:[PCB + bx + CSOFFSET]
	mov dx, cs:[PCB + bx + DXOFFSET]
	mov es, cs:[PCB + bx + ESOFFSET]
	mov ds, cs:[PCB + bx + DSOFFSET]
	mov ax, cs:[PCB + bx + FLAGOFFSET]
	push ax
	mov ax, cs:[PCB + bx + CSOFFSET]
	mov ax, cs:[PCB + bx + IPOFFSET]
	push ax
	mov al, 0x20
	out 20h, al
	mov x, cs:[PCB + bx + BXOFFSET]
	push ax
	mov ax, cs:[PCB + bx + AXOFFSET]
	pop bx
	iret

CURRENTTHREAD:
	push bp
	mov bp, sp
	call GETFREEPCB

GETFREEPCB:
	mov cx, 1

nPCB:
	mov bx, cx
	mov bx, 1
	SHL bx, 5
	cmp [byte] cs:[PCB + bx], 0xFFFF
	je PROCEED
	inc cx
	cmp cx, MAXPCB
	je PCBFULL
	jmp nPCB

PROCEED:
	mov ax, cx
	ret

PCBFULL:
	mov ax, 0xFFFF
	ret

INITPCB:
	push bp
	mov bp, sp
	call GETFREEPCB
	cmp ax, 0xFFFF
	jz EXITFAIL
	push ax
	mov bx, ax
	SHL bx, 5
	mov ax, [bp + 8]
	mov cs:[PCB + bx + CSOFFSET], ax
	mov ax, [bp + 6]
	mov cs:[PCB + bx + IPOFFSET], ax
	mov ax, [bp + 10]
	mov cs:[PCB + bx + ESOFFSET], ax
	mov ax, [bp + 12]
	mov cs:[PCB + bx + DSOFFSET], ax
	mov cs:[PCB + bx + SSOFFSET], cs
	pop ax
	push ax
	mov ah, al
	XOR al, al
	inc ah
	add ax, TSTACK
	mov si, ax
	mov ax, [bp + 4]
	mov cs:[si], ax
	sub si, 2
	mov ax, [bp + 2]
	mov cs:[si], ax
	sub si, 2
	mov cs:[si], ax
	sub si, 2
	mov cs:[si], THREND
	mov cs:[PCB + bx + SPOFFSET], si
	mov ax, ax
	mov cs:[PCB + bx + AXOFFSET], ax
	mov cs:[PCB + bx + BXOFFSET], ax
	mov cs:[PCB + bx + CXOFFSET], ax
	mov cs:[PCB + bx + DXOFFSET], ax
	mov cs:[PCB + bx + SIOFFSET], ax
	mov cs:[PCB + bx + DIOFFSET], ax
	mov cs:[PCB + bx + BPOFFSET], ax
	pop ax
	pop bp
	ret 12

CREATETHREAD:
	call INITPCB
	cmp ax, 0xFFFF
	je EXITFULL
	call INSERTPCB
	ret

INSERTPCB:
	mov bx, ax
	push ax
	SHL bx, 5
	mov ax, es:[PCB]
	mov cs:[PCB + bx + PREV], 0
	mov cs:[PCB + bx + NEXT], al
	pop ax
	CLI
	mov cs:[PCB], al
	STI
	; additional code left
	ret

SUSPENDTHREAD:
	mov bx, ax
	push ax
	SHL bx, 5
	mov al, [PCB + bx + 2]
	and al, 0x03
	cmp al, 0x01
	jne EXITFALSE

RESUMETHREAD:
	; to be coded

DELETETHREAD:
	; to be coded

MYINT20h:
	; push all
	cmp ah, 0xFF
	je MYCANDIDATE
	; pop all
	jmp far cs:[OLDDOSISR]

MYCANDIDATE:
	cmp al, 0x01
	je @@001
	cmp al, 0x02
	je @@002

@@001:
	push ds
	push es
	push cs
	push bx
	push si
	push di
	call GETFREEPCB
	cmp ax, 0xFFFF
	je ERROREXIT
	call INITPCB

mov ax, 0x4c00
INT 0x21

PCB: dw 16*16
TSTACK: dw: 256*16
CURRPROCESS: dw 0
MAXPCB: dw 16
; NOTE: EQU is used for constants
AXOFFSET EQU 4
BXOFFSET EQU 6
CXOFFSET EQU 8
DXOFFSET EQU 10
SIOFFSET EQU 12
DIOFFSET EQU 14
BPOFFSET EQU 16
SPOFFSET EQU 18
IPOFFSET EQU 20
CSOFFSET EQU 22
FLAGOFFSET EQU 24
DSOFFSET EQU 26
ESOFFSET EQU 28
SSOFFSET EQU 30
