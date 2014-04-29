%macro invoke 1-*		; Define invoke macro
	%if %0 > 1			; If the amount of arguments is greter than 1
		%rep %0 - 1		; Repeat until argument count - 1
		%rotate -1		; Rotate arguments backwards
			push %1		; Push arguments onto the stack last to second
		%endrep			; End the repeat loop
		%rotate -1		; Rotate from the second argument to the first
		call %1			; Call the first argument
		add esp, (%0 - 1) * 4	; Upon a ret adjust the stack 4 bytes per argument
	%elif %0 == 1		; If there is 1 agument
		call %1			; Just call it
	%else				; Otherwise error
		%error Not enough arguments provided to invoke
	%endif				; End conditional
%endmacro				; End Macro

; Declare constants for creating a multiboot compliant header
MBALIGN		equ	1 << 0				; Align loaded modules on page boundaries
MEMINFO		equ 1 << 1				; Provide memory map
FLAGS		equ MBALIGN | MEMINFO	; Multiboot 'flag' field
MAGIC		equ 0x1BADB002			; Multiboot 'magic' number
CHECKSUM	equ -(MAGIC + FLAGS)	; Checksum for multiboot compliance

; Declare a header as in the Multiboot Standard. This gets put into
; its own section so we can force the header to be in the start of
; the final program in the link process. The Multiboot compliant 
; bootloader (GRUB) will search for these values.
section .multiboot	; Define special multiboot section
align 4				; Enforce the alignment of this section to 4 bytes
	dd MAGIC		; Initialize magic number using 'MAGIC' symbolic constant
	dd FLAGS		; Initialize flags using 'FLAGS' symbolic constant
	dd CHECKSUM		; Initialize checksum using 'CHECKSUM' symbolic constant
	
; Currently the stack pointer register (esp) points at something that is
; unknown. Using it at this point could cause massive harm. To start we
; are going to create a symbol just before we initialize our new stack,
; this symbol will contain the address of the base of the stack. Next,
; we will allocate our stack, then finally we will create another symbol
; at the end of the stack that will point to the last memory location
; on the stack.
section .bootstrap_stack	; Define a new section for our stack
align 4						; Enforce the alignment of this section to 4 bytes
stack_bottom:				; Define a symbol at the beginning of the stack
times 16384 db 0			; Initialize 16KB of memory to 0
stack_top:	db 0			; Define a symbol at the top of the stack

section .data
terminal_buffer:	dd 0
terminal_color:		dw 0
terminal_position:	dw 0
hello_world: db "Hello World!"

; The linker script specifies _start as the entry point to the kernel
; and the bootloader (GRUB) will jump to this position once the kernel
; has been loaded. It doesn't make sense to return from this function
; Since the bootloader effectively dissapears once it loads the kernel.
section .text
global start
start:
	; Setup our stack by setting the ebp register to point at the symbol
	; we created so that esp containes a pointer to the beginning of
	; the stack. Remember that the stack grows from high memory to low
	; memory. Also, set the esp register to the beginning of the stack.
	mov ebp, stack_top
	mov esp, stack_top
	
	; Reserve space for 4 bytes. Remember the CPU expects that the
	; stack is aligned to 4 bytes regardless of whether anything
	; is stored in the allocated bytes.
	sub esp, 4
	
	; Move pointer to beginning of VGA memory into terminal_buffer
	mov dword [terminal_buffer], 0xB8000	
	; Set the terminal background
	invoke set_background, 0x0F
	; Set the whole screen to the previously set color
	call fill_color	
	; Set the terminal foreground
	invoke set_forground, 0x04
	; Print 'H' to the screen
	;invoke print_char, 'H'
	lea eax, [hello_world]
	invoke print_string, eax, 0x0C

	; Put the CPU into an infinite loop, remember we can't return from here.
	; Use the cli instruction to disable interrupts
	cli
.hang:
	; The halt ('hlt') instruction will stop the CPU until the next
	; instruction arrives. In case the CPU continues we jump and halt
	; again just to be sure.
	hlt
	jmp .hang

; Mangles eax, and edx
; This function uses the terminal_position global to set the location
; of the cursor
move_cursor:	; PROTO(VOID) : WORD reserved, BYTE column, BYTE row
	; Enter new stack frame
	push ebp
	mov ebp, esp	
	
	; Cursor LOW port to vga INDEX register. This tells the VGA 
	; hardware that the next byte written to the VGA data register 
	; (0x03D5) is for the cursor location low byte.
	mov al, 0x0F						; Move VGA Cursor Low index offset into al
	mov dx, 0x03D4						; Move VGA port 0x03D4 (index register) into dx
	out dx, al							; Write al to dx. 
	
	mov ax, word [terminal_position]	; Restore position back to ax
	mov dx, 0x03D5						; Move VGA port 0x03D5 (data register) into dx
	out dx, al							; Write al to dx

	; Cursor HIGH port to vga INDEX register. This tells the VGA
	; hardware that the next byte wrottem tp tje VGA data register
	; (0x03D5) is for the cursor location high byte.
	mov al, 0x0E						; Move VGA Cursor Low index offset into al
	mov dx, 0x03D4						; Move VGA port 0x03D4 (index register) into dx
	out dx, al							; Write al to dx
	
	mov ax, word [terminal_position]	; Restore position back to ax
	shr ax, 8							; Get the position high byte
	mov dx, 0x03D5						; Move VGA port 0x03D5 (data register) into dx
	out dx, al							; Write al to dx

	; Restore old stack frame and return
	mov esp, ebp
	pop ebp
	ret	

; Mangles eax, ebx, and ecx
; This function fills the screen with the color terminal_color. 
fill_color:		; PROTO(VOID) : VOID
	push ebp
	mov ebp, esp

	; Store terminal buffer for later
	mov eax, dword [terminal_buffer]
	; Store terminal color for later
	mov bx, word [terminal_color]
	; Store loop counter
	mov cx, 0

.begin:
	; Write the color data to the current position
	mov word [eax], bx
	; Increment our counter
	inc cx
	lea eax, [eax+2]
	; If our counter is equal to 80 * 25 (the end of VGA)
	cmp cx, 0x07D0
	; Loop around
	jne .begin
	; Otherwise exit
	
	mov esp, ebp
	pop ebp
	ret	

; Mangles eax
; This function takes one argument. It sets bits 8-11 in the terminal_color 
; corresponding to the foreground color. Returns nothing.
set_forground:	; PROC(VOID) : BYTE foreground
	push ebp
	mov ebp, esp

	mov eax, dword [ebp+8]				; Load the foreground color from the stack
	and ax, 0x000F						; Clear all but the first four bits
	shl ax, 0x08						; Shift the color into bits 8-11
	
	and word [terminal_color], 0xF000	; Clear the current foreground color
	or word [terminal_color], ax		; Set the new foreground color
	
	mov esp, ebp
	pop ebp
	ret 

; Mangles eax
; This function takes one argument. It sets bits 12-15 in the terminal_color
; corresponsing to the background color. Returns nothing.
set_background:	; PROC(VOID) : BYTE background
	push ebp
	mov ebp, esp
	
	mov eax, dword [ebp+8]				; Load the background color from the stack
	and ax, 0x000F						; Clear all but the first four bits
	shl ax, 0x0C						; Shift the color into bits 12-15
	
	and word [terminal_color], 0x0F00	; Clear the current background color
	or word [terminal_color], ax		; Set the new background color
	
	mov esp, ebp
	pop ebp
	ret
	
; Mangles eax, ecx, and edx
; This function takes one argument. It writes a character provided from the stack
; into the current terminal position. This function automatically increments
; the terminal position and moves the cursor accordingly.
print_char:		; PROTO(VOID) : BYTE character
	push ebp
	mov ebp, esp
	
	mov eax, dword [ebp+8]				; Grab the character to print from the stack
	or ax, word [terminal_color]		; Set the color bits
	mov ecx, dword [terminal_buffer]	; Grab a pointer to the base of VGA memory
	mov dx, word [terminal_position]	; Grab the current cursor location
	lea ecx, [ecx+edx*2]				; Offset the pointer to the current location
	mov word [ecx], ax					; Print the character to the screen
	inc word [terminal_position]		; Increment the terminal_position
	invoke move_cursor					; Update the cursor
	
	mov esp, ebp
	pop ebp
	ret

print_string:
	push ebp
	mov ebp, esp
	
	mov eax, dword [ebp+8]
	and byte [eax], 0xFF
	xor ecx, ecx
	mov edx, dword [ebp+12]
.begin:
	pushad
	invoke print_char, dword [eax]
	popad
	inc ecx
	lea eax, [eax+ecx]
	and byte [eax], 0xFF
	cmp ecx, edx
	jb .begin
	
	mov esp, ebp
	pop ebp
	ret	
