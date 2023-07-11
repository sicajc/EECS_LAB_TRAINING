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
- always get replicated multiple times.
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
