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
		ldr r0, =a
		
		ldr r1, [r0]
		ldr r2, [r0, #4]
		str r2, [r1, #CMU_HFPERCLKEN0]
		
		ldr r1, [r0, #8]
		ldr r2, [r0, #12]
		str r2, [r1, #GPIO_CTRL]
		
		str r1, [r0]
		
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
		.word GPIO_PA_BASE
		.word 12
		

		


