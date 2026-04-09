#include <8052.h>

#define Left_Select P1_4
#define Right_Select P1_5
#define Segment_Port P2

unsigned char counter = 75;

unsigned char __code seg_code[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};

void delay_ms(unsigned int ms)
{
    unsigned int i, j;
    for (i = 0; i < ms; i++)
        for (j = 0; j < 120; j++)
            ;
}

void int0_isr(void) __interrupt(0)
{
    counter++;
    if (counter > 99)
    {
        counter = 0;
    }
    delay_ms(750);
}

void int1_isr(void) __interrupt(2)
{
    if (counter == 0)
    {
        counter = 99;
    }
    else
    {
        counter--;
    }
    delay_ms(750);
}

void main()
{
    unsigned char tens, units;

    IT0 = 1;
    IT1 = 1;

    EX0 = 1;
    EX1 = 1;
    EA = 1;

    while (1)
    {
        tens = counter / 10;
        units = counter % 10;

        Right_Select = 1;
        Segment_Port = seg_code[tens];
        Left_Select = 0;
        delay_ms(5);
        Left_Select = 1;

        Left_Select = 1;
        Segment_Port = seg_code[units];
        Right_Select = 0;
        delay_ms(5);
        Right_Select = 1;
    }
}
