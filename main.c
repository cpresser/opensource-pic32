/*
 * This is just a dummy program to test PIC32 framework.
 *
 * Its based on the work of Bruno Basseto
 * https://github.com/BrunoBasseto/
 *
 * The Hardware to run this is a pic32mx210f016b with a 
 * green led attached to RB1 and a orange led on RB0 
 * 
 */

#include <stdint.h>
#include "mx2/sfr.h"
#include "mx2/config.h"
#include "coretimer.h"

#define SYS_FREQ            (40000000L)
#define TOGGLES_PER_SEC     4
#define CORE_TICK_RATE      (SYS_FREQ/2/TOGGLES_PER_SEC)

// Configuration bits:
// - Internal 8Mhz OSC with PLL -> 40Mhz
// - JTAG enabled
DECLARE_CONFIG(0, 0x7FFFFFFF); 
DECLARE_CONFIG(1, 0xFFF4EFF9); 
DECLARE_CONFIG(2, 0xFFF9F9D9); 
DECLARE_CONFIG(3, 0xFFFFFFFF); 


void main(void)
{
   uint32_t t = 0;

   // set RB0 and RB1 as output
   TRISBCLR = 3;

   // set outputs to zero
   LATBCLR = 3;

   // Interrupt controller configured for Multi-vectored mode
   INTCONbits.MVEC = 1;

   // configure CoreTimer
   OpenCoreTimer(CORE_TICK_RATE);

   // Main-loop: Blink leds
   while(1) {
     if (IFS0bits.CTIF) {                 // wait fo the core-timer interrupt-flag
       IFS0CLR = 0x01;                    // clear interrupt flag
       UpdateCoreTimer(CORE_TICK_RATE);   // updating core timer.
       LATBINV = 2;                       // blink green the LED
       if (t++ == 3) {
         t = 0;
         LATBINV = 1;                     // blink orange the LED
       }
     }
   }
}
