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
- Please first check if you have mistype the value or misconnecting the wire in your design!
- Floating adders and subtracters are actually larger than floating point mult and div, also has longer CP.
- Remember to add delays to all your sequential blocks if you want to simulate your design with delays included.

## Designing pipeline processors
1. When designing pipeline design, first build a single cycle machine implementation, with controls and datapath included.
2. Analyze the possible bottleneck in your design, in this case, div.
3. Start drawing pipelined cutsets, then name the stages correctly.
4. fp_div > fp_exp > fp_3add > fp_add > fp_sub > fp_mult in terms of critical paths.

# When design is large
1. If the design is way too large, putting the design onto fpga can greatly reduce the simulation time.

# Advanced techniques in reducing area and critical path
1. The mantissa of floating point can actually be reduced due to the allowable error of 1%.
2. I.e. one can try to reduce the mantissa bits from 23 to bits less than 23. As long as you still meet the criteria.
3. Look up table can be used as long as the number of inputs are fixed, simply calculate all possible value and print it out , load the value in as LUT to allow small area fast search.

# Reducing errors
1. Do proper base case, extreme case and normal case checking with others during algorithm level.
2. Remember to check your code, see if there are some mapping errors after you first coded it out. Sometimes, bits errors,connections and overflowing errors can be easily spotted.

# Summary
1. Since an error range is allowed within spec, so we can actually adjust the mantissa of our floating point IP. This method can greatly reduce the critical path and area!
2. When deriving pipelined architecture, first derive a combinational version of your circuit, then start drawing pipeline cutset.
3. Comparing to the size of designWare IP, pipelined registers are actually cheap.
4. When working in IC LAB, do not try to rewrite the equation when using IP, otherwise some corner cases cannot pass!!!! This problem arise when I am using the exponential IP.
5. Some cycles can actually be stolen during the read data stage. Since we can start processing the image after we have enough data in the buffers.

# Steps
1. First derive a correct functional model at high level language with pipelining in mind.(For loop of one single pixel)
2. Derive the combinational version of the circuit with FSM in mind.
3. Draw the pipeline cutset for every circuit components, pipeline registers are cheap compare to IPs.
4. Implement the circuit.
5. Test until it works.
6. Due to an allowable constraint released start playing with the most significant bits of each IEEE components.
7. Critical path DIV > SUM3 > SUM > MULT > CMP
8. Note the bit width of EXP cannot be modified, DIV can be modified drastically, SUM3 however only has a 1 bit tolerance.
