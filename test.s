	.file	"test.cpp"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Hello World!"
	.text
	.align 16
	.globl	kernel_main
	.type	kernel_main, @function
kernel_main:
.LFB0:
	.cfi_startproc
	xor	eax, eax
	.align 16
.L3:
	inc	eax
	xor	edx, edx
	mov	dl, al
	cmp	BYTE PTR .LC0[edx], 0
	jne	.L3
	ret
	.cfi_endproc
.LFE0:
	.size	kernel_main, .-kernel_main
	.ident	"GCC: (GNU) 4.8.1"
