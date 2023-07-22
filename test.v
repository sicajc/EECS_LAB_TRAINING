module universal_counter (clear, mode, incr, enable, clk, count) ;
input clear; /* if clear = 1, count[3:0] is reset at the positive edge of the clock*/
input mode; /* hexadecimal cpounting if mode = 1, decimal counting if otherwise */
input incr; /* up counting if incr = 1, down counting if incr = 0 */
input enable; /* counter counts when enable = 1 */
input clk;
output [3:0] count; /* counter output */
/* priority of control signals: clear > enable */
reg [3:0] count;
always @(posedge clk)
begin
    if(clear)
    begin
        count <= 4'b0;
    end
    else
    begin
        if(enable)
        begin
            if(incr) //up
            begin
                if(mode) //16
                begin
                    if(count==4'hf)
                        count<=4'h0;
                    else
                        count<=count+4'h1;
                end
                else //10
                begin
                    if(count==4'd9)
                        count<=4'd0;
                    else
                        count<=count+4'd1;
                end
            end
            else //down
            begin
                if(mode) //16
                begin
                    if(count==4'h0)
                        count<=4'hf;
                    else
                        count<=count-4'h1;
                end
                else //10
                begin
                    if(count==4'd0)
                        count<=4'd9;
                    else
                        count<=count-4'd1;
                end
            end
        end
        else
            count<=count;
    end
end
endmodule
