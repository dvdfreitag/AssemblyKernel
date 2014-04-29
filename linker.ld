/* The bootloader will look at this image and start execution 
   at the symbol designated as the entry point. */

ENTRY(start)

/* Tell where the various sections of the object 
   files will be put in the final kernel image. */
   
SECTIONS
{
	/* Begin putting the sections at 1MB, a conventional 
	   place for kernels to be loaded by the bootloader. */
	
	. = 1M;
	
	/* First put the multiboot header, as it is required to be put very early 
	   in the image or the bootloader won't recognize the image format. */
	
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}
	
	/* Read-Only data */
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	}
	
	/* Read-Write data (initialized) */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}
	
	/* Read-Write data (uninitialized) */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(.COMMON)
		*(.bss)
		*(.bootstrap_stack)
	}
	
	/* The compiler may produce other sections, by default 
	   they will put them in a segment with the same name. */
}
