void __attribute__((nomips16)) OpenCoreTimer(unsigned int period)
{
    // clear the count reg
    asm volatile("mtc0   $0,$9");
    // set up the period in the compare reg
    asm volatile("mtc0   %0,$11" : "+r"(period));
}

void __attribute__((nomips16)) UpdateCoreTimer(unsigned int period)
{
    unsigned int old_period;

    // get the old compare time
    asm volatile("mfc0   %0, $11" : "=r"(old_period));
    period += old_period;
    // set up the period in the compare reg
    asm volatile("mtc0   %0,$11" : "+r"(period));
}

