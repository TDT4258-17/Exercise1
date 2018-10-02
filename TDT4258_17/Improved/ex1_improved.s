    .syntax unified

	.include "efm32gg.s"

	//////////////////////////////////////////////////////////////////
	//
	// Exception vector table
	// This table contains addresses for all exception handlers
	//
	//////////////////////////////////////////////////////////////////
	
    .section .vectors
	
		.long   stack_top               /* Top of Stack             */
		.long   _reset                  /* Reset Handler            */
		.long   dummy_handler           /* NMI Handler              */
	    .long   dummy_handler           /* Hard Fault Handler       */
	    .long   dummy_handler           /* MPU Fault Handler        */
	    .long   dummy_handler           /* Bus Fault Handler        */
	    .long   dummy_handler           /* Usage Fault Handler      */
	    .long   dummy_handler           /* Reserved                 */
	    .long   dummy_handler           /* Reserved                 */
	    .long   dummy_handler           /* Reserved                 */
	    .long   dummy_handler           /* Reserved                 */
	    .long   dummy_handler           /* SVCall Handler           */
	    .long   dummy_handler           /* Debug Monitor Handler    */
	    .long   dummy_handler           /* Reserved                 */
	    .long   dummy_handler           /* PendSV Handler           */
	    .long   dummy_handler           /* SysTick Handler          */

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

	//////////////////////////////////////////////////////////////////
	//
	// Reset handler
	// The CPU will start executing here after a reset
	//
	//////////////////////////////////////////////////////////////////

		.globl  _reset
		.type   _reset, %function

    	.thumb_func		// Seems not necessary
_reset:
		
		// Clock related setup
		ldr r0, =CMU_BASE
		
		ldr r1, =0x04
		str r1, [r0, #CMU_HFCORECLKDIV]		// Setting clock divider for 
		ldr r1, =0x00002000
		str r1, [r0, #CMU_HFPERCLKEN0]		// Enable GPIO peripheral clock
		
		// Setting up GPIO pins
		ldr r0, =GPIO_PA_BASE
		mov r1, #1
		str r1, [r0, #GPIO_CTRL]			// set lowstr drive strength
		
		ldr r1, =0x55555555
		str r1, [r0, #GPIO_MODEH]			// Set each pin to output
		
		ldr r2, =GPIO_PC_BASE
		ldr r1, =0x33333333
		str r1, [r2, #GPIO_MODEL]			// Set Port C pins as input
		
		mov r1, #0xff
		str r1, [r2, #GPIO_DOUT]			// Enable pullup resistors
		
		
		
		
		
		// Setting up interrupts
		ldr r2, =ISER0
		ldr r1, =0x802
		str r1, [r2]					// Enable interrupts
		
		ldr r2, =GPIO_BASE
		ldr r1, =0x22222222
		str r1, [r2, #GPIO_EXTIPSELL]	 
		
		mov r1, #0xff
		str r1, [r2, #GPIO_IEN]			// enabling interrupts on lower 8 bits
		str r1, [r2, #GPIO_EXTIFALL]	// enabling interrupts on rising ...
		str r1, [r2, #GPIO_EXTIRISE]	// ... and falling edge.
		
		ldr r3, =GPIO_BASE
		ldr r0, [r3, #GPIO_IF]
		str r0, [r3, #GPIO_IFC]			// Initially clearing interrupts
		
		ldr r3, =SCR					// Enabling sleep after interrupt
		mov r0, #6
		str r0, [r3]
		
loop:
		wfi
		b loop
	
	//////////////////////////////////////////////////////////////////
	//
	// GPIO handler
	// The CPU will jump here when there is a GPIO interrupt
	//
	//////////////////////////////////////////////////////////////////
	
        .thumb_func
gpio_handler:  
		
		// Resetting interrupt flags
		ldr r3, =GPIO_BASE
		ldr r0, [r3, #GPIO_IF]
		str r0, [r3, #GPIO_IFC]
		
		
		ldr r2, =GPIO_PC_BASE
		ldr r0, =GPIO_PA_BASE
		ldr r1, [r2, #GPIO_DIN]		// Read PortC / Buttons
		lsl r1, r1, #8
		str r1, [r0, #GPIO_DOUT]	// Set Leds
		
		bx lr						// return from interrupt
		
	//////////////////////////////////////////////////////////////////
	
        .thumb_func
dummy_handler:  
        b .  // do nothing


