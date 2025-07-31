MEMORY
{
    flash (rx) : ORIGIN = 0x08000000, LENGTH = 128K /* FLASH area */
    ram (xrw):   ORIGIN = 0x20000000, LENGTH = 8K /* RAM area */
}

EXTERN (vector_table)

ENTRY(reset_handler)

SECTIONS
{
    .text : /* collect all code related sections */
    {
        . = ALIGN(4);
		*(.vectors)	/* Vector table */
        *(.text) /* all .text sections (code) */
        *(.rodata) /* all .rodata sections (constants,…) */
        _etext = .; /* define a global symbol _etext */
        _exit = .;
    } >flash /* put all the above into flash */

    .data : /* all .data sections to RAM */
    {
        . = ALIGN(4);
        _data = .; /* symbol marking the .data start */
        *(.data) /* all .data sections */
        _edata = .; /* symbol marking the .data end */
    } >ram AT >flash /* .data will reside in RAM, but it is
    stored in the flash */

    .bss : /* .bss sections to RAM */
    {
        . = ALIGN(4);
        _bss_start = .; /*.bss section start*/
        *(.bss) /* all .bss sections */
        _bss_end = . ; /* .bss end symbol */
    } >ram /* put all the above in RAM */

}

