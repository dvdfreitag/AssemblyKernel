typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
 
/* Hardware text mode color constants. */
enum vga_color
{
	COLOR_BLACK = 0,
	COLOR_BLUE = 1,
	COLOR_GREEN = 2,
	COLOR_CYAN = 3,
	COLOR_RED = 4,
	COLOR_MAGENTA = 5,
	COLOR_BROWN = 6,
	COLOR_LIGHT_GREY = 7,
	COLOR_DARK_GREY = 8,
	COLOR_LIGHT_BLUE = 9,
	COLOR_LIGHT_GREEN = 10,
	COLOR_LIGHT_CYAN = 11,
	COLOR_LIGHT_RED = 12,
	COLOR_LIGHT_MAGENTA = 13,
	COLOR_LIGHT_BROWN = 14,
	COLOR_WHITE = 15,
};
 
#if defined(__cplusplus)
extern "C" /* Use C linkage for kernel_main. */
#endif
void kernel_main()
{
	const char *str = "Hello World!";

	uint8_t ret = 0;
	while ( str[ret] != 0 )
		ret++;
}
