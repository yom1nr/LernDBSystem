
#include <reg52.h>
#include <stdio.h>

sbit LED_0 = P3 ^ 6;
sbit LED_1 = P3 ^ 7;
sbit CS_Seg0 = P1 ^ 4;
sbit CS_Seg1 = P1 ^ 5;
#define PortO_DispData P0
unsigned int Count, Counter = 0;
char myString[80];
code unsigned char CodeSeg[] =
{ 0x77, 0x11, 0x6D, 0x5D, 0x1B, 0x5E, 0x7E, 0x15,
  0x7F, 0x5F, 0x3F, 0x7A, 0x66, 0x79, 0x6E, 0x2E
};

//===============================================
void Delay(unsigned char msec)
{ unsigned char i, j;
  while (msec)
  { for (i = 1; i <= 250; i++) //not :
      for (j = 1; j <= 113; j++); //with ;
    msec--;
  }
}

//===============================================
void Timer0_ISR(void) interrupt 1
{ unsigned char Temp;
  if (Count % 2 == 0) {
    Temp = Counter & 0x0f;
    CS_Seg0 = 1;
    CS_Seg1 = 0;
  }
  else {
    Temp = (Counter >> 4) & 0x0f;
    CS_Seg0 = 0;
    CS_Seg1 = 1;
  }
  PortO_DispData = ~CodeSeg[Temp];
  Count++;
}

void uart_tx(unsigned char serialdata){
  SBUF = serialdata; //Load Data to Serial Buffer Register
  while (TI == 0); //Wait Until Transmission To Complete
  TI = 0; //Clear Transmission Interrupt Flag
}


void uart_msg(unsigned char * c){
  while ( * c != 0)  {
    uart_tx( * c++);
  }
}

//===============================================
main()
{ TMOD = 0x22;  // Time1Mode2 Timer0Mode1
    
  TH1=0xFB;
  SCON =0x50;
  TR1=1;
    
  TH0 = 0;
  TR0 = 1;
  ET0 = 1; // Enable External 0 Interrupt
  EA = 1;  // Global Interrupt Enable
  while (1)
  { Delay(50);
    Counter++;
    sprintf(myString, "\nData Counter = %d", Counter);
    uart_msg(myString);
    LED_0 = (Counter + 1) % 2;
    LED_1 = Counter % 2;
  }
}



