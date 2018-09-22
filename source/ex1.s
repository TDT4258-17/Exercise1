    .syntax unified

	.include "efm32gg.s"

	/////////////////////////////////////////////////////////////////////////////
	//
	// Exception vector table
	// This table contains addresses for all exception handlers
	//
	/////////////////////////////////////////////////////////////////////////////
	
    .section .vectors
	
		.long   stack_top               /* Top of Stack                 */
		.long   _reset                  /* Reset Handler                */
		.long   dummy_handler           /* NMI Handler                  */
	    .long   dummy_handler           /* Hard Fault Handler           */
	    .long   dummy_handler           /* MPU Fault Handler            */
	    .long   dummy_handler           /* Bus Fault Handler            */
	    .long   dummy_handler           /* Usage Fault Handler          */
	    .long   dummy_handler           /* Reserved                     */
	    .long   dummy_handler           /* Reserved                     */
	    .long   dummy_handler           /* Reserved                     */
	    .long   dummy_handler           /* Reserved                     */
	    .long   dummy_handler           /* SVCall Handler               */
	    .long   dummy_handler           /* Debug Monitor Handler        */
	    .long   dummy_handler           /* Reserved                     */
	    .long   dummy_handler           /* PendSV Handler               */
	    .long   dummy_handler           /* SysTick Handler              */

	/* External Interrupts */
		.long   dummy_handler
		.long   gpio_handler            /* GPIO even handler */
		.long   dummy_handler
		.long   dummy_handler
		.long   dummy_handler
		.long   dummy_handler
		.long   dummy_handler
		.long   dummy_handler
		.long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   gpio_handler            /* GPIO odd handler */
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler
	    .long   dummy_handler

	.section .text

	/////////////////////////////////////////////////////////////////////////////
	//
	// Reset handler
	// The CPU will start executing here after a reset
	//
	/////////////////////////////////////////////////////////////////////////////

		.globl  _reset
		.type   _reset, %function

    	.thumb_func
_reset:

		// Try #1 - Doesnt work
	//	ldr r0, =vars
		
	//	ldr r1, [r0]
	//	ldr r2, [r0, #4]
	//	str r2, [r1, #CMU_HFPERCLKEN0]
		
	//	ldr r1, [r0, #8]	// Load Port a base address
	//	ldr r2, [r0, #12]
	//	str r2, [r1, #GPIO_CTRL]
		
	//	ldr r2, [r0, #16]
	//	str r2, [r1, #GPIO_MODEH]
	
	//	mov r2, #0xf0
	//	lsl r3, r2, #7
	
	//	str r3, [r1, #GPIO_DOUT]
	
	
		// Try #2
		ldr r0, =CMU_BASE
		ldr r1, =0x00002000
		str r1, [r0, #CMU_HFPERCLKEN0]	// Enable GPIO peripheral clock
		
		ldr r0, =GPIO_PA_BASE
		mov r1, #1
		str r1, [r0, #GPIO_CTRL]	// set lowstr drive strength
		
		ldr r1, =0x55555555
		str r1, [r0, #GPIO_MODEH]	// Set each pin to output
		
		ldr r2, =GPIO_PC_BASE
		ldr r1, =0x33333333
		str r1, [r2, #GPIO_MODEL]	// Set Port C pins as input
		
		mov r1, #0xff
		str r1, [r2, #GPIO_DOUT]	// Enable pullup resistors

loop:		
		
		ldr r1, [r2, #GPIO_DIN]		// Read PortC / Buttons
		lsl r1, r1, #8
		str r1, [r0, #GPIO_DOUT]	// Set Leds
		
		b loop
		
		
	    b .  // do nothing
	
	/////////////////////////////////////////////////////////////////////////////
	//
	// GPIO handler
	// The CPU will jump here when there is a GPIO interrupt
	//
	/////////////////////////////////////////////////////////////////////////////
	
        .thumb_func
gpio_handler:  

	    b .  // do nothing
	
	/////////////////////////////////////////////////////////////////////////////
	
        .thumb_func
dummy_handler:  
        b .  // do nothing


.section .data
vars:
		.long CMU_BASE
		.long 0x00002000 // Value to set to CMU_BASE; Purpose: enable GPIO clock
		.long GPIO_PA_BASE
		.long 0x00000002 // set drive strength
		.long 0x55555555 // set pin modes
		.long 255

		


