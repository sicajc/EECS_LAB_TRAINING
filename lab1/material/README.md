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