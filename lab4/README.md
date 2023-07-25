# Testbench and design
## Basics
- CLOCK GEN
- RESET
- INIT
- SEND STIMULUS & MAIN FLOW
- CHECK RESPONSE
    - NO RESET OUTPUTS
    - WRONG ANSWER
- REPEAT CHECKING

# Best one for complex design
## Algorithm
- Usually create a model using C,Matlab or python. Then we can generate input test vectors and golden outputs.

# Checking
- Note usually we check the answer at NEGEDGE CLK!
```verilog
@(negedge clk)
    // Statement

```

# TB coding
- Initial block
- Delay for n units of time
- Full high-level constructs
- I/O file

# Test Pattern & Test Vectors
## Example
- In verilog, _ would be ignored, 000 is input test vector, 1 is golden output
```
    000_1
    001_0

```
## Reading test vectors
- Reading test vectors into your pseudo RAM in your design.
```
$readmemb("example.tv",testbectors);

```

## Jump Over reset
- We first jump over the first reset! Since reset should not be counted!
```verilog
    if(~rst_n)
    begin


    end
```

## Initial blocks
- Initial blocks all start at same time and can be used simultaneously. #0.Statements S1 and S2 both initiates at time instance 0.

```verilog
initial
begin
    S1
end

initial
begin
    S2
end

```

## task
- Must be written within module, NOT SYNTHESIZABLE!!

## Function
- Pack common COMBINATIONAL OPERATION into 1, which is synthesizable!


## Writing testbench recommended book
- Writing testbench


# Bus functional model
## Input
- READ()
- WRITE()
- DATA
- VALID

## Output
- ADDR
- RW
- ALE

## TB coding
- wait, stucks in timing, until the condition is met.


## Pros
- By using this Bus functional model, testbench becomes a lot cleaner and more readable!
- Testbench task, can access global variables!


## CLK should not be input of task!


# FILE I/O
- Important driver code template
```verilog
initial begin
    repeat(10) @ (posedge clk);
    while (!feof(in))
    begin
        @(negedge clk);
        statusI = $fscanf(in,$h $h\n),din[31:16],din[15:0]);
    end

```
- fwrite does not insert a newline at each write, must insert it by yourself.


# Writing into pseudoRAM
## readmemh
- Reads a single line of data from memory file.


## writememh
- Immediately writes all memory info declared within module to file.
- The  @ 55 specify when writing file into dram, it starts writing value into address 55 of the pseudoDRAM declared within your testbench.

![memory](./memory_reading.png)