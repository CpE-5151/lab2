;********************************************************************************************
;       timer_source.s
;       Timer Assembly Code for experiment #2
;
;       Project Team Members: Roger Younger
;
;
;       Version 1.0      Mar. 5, 2020
;
;********************************************************************************************

        INCLUDE STM32L4R5xx_constants.inc


        AREA program, CODE, READONLY
		ALIGN
			
;***************************************************************************************
;      void MEASUREMENT_INIT(void);
;      Delays using a loop that is about 1ms long, repeated until value == 0.
;**************************************************************************************

		EXPORT MEASUREMENT_INIT
			
MEASUREMENT_INIT
	PUSH {R14}
	; Initialize the Timers
	NOP
	NOP
	POP {R14}
	BX R14
	
;***************************************************************************************
;      void MEASUREMENT(void);
;      Delays using a loop that is about 1ms long, repeated until value == 0.
;**************************************************************************************

		EXPORT MEASUREMENT
			
MEASUREMENT
	PUSH {R14}
	; Start the Timers
	NOP
	NOP
	; Wait for Input Capture
	NOP
	NOP
	POP {R14}
	BX R14
	
	END
		