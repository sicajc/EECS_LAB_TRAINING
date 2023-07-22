# Designware and pipelining
- The use of designware IP must follow the usage

## Importance
- The IP file in ppt, use the command tocall out the pdf.
- If you use Designware, you should use clean command after each simultion.
```
./09_clean_up
```

## Type
- First instantiate IP and modules.

## HW
- Floating point units are needed for the HW.
- Sigmoid activation function and floating point IPs are needed for solving the HW.

## Cycle time adjustment
- When adjusting clock cycle time, remember to adjust both 02_SYN tcl file CYCLE TIME and PATTERN CYCLETIME.

## Design
- If you want to test the clock cycle time of IP, instantiate the IP using another module, then synthesize it to test its extreme clock delay.

## Design Procedure
1. Test the algorithm correctness using python or matlab first with some simple examples that is tracable.
3. Convert the algorithm into Single cycle machine implementation.
4. Draw the block diagram of this single cycle machine implementations.
5. Seek for resource sharing opportunities.
6. Rederive the single cycle machine with resource sharing.
7. Pipeline the design.
8. Start testing.


# Notes
- Checking the size of multiplier and exponential IP is crucial for performance reduction, so that trade off can be made.
- One 32-bit Fp_mult has an area of about 44000. And with CP of around 8 ns
- One 32-bit Fp_exp has an are of about