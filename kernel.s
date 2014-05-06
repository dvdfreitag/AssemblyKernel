	.file	"kernel.cpp"
	.intel_syntax noprefix
	.text
	.align 16
	.globl	_Z10make_color9vga_colorS_
	.type	_Z10make_color9vga_colorS_, @function
_Z10make_color9vga_colorS_:
.LFB0:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+8]
	mov	edx, DWORD PTR [esp+4]
	sal	eax, 4
	or	eax, edx
	ret
	.cfi_endproc
.LFE0:
	.size	_Z10make_color9vga_colorS_, .-_Z10make_color9vga_colorS_
	.align 16
	.globl	_Z13make_vgaentrych
	.type	_Z13make_vgaentrych, @function
_Z13make_vgaentrych:
.LFB1:
	.cfi_startproc
	xor	edx, edx
	mov	dl, BYTE PTR [esp+8]
	movsx	ax, BYTE PTR [esp+4]
	sal	edx, 8
	or	eax, edx
	ret
	.cfi_endproc
.LFE1:
	.size	_Z13make_vgaentrych, .-_Z13make_vgaentrych
	.align 16
	.globl	_Z6strlenPKc
	.type	_Z6strlenPKc, @function
_Z6strlenPKc:
.LFB2:
	.cfi_startproc
	mov	ecx, DWORD PTR [esp+4]
	xor	eax, eax
	cmp	BYTE PTR [ecx], 0
	je	.L6
	.align 16
.L5:
	inc	eax
	xor	edx, edx
	mov	dl, al
	cmp	BYTE PTR [ecx+edx], 0
	jne	.L5
	ret
.L6:
	ret
	.cfi_endproc
.LFE2:
	.size	_Z6strlenPKc, .-_Z6strlenPKc
	.align 16
	.globl	_Z19terminal_initializev
	.type	_Z19terminal_initializev, @function
_Z19terminal_initializev:
.LFB3:
	.cfi_startproc
	push	ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	mov	BYTE PTR terminal_row, 0
	mov	BYTE PTR terminal_column, 0
	mov	BYTE PTR terminal_color, 7
	mov	DWORD PTR terminal_buffer, 753664
	xor	ecx, ecx
	xor	ebx, ebx
	.align 16
.L9:
	xor	eax, eax
	.align 16
.L12:
	lea	edx, [ecx+eax]
	inc	eax
	and	edx, 255
	cmp	al, 80
	mov	WORD PTR [edx+753664+edx], 1824
	jne	.L12
	inc	ebx
	add	ecx, 80
	cmp	bl, 24
	jne	.L9
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE3:
	.size	_Z19terminal_initializev, .-_Z19terminal_initializev
	.align 16
	.globl	_Z17terminal_setcolorh
	.type	_Z17terminal_setcolorh, @function
_Z17terminal_setcolorh:
.LFB4:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+4]
	mov	BYTE PTR terminal_color, al
	ret
	.cfi_endproc
.LFE4:
	.size	_Z17terminal_setcolorh, .-_Z17terminal_setcolorh
	.align 16
	.globl	_Z19terminal_putentryatchhh
	.type	_Z19terminal_putentryatchhh, @function
_Z19terminal_putentryatchhh:
.LFB5:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+16]
	mov	ecx, DWORD PTR [esp+12]
	movsx	dx, BYTE PTR [esp+4]
	lea	eax, [eax+eax*4]
	sal	eax, 4
	add	eax, ecx
	xor	ecx, ecx
	mov	cl, BYTE PTR [esp+8]
	and	eax, 255
	sal	ecx, 8
	or	edx, ecx
	mov	ecx, DWORD PTR terminal_buffer
	mov	WORD PTR [ecx+eax*2], dx
	ret
	.cfi_endproc
.LFE5:
	.size	_Z19terminal_putentryatchhh, .-_Z19terminal_putentryatchhh
	.align 16
	.globl	_Z16terminal_putcharc
	.type	_Z16terminal_putcharc, @function
_Z16terminal_putcharc:
.LFB6:
	.cfi_startproc
	mov	cl, BYTE PTR terminal_row
	push	esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	push	ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	mov	bl, BYTE PTR terminal_column
	lea	eax, [ecx+ecx*4]
	xor	edx, edx
	sal	eax, 4
	mov	dl, BYTE PTR terminal_color
	sal	edx, 8
	add	eax, ebx
	mov	esi, eax
	movsx	ax, BYTE PTR [esp+12]
	and	esi, 255
	or	eax, edx
	mov	edx, DWORD PTR terminal_buffer
	mov	WORD PTR [edx+esi*2], ax
	lea	eax, [ebx+1]
	mov	BYTE PTR terminal_column, al
	cmp	al, 80
	je	.L21
.L16:
	pop	ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.align 16
.L21:
	.cfi_restore_state
	inc	ecx
	mov	BYTE PTR terminal_column, 0
	mov	BYTE PTR terminal_row, cl
	cmp	cl, 24
	jne	.L16
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	mov	BYTE PTR terminal_row, 0
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE6:
	.size	_Z16terminal_putcharc, .-_Z16terminal_putcharc
	.align 16
	.globl	_Z20terminal_writestringPKc
	.type	_Z20terminal_writestringPKc, @function
_Z20terminal_writestringPKc:
.LFB7:
	.cfi_startproc
	push	esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	push	ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	push	esi
	.cfi_def_cfa_offset 16
	xor	eax, eax
	mov	ebx, DWORD PTR [esp+16]
	cmp	BYTE PTR [ebx], 0
	je	.L22
	.align 16
.L30:
	inc	eax
	xor	edx, edx
	mov	dl, al
	cmp	BYTE PTR [ebx+edx], 0
	jne	.L30
	test	al, al
	je	.L22
	dec	eax
	and	eax, 255
	lea	esi, [ebx+1+eax]
	.align 16
.L27:
	movsx	eax, BYTE PTR [ebx]
	inc	ebx
	mov	DWORD PTR [esp], eax
	call	_Z16terminal_putcharc
	cmp	ebx, esi
	jne	.L27
.L22:
	pop	ebx
	.cfi_def_cfa_offset 12
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE7:
	.size	_Z20terminal_writestringPKc, .-_Z20terminal_writestringPKc
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Hello, kernel World!\n"
	.text
	.align 16
	.globl	kernel_main
	.type	kernel_main, @function
kernel_main:
.LFB8:
	.cfi_startproc
	push	edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	push	esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	sub	esp, 36
	.cfi_def_cfa_offset 48
	mov	esi, OFFSET FLAT:.LC0
	call	_Z19terminal_initializev
	mov	edx, 22
	lea	eax, [esp+14]
	mov	edi, eax
	test	al, 2
	jne	.L47
.L34:
	mov	ecx, edx
	shr	ecx, 2
	and	edx, 2
	rep movsd
	je	.L36
	mov	dx, WORD PTR [esi]
	mov	WORD PTR [edi], dx
.L36:
	mov	DWORD PTR [esp], eax
	call	_Z20terminal_writestringPKc
	add	esp, 36
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	pop	edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.align 16
.L47:
	.cfi_restore_state
	mov	dx, WORD PTR .LC0
	lea	edi, [esp+16]
	mov	WORD PTR [esp+14], dx
	mov	esi, OFFSET FLAT:.LC0+2
	mov	edx, 20
	jmp	.L34
	.cfi_endproc
.LFE8:
	.size	kernel_main, .-kernel_main
	.globl	terminal_buffer
	.section	.bss
	.align 4
	.type	terminal_buffer, @object
	.size	terminal_buffer, 4
terminal_buffer:
	.zero	4
	.globl	terminal_color
	.type	terminal_color, @object
	.size	terminal_color, 1
terminal_color:
	.zero	1
	.globl	terminal_column
	.type	terminal_column, @object
	.size	terminal_column, 1
terminal_column:
	.zero	1
	.globl	terminal_row
	.type	terminal_row, @object
	.size	terminal_row, 1
terminal_row:
	.zero	1
	.ident	"GCC: (GNU) 4.8.1"
