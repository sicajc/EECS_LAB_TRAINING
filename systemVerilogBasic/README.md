# Basic modeling using SystemVerilog
## Variables
```verilog
    logic a;
    logic[3:0]b;
    logic [31:0][31:0] c;


```
## Concatenation
```
{a,1'b1}


```
## Advanced usage struct
- If using struct for pipelining, all pipeline signals can be grouped together into this single type define.

```verilog
    typedef struct packed{


    } pipelined_decode_t;

    pipelined_decode_t p,p_nxt;

    always_ff @(posedge clk)begin
        p<=p_nxt;
    end
```