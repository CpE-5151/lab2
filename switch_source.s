;********************************************************************************************
;       switch_source.s
;       Switch Assembly Code from experiment #1
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
;      void DELAY_1ms(uint32_t value);
;      Delays using a loop that is about 1ms long, repeated until value == 0.
;**************************************************************************************
         EXPORT DELAY_1ms 
  
DELAY_1ms
  PUSH {R14}
D_LOOP1
  TEQ R0,#0
  BEQ D_EXIT
  SUB R0,R0,#1
  LDR R1,=1310             ; Loop is about 4 cycles SUBS (3) + BNE (1)
D_LOOP2                      ; Time for one loop = 4/4,000,000 = 0.000001 sec
  SUBS R1,R1,#1            ; 1000 loops needed for 1msec 0.000001 * 1000 = 0.001 sec  
  BNE D_LOOP2              ; Mesurements determined a 25% to 30% larger value was needed.
  B D_LOOP1
D_EXIT
  POP {R14}
  BX R14

;***************************************************************************************
;      void SWITCH_INIT(void);
;      Initializes the USER pushbutton switch (active high switch)
;      (0 - not pressed, 1 - pressed)
;      PC13 set to be an input with a pull-down resistor
;**************************************************************************************
    EXPORT SWITCH_INIT
      
SWITCH_INIT
  PUSH {R14}
  LDR R0, =RCC_BASE
  LDR R1, [R0, #RCC_AHB2ENR]
  ORR R1, R1, #(RCC_AHB2ENR_GPIOCEN)      ; Enables clock for GPIOC
  STR R1, [R0, #RCC_AHB2ENR]
  ; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
  LDR R0, =GPIOC_BASE       ; Base address for GPIOC
  ; Set GPIO mode to input for PC13
  LDR R1,[R0,#GPIO_MODER]
  BIC R1, R1, #(3<<(2*13))
  STR R1,[R0,#GPIO_MODER]
  ; Enable pull-down resistor
  LDR R1,[R0,#GPIO_PUPDR]
  BIC R1, R1, #(3<<(2*13))
  ORR R1, R1, #(2<<(2*13))
  STR R1,[R0,#GPIO_PUPDR]
  POP {R14}
  BX R14
  
;***************************************************************************************
;      uint8_t SWITCH_READ(void);
;      Reads the USER pushbutton switch on PC13
;      Returns 0 if not pressed and 1 if pressed. 
;**************************************************************************************
    EXPORT SWITCH_READ
      
SWITCH_READ
  PUSH {R14}                  ; 0 - NOT PRESSED, 1 - PRESSED
    LDR R1, =GPIOC_BASE
  LDR R2, [R1, #GPIO_IDR]
  ;
  MOV R2, #0x2000 ; user-PB always pressed for remote testing
  ;
  TST R2, #(1<<13)             ; if(PC13==0)
  MOVEQ R0,#0
  BEQ SW_NP
  MOV R0,#75          ; 75ms DELAY
  BL DELAY_1ms
    LDR R1, =GPIOC_BASE
  LDR R2, [R1, #GPIO_IDR]
  ;
  MOV R2, #0x2000 ; user-PB always pressed for remote testing
  ;
  TST R2, #(1<<13)             ; if(PC13==0)
  MOVEQ R0,#0
    MOVNE R0,#1                    ; SWITCH IS PRESSED
SW_NP
  POP {R14}
  BX R14


  END