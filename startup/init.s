
   /*
    * Reset vector.
    * Jump to startup code.
    */
   .section .reset,"ax",@progbits
   .set noreorder
   .ent _reset
_reset:
   j _startup
   nop

   .end _reset
   .globl _reset

   
   /*
    * Startup: executed on any reset and the non-maskable interrupt (NMI).
    */
   .section .startup,"ax",@progbits
   .set noreorder
   .ent _startup
_startup:
   
   /*
    * Check if it is a reset.
    */
   mfc0 $k0, $12, 0                 # STATUS register
   ext $k0, $k0, 19, 1              # NMI bit
   beqz $k0, _is_a_reset
   nop
   
   /*
    * NMI interrupt.
    * In the PIC32, this happens when the watchdog bites de CPU when in sleep mode.
    * Nothing to do, we just return to let CPU wakeup.
    */
   eret
   nop

_is_a_reset:
   /*
    * Start memory pointers.
    * They initial values are chosen by the linker (_stack, _gp).
    */
   la $sp, _stack
   la $gp, _gp

   mfc0    $t1, $12, 2    
   add     $t3, $t1, $0   
   ext     $t2, $t1, 26, 4
   ins     $t1, $t2, 6, 4 
   mtc0    $t1, $12, 2    
   ehb                    
   wrpgpr  $gp,$gp                  /* Change $gp in shadow registers as well */
   mtc0    $t3, $12, 2    

   /*
    * Clean up BSS memory.
    * All uninitialized variables will have the value zero.
    * BSS limits in memory are chosen by the linker (_fbss, _ebss).
    */
   la $t0, _fbss
   la $t1, _ebss
   b _bss_check
   nop

_bss_init:
   sw $0, 0x0($t0)
   sw $0, 0x4($t0)
   sw $0, 0x8($t0)
   sw $0, 0xc($t0)
   addu $t0, 16

_bss_check:
   bltu    $t0, $t1, _bss_init
   nop

   /*
    * Setup initialized variables in RAM memory.
    * Copy initial values from Flash (.rodata) to RAM (.data).
    * DATA limits are chosen by the linker (_fdata, _edata).
    */
   la $t0, _fimage
   la $t1, _fdata
   la $t2, _edata
   b _init_check
   nop

_init_data:
   lw $t3, ($t0)
   sw $t3, ($t1)
   addu $t0, 4
   addu $t1, 4

_init_check:
   bltu $t1, $t2, _init_data
   nop

   /*
    * Setup co-processor (CP0)
    */
   mtc0 $0, $9, 0                # COUNT register, time zero...

   li $t2, -1
   mtc0 $t2, $11, 0              # COMPARE register, just in case

   la $t1, _ebase_address
   mtc0 $t1, $15, 1              # EBASE register points to interrupt vector table

   la $t1, _vector_spacing
   li $t2, 0
   ins $t2, $t1, 5, 5
   mtc0 $t2, $12, 1              # INTCTL register specifies vectors positions

   li $t1, 0x00800000
   mtc0 $t1, $13, 0              # CAUSE register: reset everything, set IV bit to enable vectored interrupts

   li $t1, 0
   mtc0 $t1, $12, 0              # STATUS register: reset everything: BEV = 0 (enable vectored interrupts), IPL = 0 (lowest priority run mode).

   /*
    * Startup done: call main function.
    */
   and $a0, $a0, 0
   and $a1, $a1, 0
   j main
   nop   
   .end _startup
