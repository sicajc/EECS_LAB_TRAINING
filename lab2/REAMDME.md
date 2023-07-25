# Sequential logic
- State exists, need mmory logic to capture the state.
- Registers exist, memory storing the past input value,

# Storing unit
- Latch and DFF
- Must prevent latch from generating.

# Combinational feedback
- Latch might get generated if such coding style is used, should be prevented at all cost.
```verilog
    always@*
    begin
        a = a + 1;
    end
```

# Debugging for unknown
- Check for the first existence of unknown signal within your design.
- Check if every registers has their reset value.
- Check if there is conditional reset, reset logic should be seperated from other logic.

# Synchronous reset
## Advantage
- Glitch filtering

# Asynchronous reset
## Advantage
- Less Area
## Dis
- Metastable reset might occurs.

# Generate for loop
- always block here gets replicated multiple times.
```verilog

    genvar i;
    generate
        for(i=0;i<n;i=i+1)
        begin
            always@*
            begin
                temp[i] = 0;
            end
        end
    endgenerate
```

# Unknown apperance
- To prevent unknown, block the input with other conditional statement.
- Trace the gate-level simulation to search for the unknown source within the circuit.

# Algorithm design
- Whenever you try to create an algorithm, first code it out using High-level language to ensure that the procedure you claimed is correct.
- After coding out and tested the baseline model, try to optimize it in terms of logic, HW efficiency. Create as many for loop as possible.
- Unfolding technique can be used for for loop too, do not forget that, in HW this can achieve great performance. Cross iteration unfolding. An example is for QR cordic, the cordic turns 4 times in a single iteration.
