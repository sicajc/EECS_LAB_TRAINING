module #(parameter DATA_WIDTH = 32,
         parameter sig_width = 23,
         parameter exp_width = 8,
         parameter ieee_compliance = 1,
         parameter en_ubr_flag = 0,
         parameter inst_arch_type = 2) MAC(
           input[DATA_WIDTH-1:0] pixel0,
           input[DATA_WIDTH-1:0] pixel1,
           input[DATA_WIDTH-1:0] pixel2,
           input[DATA_WIDTH-1:0] pixel3,
           input[DATA_WIDTH-1:0] pixel4,
           input[DATA_WIDTH-1:0] pixel5,
           input[DATA_WIDTH-1:0] pixel6,
           input[DATA_WIDTH-1:0] pixel7,
           input[DATA_WIDTH-1:0] pixel8,

           input[DATA_WIDTH-1:0] kernal0,
           input[DATA_WIDTH-1:0] kernal1,
           input[DATA_WIDTH-1:0] kernal2,
           input[DATA_WIDTH-1:0] kernal3,
           input[DATA_WIDTH-1:0] kernal4,
           input[DATA_WIDTH-1:0] kernal5,
           input[DATA_WIDTH-1:0] kernal6,
           input[DATA_WIDTH-1:0] kernal7,
           input[DATA_WIDTH-1:0] kernal8,

           output reg[DATA_WIDTH-1:0] macResult_ff;

       );



genvar idx;
genvar jdx;

wire[DATA_WIDTH-1:0] pixels[0:8];
wire[DATA_WIDTH-1:0] kernals[0:8];
wire[DATA_WIDTH-1:0] mults_result[0:8];
wire[DATA_WIDTH-1:0] partial_sum[0:2];
wire[DATA_WIDTH-1:0] mac_result;

assign pixels[0] = pixel0;
assign pixels[1] = pixel1;
assign pixels[2] = pixel2;
assign pixels[3] = pixel3;
assign pixels[4] = pixel4;
assign pixels[5] = pixel5;
assign pixels[6] = pixel6;
assign pixels[7] = pixel7;
assign pixels[8] = pixel8;

assign kernals[0] = kernal0;
assign kernals[1] = kernal1;
assign kernals[2] = kernal2;
assign kernals[3] = kernal3;
assign kernals[4] = kernal4;
assign kernals[5] = kernal5;
assign kernals[6] = kernal6;
assign kernals[7] = kernal7;
assign kernals[8] = kernal8;

generate
    for(idx = 0; idx < 9 ; idx = idx+1)
    begin
        DW_fp_mult_inst #(sig_width,exp_width,ieee_compliance,en_ubr_flag)
                        u_DW_fp_mult_inst(
                            .inst_a   ( pixels[idx]         ),
                            .inst_b   ( kernals[idx]        ),
                            .inst_rnd ( 3'b000              ),
                            .z_inst   ( mults_result[idx]   ),
                            .status_inst  (   )
                        );
    end
endgenerate

// 3x 3 inputs fp adders
DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst(
                    .inst_a   ( mults_result[0]),
                    .inst_b   ( mults_result[1]),
                    .inst_c   ( mults_result[2]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[0]   ),
                    .status_inst  (   )
                );

DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst(
                    .inst_a   ( mults_result[3]),
                    .inst_b   ( mults_result[4]),
                    .inst_c   ( mults_result[5]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[1]),
                    .status_inst  (   )
                );

DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst(
                    .inst_a   ( mults_result[6]),
                    .inst_b   ( mults_result[7]),
                    .inst_c   ( mults_result[8]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[2]),
                    .status_inst  (   )
                );
// 3 input fp adders
DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst(
                    .inst_a   ( partial_sum[0]),
                    .inst_b   ( partial_sum[1]),
                    .inst_c   ( partial_sum[2]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( mac_result  ),
                    .status_inst  (   )
                );

// Ouput buffer
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        macResult_ff <= 0;
    end
    else
    begin
        macResult_ff <= mac_result;
    end
end

endmodule
