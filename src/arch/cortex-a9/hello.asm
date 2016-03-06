.global start

/* Vexpress UART register bases */

	.equ	V2M_PA_CS7,	0x10000000
	.equ	UART0,		(V2M_PA_CS7 + (9 << 12))

/*
 * ARM UART register offsets.
 * Only adding the ones we need for now.
 */	
	.equ	UARTDR,		0x000 	@ Data register
	.equ	UARTRSR,	0x004	@ Recieve status register
	.equ	UARTEXR,	0x004	@ Error clear register
	.equ	UARTFR,		0x018	@ Flag register

	.equ	UART_FR_TFF,	0x20 @ flag bit
	.section .text
	
start:	
	mov	r1, r2
	mov	r2, r4
	adr	r0, msg
	bl	puts
	b	start

msg:
	.ascii	"Hello world\0"
	
putc:	@ r1 is character to write
	ldr	r4, uart_base
clrbuf: @ load flag register, check clear
	ldr	r3, [r4, #UARTFR]
	tst	r3, #UART_FR_TFF
	bne	clrbuf
	str	r1, [r4, #UARTDR]
	bx	lr

puts: @ r0 is address of string
	push 	{fp, lr}
puts_loop:	
	ldrb	r1, [r0]
	bl	putc
	add	r0, r0, #1
	teq	r1, #0
	bne	puts_loop
	pop	{fp, lr}
	bx	lr

	
	
uart_base:
	.word	UART0
