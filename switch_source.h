/**
  ******************************************************************************
  *   switch_source.h
  *   Founction prototypes for the switch_source.s source code
  *                   
  ******************************************************************************
  *   Project Team Members: Albert Perlman
  *
  ******************************************************************************
  */


/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __SWITCH_S_H
#define __SWITCH_S_H

#include <stdint.h>

void DELAY_1ms(uint32_t delay_ms);
void SWITCH_INIT(void);
uint8_t SWITCH_READ(void);

#endif /* __SWITCH_S_H */
