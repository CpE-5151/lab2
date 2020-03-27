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

	; (1a) enable clocks
	; ______________________________________________

	LDR R0, =RCC_BASE

	; enable clock for GPIOA
	LDR R1, [R0, #RCC_AHB2ENR]
	ORR R1, R1, #(RCC_AHB2ENR_GPIOAEN)
	STR R1, [R0, #RCC_AHB2ENR]

	; enable clock for TIM3
	LDR R1, [R0, #RCC_APB1ENR1]
	ORR R1, R1, #(RCC_APB1ENR1_TIM3EN)
	STR R1, [R0, #RCC_APB1ENR1]
  ;______________________________________________


	; (1b) configure PA6 as TIM3,CH1
	;______________________________________________

	LDR R0, =GPIOA_BASE

	; set PA6 to alt-func 2 (TIM3,CH1)
	LDR R1, [R0, #GPIO_MODER]
	BIC R1, R1, #(3 << (2*6))
	ORR R1, R1, #(2 << (2*6))	; set MODE to '10' (alt-func)
	STR R1, [R0, #GPIO_MODER]

	LDR R1, [R0, #GPIO_AFRL]
	BIC R1, R1, #(15 << (4*6))
	ORR R1, R1, #(2 << (4*6))	; set AF to '10' (TIM3,CH1)
	STR R1, [R0, #GPIO_AFRL]
	
	; set PA6 to push-pull output type
	LDR R1, [R0, #GPIO_OTYPER]
	BIC R1, R1, #(1<<6)				; set OTYPE to '0' (push-pull)
	STR R1, [R0, #GPIO_OTYPER]
	
	; disable pull-up / pull-down resistors for PA6
	LDR R1, [R0, #GPIO_PUPDR]
	BIC R1, R1, #(3 << (2*6)) ; set PU-PD to '00' (disabled)
	STR R1, [R0, #GPIO_PUPDR]
	;______________________________________________


	; (1c) set TIM3,CH1 to PWM2 mode
	;______________________________________________

	LDR R0, =TIM3_BASE

	; disable pull-up / pull-down resistors for PA6
	LDR R1, [R0, #TIM_CCMR1]
	ORR R1, R1, #(7<<4)				; set mode to '111' (PWM2)
	STR R1, [R0, #TIM_CCMR1]
	;______________________________________________


	; (1d) configure TIM3,CH1 to generate 40kHz waveform at 50% duty cycle
	;______________________________________________

	; set 40kHz frequency in TIM_ARR
	; 4 (MHz) clock -> 1/4,000,000 (s) period
	; 40 (kHz) wave -> 1/40,000 (s) period
	; TIM_ARR = (wave period) / (clock period) = 100
	MOV R1, #100
	STR R1, [R0, #TIM_ARR]

	; set 50% duty cycle in TIM_CCR1
	; TIM_CCR1 = TIM_ARR / 2 = 50
	MOV R1, #50
	STR R1, [R0, #TIM_CCR1]
	;______________________________________________


	; (1e) enable and set TIM3,CH1 output to active high
	;______________________________________________

	LDR R1, [R0, #TIM_CCER]
	ORR R1, R1, #(1<<0)				; CC3E = '1' (enabled)
	BIC R1, R1, #(1<<1)				; CC3P = '0' (active high)
	STR R1, [R0, #TIM_CCER]
	;______________________________________________


	; (1f) start TIM3
	;______________________________________________

	LDR R1, [R0, #TIM_CR1]
	ORR R1, R1, #1						; CEN = '1' (counter-enabled)
	STR R1, [R0, #TIM_CR1]
	;______________________________________________


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
		