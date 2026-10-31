BITS 16
ORG 0x7c00

start:
	; Enter graphics mode (320x200x8bpp) -> 0x13
	mov al, 0x13
	mov ah, 0x00
	int 0x10
	cli
	mov ax, 0
	mov ds, ax
	mov fs, ax
	mov gs, ax
	mov es, ax
	mov sp, 0x7c00

	lgdt [Gdtr]

	mov ebx, cr0
	or ebx, (1 << 0)
	mov cr0, ebx

	jmp 0x08:Entrada32

GdtStart:
	null:
		dq 0
		
	code:
		dd 0
		db 0
		db 0x9B
		db 0xCF
		db 0

	data:
		dd 0
		db 0
		db 0x9B
		db 0xCF
		db 0

GdtEnd:

Gdtr:
	dw GdtEnd - GdtStart
	dd GdtStart

[BITS 32]
Entrada32:
	mov ax, 0x10
	mov ds, ax
	mov fs, ax
	mov gs, ax
	mov es, ax

	jmp draw

draw:
	mov ecx, 0
	mov edi, 0

	jmp red_spain

red_spain:
	mov byte [0xA0000 + edi], 0x0C
	inc ecx
	inc edi
	cmp ecx, 320*66
		je yellow_spain
	jne red_spain

yellow_spain:
	mov byte [0xA0000 + edi], 0x0E
	inc ecx
	inc edi
	cmp ecx, 320*132
		je red_spain_2
	jne yellow_spain

red_spain_2:
	mov byte [0xA0000 + edi], 0x0C
	inc ecx
	inc edi
	cmp ecx, 320*198
		je hang
	jne red_spain_2
	
hang:
	hlt
	jmp hang

times 510 - ($ - $$) db 0
dw 0xAA55
