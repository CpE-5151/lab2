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

  ;
  ; STEP #1: configure TIM3,CH1 to generate 40kHz signal at 50% duty cycle
  ;____________________________________________________________________________

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


  ; (1b) configure PA6 as TIM3,CH1
  ;______________________________________________

  LDR R0, =GPIOA_BASE

  ; set PA6 to alt-func 2 (TIM3,CH1)
  LDR R1, [R0, #GPIO_MODER]
  BIC R1, R1, #(3 << (2*6))
  ORR R1, R1, #(2 << (2*6)) ; set MODE = '10' (alt-func)
  STR R1, [R0, #GPIO_MODER]

  LDR R1, [R0, #GPIO_AFRL]
  BIC R1, R1, #(15 << (4*6))
  ORR R1, R1, #(2 << (4*6)) ; set AF = '10' (TIM3,CH1)
  STR R1, [R0, #GPIO_AFRL]
  
  ; set PA6 to push-pull output type
  LDR R1, [R0, #GPIO_OTYPER]
  BIC R1, R1, #(1<<6)       ; set OTYPE = '0' (push-pull)
  STR R1, [R0, #GPIO_OTYPER]
  
  ; disable pull-up / pull-down resistors for PA6
  LDR R1, [R0, #GPIO_PUPDR]
  BIC R1, R1, #(3 << (2*6)) ; set PU-PD = '00' (disabled)
  STR R1, [R0, #GPIO_PUPDR]


  ; (1c) set TIM3,CH1 to PWM2 mode
  ;______________________________________________

  LDR R0, =TIM3_BASE
  LDR R1, [R0, #TIM_CCMR1]
  ORR R1, R1, #(7<<4)       ; set mode = '111' (PWM2)
  STR R1, [R0, #TIM_CCMR1]


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


  ; (1e) enable and set TIM3,CH1 output to active high
  ;______________________________________________

  LDR R1, [R0, #TIM_CCER]
  ORR R1, R1, #(1<<0)       ; CC1E = '1' (enabled)
  BIC R1, R1, #(1<<1)       ; CC1P = '0' (active high)
  STR R1, [R0, #TIM_CCER]


  ; (1f) start TIM3
  ;______________________________________________

  LDR R1, [R0, #TIM_CR1]
  ORR R1, R1, #1            ; CEN = '1' (counter-enabled)
  STR R1, [R0, #TIM_CR1]

  ;___end STEP #1______________________________________________________________


  ;
  ; STEP #2: configure TIM4,CH3 to generate 106μs high pulse
  ;____________________________________________________________________________

  ; (2a) enable clocks
  ;______________________________________________

  LDR R0, =RCC_BASE

  ; enable clock for GPIOD
  LDR R1, [R0, #RCC_AHB2ENR]
  ORR R1, R1, #(RCC_AHB2ENR_GPIODEN)
  STR R1, [R0, #RCC_AHB2ENR]

  ; enable clock for TIM4
  LDR R1, [R0, #RCC_APB1ENR1]
  ORR R1, R1, #(RCC_APB1ENR1_TIM4EN)
  STR R1, [R0, #RCC_APB1ENR1]


  ; (2b) configure PD14 as TIM4,CH3
  ;______________________________________________

  LDR R0, =GPIOD_BASE

  ; set PD14 to alt-func 2 (TIM4,CH3)
  LDR R1, [R0, #GPIO_MODER]
  BIC R1, R1, #(3 << (2*14))
  ORR R1, R1, #(2 << (2*14))  ; set MODE = '10' (alt-func)
  STR R1, [R0, #GPIO_MODER]

  LDR R1, [R0, #GPIO_AFRH]
  BIC R1, R1, #(15 << (4*6))
  ORR R1, R1, #(2 << (4*6))   ; set AF = '10' (TIM4,CH3)
  STR R1, [R0, #GPIO_AFRH]
  
  ; set PD14 to push-pull output type
  LDR R1, [R0, #GPIO_OTYPER]
  BIC R1, R1, #(1<<14)        ; set OTYPE = '0' (push-pull)
  STR R1, [R0, #GPIO_OTYPER]
  
  ; disable pull-up / pull-down resistors for PD14
  LDR R1, [R0, #GPIO_PUPDR]
  BIC R1, R1, #(3 << (2*14))  ; set PU-PD = '00' (disabled)
  STR R1, [R0, #GPIO_PUPDR]


  ; (2c) set TIM4,CH3 to PWM2 mode
  ;______________________________________________

  LDR R0, =TIM4_BASE
  LDR R1, [R0, #TIM_CCMR2]
  ORR R1, R1, #(7<<4)       ; set mode = '111' (PWM2)
  STR R1, [R0, #TIM_CCMR2]


  ; (2d) configure TIM4,CH3 to generate 106μs high pulse
  ;______________________________________________

  ; set 106μs high pulse in TIM_ARR
  ; 106μs = (ARR - CCR3) * (1 / 4,000,000)
  ; let CCR3 = 10
  ; then ARR = 434

  ; set TIM_ARR
  MOV R1, #434
  STR R1, [R0, #TIM_ARR]

  ; set TIM_CCR3
  MOV R1, #10
  STR R1, [R0, #TIM_CCR3]


  ; (2e) enable and set TIM4,CH3 output to active high
  ;______________________________________________

  LDR R1, [R0, #TIM_CCER]
  ORR R1, R1, #(1<<8)       ; CC3E = '1' (enabled)
  BIC R1, R1, #(1<<9)       ; CC3P = '0' (active high)
  STR R1, [R0, #TIM_CCER]


  ; (2f) set TIM4 to one-pulse mode
  ;______________________________________________

  LDR R1, [R0, #TIM_CR1]
  ORR R1, R1, #(1<<3)       ; OPM = '1' (one-pulse mode)
  STR R1, [R0, #TIM_CR1]


  ; (2g) configure TIM3 to trigger TIM4
  ;______________________________________________

  LDR R1, [R0, #TIM_SMCR]

  ; set TIM4 slave mode to 'trigger'
  BIC R1, R1, #15
  ORR R1, R1, #6      ; slave mode = '0110' (trigger)

  ; set TIM4 trigger source to ITR2 (TIM3)
  BIC R1, R1, #(7<<4)
  ORR R1, R1, #(2<<4) ; trigger source = '010' (ITR2)

  STR R1, [R0, #TIM_SMCR]
  
  ;___end STEP #2______________________________________________________________


  ;
  ; STEP #4: configure TIM4 high pulse to gate the TIM3 signal output
  ;____________________________________________________________________________

  ; (4a) set TRGO output for TIM4 to CH3
  ;______________________________________________

  LDR R0, =TIM4_BASE
  LDR R1, [R0, #TIM_CR2]
  BIC R1, R1, #(7<<4)
  ORR R1, R1, #(6<<4)     ; set MMS = '110' (OC3REF as TRGO)
  STR R1, [R0, #TIM_CR2]


  ; (4b) set TIM3 output to be gated by TIM4
  ;______________________________________________

  LDR R0, =TIM3_BASE

  ; set TIM3 slave mode to gated
  LDR R1, [R0, #TIM_SMCR]
  BIC R1, R1, #15
  ORR R1, R1, #5           ; set slave mode = '0101' (gated)
  STR R1, [R0, #TIM_SMCR]

  ; set TIM3 trigger source to ITR3 (TIM4)  
  LDR R1, [R0, #TIM_SMCR]
  BIC R1, R1, #(7<<4)
  ORR R1, R1, #(3<<4)       ; set trigger source = '011' (ITR3)
  STR R1, [R0, #TIM_SMCR]
  
  ;___end STEP #4______________________________________________________________


  ;
  ; STEP #5: configure TIM5,CH4 to generate 1ms active low pulse
  ;____________________________________________________________________________

  ; (5a) enable clocks
  ;______________________________________________

  LDR R0, =RCC_BASE

  ; enable clock for GPIOA
  LDR R1, [R0, #RCC_AHB2ENR]
  ORR R1, R1, #(RCC_AHB2ENR_GPIOAEN)
  STR R1, [R0, #RCC_AHB2ENR]

  ; enable clock for TIM5
  LDR R1, [R0, #RCC_APB1ENR1]
  ORR R1, R1, #(RCC_APB1ENR1_TIM5EN)
  STR R1, [R0, #RCC_APB1ENR1]


  ; (5b) configure PA3 as TIM5,CH4
  ;______________________________________________

  LDR R0, =GPIOA_BASE

  ; set PA3 to alt-func 2 (TIM5,CH4)
  LDR R1, [R0, #GPIO_MODER]
  BIC R1, R1, #(3 << (2*3))
  ORR R1, R1, #(2 << (2*3))  ; set MODE = '10' (alt-func)
  STR R1, [R0, #GPIO_MODER]

  LDR R1, [R0, #GPIO_AFRL]
  BIC R1, R1, #(15 << (4*3))
  ORR R1, R1, #(2 << (4*3))   ; set AF = '10' (TIM5,CH4)
  STR R1, [R0, #GPIO_AFRL]
  
  ; set PA3 to push-pull output type
  LDR R1, [R0, #GPIO_OTYPER]
  BIC R1, R1, #(1<<3)         ; set OTYPE = '0' (push-pull)
  STR R1, [R0, #GPIO_OTYPER]
  
  ; disable pull-up / pull-down resistors for PA3
  LDR R1, [R0, #GPIO_PUPDR]
  BIC R1, R1, #(3 << (2*3))   ; set PU-PD = '00' (disabled)
  STR R1, [R0, #GPIO_PUPDR]


  ; (5c) set TIM5,CH4 to PWM2 mode
  ;______________________________________________

  LDR R0, =TIM5_BASE
  LDR R1, [R0, #TIM_CCMR2]
  ORR R1, R1, #(7<<12)       ; set mode = '111' (PWM2)
  STR R1, [R0, #TIM_CCMR2]


  ; (5d) configure TIM5,CH4 to generate 1ms pulse
  ;______________________________________________

  ; set 1ms high pulse in TIM_ARR
  ; 1ms = (ARR - CCR4) * (1 / 4,000,000)
  ; let CCR4 = 10
  ; then ARR = 4,010

  ; set TIM_ARR
  MOV R1, #4010
  STR R1, [R0, #TIM_ARR]

  ; set TIM_CCR4
  MOV R1, #10
  STR R1, [R0, #TIM_CCR4]


  ; (5e) enable and set TIM5,CH4 output to active low
  ;______________________________________________

  LDR R1, [R0, #TIM_CCER]
  ORR R1, R1, #(1<<12)       ; CC4E = '1' (enabled)
  ORR R1, R1, #(1<<13)       ; CC4P = '1' (active low)
  STR R1, [R0, #TIM_CCER]


  ; (5f) set TIM5 to one-pulse mode
  ;______________________________________________

  LDR R1, [R0, #TIM_CR1]
  ORR R1, R1, #(1<<3)       ; OPM = '1' (one-pulse mode)
  STR R1, [R0, #TIM_CR1]


  ; (5g) configure TIM3 to trigger TIM5
  ;______________________________________________

  LDR R1, [R0, #TIM_SMCR]

  ; set TIM5 slave mode to 'trigger'
  BIC R1, R1, #15
  ORR R1, R1, #6      ; slave mode = '0110' (trigger)

  ; set TIM5 trigger source to ITR1 (TIM3)
  BIC R1, R1, #(7<<4)
  ORR R1, R1, #(1<<4) ; trigger source = '001' (ITR2)

  STR R1, [R0, #TIM_SMCR]

  ; set TRGO for TIM5 to CH3
  LDR R1, [R0, #TIM_CR2]
  BIC R1, R1, #(7<<4)
  ORR R1, R1, #(6<<4)     ; set MMS = '110' (OC3REF as TRGO)
  STR R1, [R0, #TIM_CR2]

  ;___end STEP #5______________________________________________________________


  POP {R14}
  BX R14
  
;***************************************************************************************
;      void MEASUREMENT(void);
;      Delays using a loop that is about 1ms long, repeated until value == 0.
;**************************************************************************************

    EXPORT MEASUREMENT
      
MEASUREMENT
  PUSH {R14}

  ; STEP #3: reset TIM5, TIM4, and TIM3 when user-PB is pressed
  ;____________________________________________________________________________
  MOV R1, #1
  LDR R0, =TIM5_BASE
  STR R1, [R0, #TIM_EGR]  ; reset TIM5
  LDR R0, =TIM4_BASE
  STR R1, [R0, #TIM_EGR]  ; reset TIM4
  LDR R0, =TIM3_BASE
  STR R1, [R0, #TIM_EGR]  ; reset TIM3

  ; Wait for Input Capture
  NOP
  NOP

  POP {R14}
  BX R14
  
  END
    