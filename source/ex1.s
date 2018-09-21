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

		// Try #1
	//	ldr r0, =a
		
	//	ldr r1, [r0]
	//	ldr r2, [r0, #4]
	//	str r2, [r1, #CMU_HFPERCLKEN0]
		
	//	ldr r1, [r0, #8]	// Load Port a base address
	//	ldr r2, [r0, #12]
	//	str r2, [r1, #GPIO_CTRL]
		
	//	ldr r2, [r0, #16]
	//	str r2, [r1, #GPIO_MODEH]
		
	//	mov r2, #255
	//	lsl r3, r2, #7
		
	//	str r3, [r1, #GPIO_DOUT]
	
	
		// Try #2
	//	ldr r0, =CMU_BASE
	//	ldr r1, =0x00002000
	//	str r1, [r0, #CMU_HFPERCLKEN0]
		
	//	ldr r0, =GPIO_PA_BASE
	//	mov r1, #2
	//	str r1, [r0, #GPIO_CTRL]
		
	//	ldr r1, =0x55555555
	//	str r1, [r0, #GPIO_MODEH]
		
	//	ldr r1, =0x0000ff00
	//	str r1, [r0, #GPIO_DOUT]
	
		
		// Try #3
	//	ldr r0, =0x400c8000
	//	ldr r1, =0b10000000000000
	//	str r1, [r0, #0x44]
		
	//	ldr r0, =0x40006000
	//	mov r1, #2
	//	str r1, [r0]
		
	//	ldr r1, =0x55555555
	//	str r1, [r0, #0x08]
		
	//	ldr r1, =0x0000ff00
	//	str r1, [r0, #0x0c]
		
		
		// Try #4
		ldr r1, =0x400c8000			// CMU base address
		ldr r0, =0b10000000000000
		str r0, [r1, #0x44]			// set 13th bit
		
		ldr r1, =0x40006000			// GPIO PORTA base address
		mov r0, #2
		str r0, [r1]				// Set drive mode
		
		ldr r0, =0x55555555
		str r0, [r1, #0x08]			// set high bits pin mode
		
		ldr r0, =0x00000000
		str r0, [r1, #0x10]			// Set pins low, to turn leds on
		

		
		
		
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
a:
		.word CMU_BASE
		.word 0x00002000 // Value to set into the previous register; Purpose: enable GPIO clock
		.word GPIO_PA_BASE
		.word 0x00000002 // set drive strength
		.word 0x55555555 // set pin modes
		

		


