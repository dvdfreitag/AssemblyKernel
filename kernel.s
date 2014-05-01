	.intel_syntax noprefix

// Declare constants for creating a multiboot compliant header
MBALIGN		= 1 << 0				// Align loaded modules on page boundaries
MEMINFO		= 1 << 1				// Provide memory map
FLAGS		= MBALIGN | MEMINFO		// Multiboot 'flag' field
MAGIC		= 0x1BADB002			// Multiboot 'magic' number
CHECKSUM	= -(MAGIC + FLAGS)		// Checksum for multiboot compliance

// Declare a header as in the Multiboot Standard. This gets put into
// its own section so we can force the header to be in the start of
// the final program in the link process. The Multiboot compliant 
// bootloader (GRUB) will search for these values.
.section .multiboot	// Define special multiboot section
.align 4			// Enforce the alignment of this section to 4 bytes
	.int MAGIC	// Initialize magic number using 'MAGIC' symbolic constant
	.int FLAGS	// Initialize flags using 'FLAGS' symbolic constant
	.int CHECKSUM	// Initialize checksum using 'CHECKSUM' symbolic constant
	
// Currently the stack pointer register (esp) points at something that is
// unknown. Using it at this point could cause massive harm. To start we
// are going to create a symbol just before we initialize our new stack,
// this symbol will contain the address of the base of the stack. Next,
// we will allocate our stack, then finally we will create another symbol
// at the end of the stack that will point to the last memory location
// on the stack.
	.section .bootstrap_stack	// Define a new section for our stack
	.align 4					// Enforce the alignment of this section to 4 bytes
	.globl stack_bottom
	.type stack_bottom, @object	
stack_bottom:					// Define a symbol at the beginning of the stack
	.rept						// Initialize 16KB of memory to 0
	.byte 0
	.endr
stack_top:						// Define a symbol at the top of the stack

	.text
	.align 16
	.globl Terminal
	.type Terminal, @object
Terminal: .int 0xB8000

	.globl TerminalColor
	.type TerminalColor, @object
TerminalColor: .word 0

	.globl TerminalPosition
	.type TerminalPosition, @object
TerminalPosition: .word 0	

// Terminal color symbolic constants
TERMINAL_BLACK 			= 0x00
TERMINAL_BLUE  			= 0x01
TERMINAL_GREEN 			= 0x02
TERMINAL_CYAN 			= 0x03
TERMINAL_RED 			= 0x04
TERMINAL_MAGENTA 		= 0x05
TERMINAL_BROWN 			= 0x06
TERMINAL_LIGHT_GREY 	= 0x07
TERMINAL_DARK_GREY 		= 0x08
TERMINAL_LIGHT_BLUE 	= 0x09
TERMINAL_LIGHT_GREEN 	= 0x0A
TERMINAL_LIGHT_CYAN 	= 0x0B
TERMINAL_LIGHT_RED 		= 0x0C
TERMINAL_LIGHT_MAGENTA 	= 0x0D
TERMINAL_LIGHT_BROWN 	= 0x0E
TERMINAL_LIGHT_WHITE 	= 0x0F

// Clobbers: edx
// byte TerminalColor(byte foreground, byte background)
// Returns: Terminal Color in al
	.align 16
	.globl TerminalMakeColor
	.type  TerminalMakeColor, @function
TerminalMakeColor:
	.cfi_startproc
	push ebp
	mov ebp, esp
	
	mov al, byte ptr [ebp+8]		// background
	mov edx, dword ptr [ebp+4]		// foreground
	sal eax, 4
	or eax, edx
	
	mov esp, ebp
	pop ebp
	ret
	.cfi_endproc

// Clobbers: edx
// word MakeVGAEntry(char letter, byte color)
// Returns: VGA entry in ax
	.align 16
	.globl MakeVGAEntry
	.type MakeVGAEntry, @function
MakeVGAEntry:
	.cfi_startproc
	push ebp
	mov ebp, esp
	
	mov al, byte ptr [ebp+8]			// color
	movsx edx, byte ptr [ebp+4]		// letter
	sal eax, 8						// color << 8
	or eax, edx						// color | letter
	
	mov esp, ebp
	pop ebp
	ret
	.cfi_endproc
	
// Clobers:
// byte strlen(const char* string)
// Returns: Length of string
	.align 16
	.globl strlen
	.type strlen, @function
strlen:
	.cfi_startproc
	push ebp
	mov ebp, esp
	
	mov ecx, dword ptr [ebp+4]		// string pointer
	xor eax, eax					// emty array offset
	cmp byte ptr [ecx], 0			// null check
	je .L2
.L1:
	inc eax							// increment array offset
	xor edx, edx					// clear temporary array offset
	mov dl, al						// move array offset into temporary
	cmp byte ptr [ecx+edx], 0		// check for end of string
	jne .L1
.L2:
	mov esp, ebp
	pop ebp
	ret	
	.cfi_endproc
