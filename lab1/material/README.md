# Lab1
# Combinational circuit
## Profiling
- Profiling tool enables the HW analysis for a given algoritm.
- What kind of analysis and profiling tool exist?
```

```

## Checking, RTL simulation and debug
- irun and nWave are used to validate your design.


# PPA(Performance Power and Area)
## Area
- Resource sharing usage
- What kind of coding style leads to resource sharing?
```
    Code in a way that allows DC to do the resource sharing task for you. Like specify every cases in always block clearly.
    DC would helps optimization within a single always@* block, and achieve resource sharing for you. As for cross always@* optimization,
    this might not be the case? Also DC would help you automatically prune out the unnecessary bit width of your data path aru units.
```

# Default value
1. If you does not define the bit width in representation, 32-bit data is instantiated.
2. However, bit width is recommended.
3. Signed instantiation using sign representation
4. Negative value can actually be defined and instantiated.
```verilog
    wire signed [2:0] a ;
    assign a = -3'd22;
```

# Reduction
1. Nand reduction ~&
2. === Specially used in testbench,


# Case
1. case is generally simulated faster.

# Concatenation
- Here c does not needed to be only 1-bit.
```
    a = {2{c}};
```


# Simulation
1. irun genereates an fsdb file for the waveform file generation.
```
    nWave &
```
- This still enables you to insert command line.
2. We view the signal waveform using the fsdb file.

# Reloading
1. shift+L for waveform reload in nWave.

# Execution
- Uses this command under the 02 for synthesis.
- Since the work station is newer, we uses vcs instead of irun.
- Dont touch 01_run yet
```
    ./02_run_dc
```

# High level language programming in combinational block
- Style of programming in an always@* block can mimic the high level programming language? See if you can uses for loop. ww
- Since blocking assignment is in essence, high level programming, by doing so, complex logic can be coded out, let's try out.
- Programming in a high level way is possible, but the HW cost is significant, since dc would unfold the whole circuit for you.

# Reference
[1] [Bitonic sorting network for n not a power of 2](https://hwlang.de/algorithmen/sortieren/bitonic/oddn.htm)
