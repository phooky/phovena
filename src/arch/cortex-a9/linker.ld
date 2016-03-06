ENTRY(start)  /* Entry point */

SECTIONS {
    . = 0; /* Install kernel at address 0 */

    .text :
    {
        /* text segments */
        *(.text .text.*)
    }
    
    .rodata :
    {
        /* static data */
        *(.rodata .rodata.*)
    }

    .data.rel.ro :
    {
        *(.data.rel.ro.local*) *(.data.rel.ro .data.rel.ro.*) 
    }
}
