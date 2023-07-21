module NN(
	// Input signals
	clk,
	rst_n,
	in_valid_i,
	in_valid_k,
	in_valid_o,
	Image1,
	Image2,
	Image3,
	Kernel1,
	Kernel2,
	Kernel3,
	Opt,
	// Output signals
	out_valid,
	out
);
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
// IEEE floating point paramenters
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 1;
parameter inst_arch = 2;

// DATAWIDTH OF DATAPATH
parameter DATA_WIDTH = 32;
parameter PADDED_IMAGE_WIDTH = 6;
parameter KERNAL_WIDTH = 3;
parameter IMAGE_WIDTH = inst_sig_width+inst_exp_width + 1;

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input  clk, rst_n, in_valid_i, in_valid_k, in_valid_o;
input [inst_sig_width+inst_exp_width:0] Image1, Image2, Image3;
input [inst_sig_width+inst_exp_width:0] Kernel1, Kernel2, Kernel3;
input [1:0] Opt;
output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

//---------------------------------------------------------------------
//   Registers
//---------------------------------------------------------------------
reg[DATA_WIDTH-1:0] padded_img1[0:PADDED_IMAGE_WIDTH-1][0:PADDED_IMAGE_WIDTH-1];
reg[DATA_WIDTH-1:0] padded_img2[0:PADDED_IMAGE_WIDTH-1][0:PADDED_IMAGE_WIDTH-1];
reg[DATA_WIDTH-1:0] padded_img3[0:PADDED_IMAGE_WIDTH-1][0:PADDED_IMAGE_WIDTH-1];

reg[DATA_WIDTH-1:0] kernal1[0:3][0:KERNAL_WIDTH-1][KERNAL_WIDTH-1];
reg[DATA_WIDTH-1:0] kernal2[0:3][0:KERNAL_WIDTH-1][KERNAL_WIDTH-1];
reg[DATA_WIDTH-1:0] kernal3[0:3][0:KERNAL_WIDTH-1][KERNAL_WIDTH-1];

reg[DATA_WIDTH-1:0] shuffled_img[0:IMAGE_WIDTH*2-1][0:IMAGE_WIDTH*2-1];

// row ptrs
reg[3:0] row_ptr;

reg[3:0] row_ptr_mac1_mac2_pipe;
reg[3:0] row_ptr_mac2_pixelSumACT0_pipe;
reg[3:0] row_ptr_pixelSumACT0_expACT1_pipe;
reg[3:0] row_ptr_expACT1_wbDivACT2_pipe;

// Column ptrs
reg[3:0] col_ptr;

reg[3:0] col_ptr_mac1_mac2_pipe;
reg[3:0] col_ptr_mac2_pixelSumACT0_pipe;
reg[3:0] col_ptr_pixelSumACT0_expACT1_pipe;
reg[3:0] col_ptr_expACT1_wbDivACT2_pipe;

// KernalNums
reg[2:0] kernalNum_cnt;

reg[1:0] kernalNum_ptr_mac1_mac2_pipe;
reg[1:0] kernalNum_ptr_mac2_pixelSumACT0_pipe;
reg[1:0] kernalNum_ptr_pixelSumACT0_expACT1_pipe;
reg[1:0] kernalNum_ptr_expACT1_wbDivACT2_pipe;


//---------------------------------------------------------------------
//   Reg/wire for Module & IP
//---------------------------------------------------------------------


//---------------------------------------------------------------------
//   State parameters
//---------------------------------------------------------------------


//---------------------------------------------------------------------
//   Declare for Module & IP
//---------------------------------------------------------------------


//---------------------------------------------------------------------
//   Design
//---------------------------------------------------------------------

endmodule

//---------------------------------------------------------------------
//   Module Design
//---------------------------------------------------------------------
module #(DATA_WIDTH = 32)MAC(
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

    parameter sig_width = 23;
    parameter exp_width = 8;
    parameter ieee_compliance = 1;
    parameter en_ubr_flag = 0;
    parameter inst_arch_type = 2;

    genvar idx;

    wire[DATA_WIDTH-1:0] pixels[0:8];
    wire[DATA_WIDTH-1:0] kernals[0:8];
    wire[DATA_WIDTH-1:0] mults_result[0:8];

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

    generate
        DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
            u_DW_fp_sum3_inst(
            .inst_a   (    ),
            .inst_b   (    ),
            .inst_c   (    ),
            .inst_rnd ( 3'b000 ),
            .z_inst   ( z_inst   ),
            .status_inst  (   )
        );
    endgenerate


endmodule

module DW_fp_mult_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
    parameter sig_width = 23;
    parameter exp_width = 8;
    parameter ieee_compliance = 1;
    parameter en_ubr_flag = 0;

    input [sig_width+exp_width : 0] inst_a;
    input [sig_width+exp_width : 0] inst_b;
    input [2 : 0] inst_rnd;
    output [sig_width+exp_width : 0] z_inst;
    output [7 : 0] status_inst;
    // Instance of DW_fp_mult
    DW_fp_mult #(sig_width, exp_width, ieee_compliance, en_ubr_flag)
    U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule

module DW_fp_sum3_inst( inst_a, inst_b, inst_c, inst_rnd, z_inst,
status_inst );

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;

input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input [inst_sig_width+inst_exp_width : 0] inst_c;
input [2 : 0] inst_rnd;
output [inst_sig_width+inst_exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_sum3
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
U1 (
.a(inst_a),
.b(inst_b),
.c(inst_c),
.rnd(inst_rnd),
.z(z_inst),
.status(status_inst) );
endmodule

module DW_fp_exp_inst( inst_a, z_inst, status_inst );
    parameter inst_sig_width = 10;

    parameter inst_exp_width = 5;

    parameter inst_ieee_compliance = 0;

    parameter inst_arch = 2;

    input [inst_sig_width+inst_exp_width : 0] inst_a;
    output [inst_sig_width+inst_exp_width : 0] z_inst;
    output [7 : 0] status_inst;

    // Instance of DW_fp_exp
    DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) U1 (
    .a(inst_a),
    .z(z_inst),
    .status(status_inst) );
endmodule






module DW_fp_div_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
parameter faithful_round = 0;
parameter en_ubr_flag = 0;

input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_div
DW_fp_div #(sig_width, exp_width, ieee_compliance, faithful_round, en_ubr_flag) U1
( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst)
);
endmodule


module DW_fp_cmp_inst( inst_a, inst_b, inst_zctr, aeqb_inst, altb_inst,
agtb_inst, unordered_inst, z0_inst, z1_inst, status0_inst,
status1_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input inst_zctr;
output aeqb_inst;
output altb_inst;
output agtb_inst;
output unordered_inst;
output [sig_width+exp_width : 0] z0_inst;
output [sig_width+exp_width : 0] z1_inst;
output [7 : 0] status0_inst;
output [7 : 0] status1_inst;
// Instance of DW_fp_cmp
DW_fp_cmp #(sig_width, exp_width, ieee_compliance)
U1 ( .a(inst_a), .b(inst_b), .zctr(inst_zctr), .aeqb(aeqb_inst), 
.altb(altb_inst), .agtb(agtb_inst), .unordered(unordered_inst), 
.z0(z0_inst), .z1(z1_inst), .status0(status0_inst), 
.status1(status1_inst) );
endmodule

module DW_fp_add_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_add
DW_fp_add #(sig_width, exp_width, ieee_compliance)
U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule


module DW_fp_sub_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_sub
DW_fp_sub #(sig_width, exp_width, ieee_compliance)
U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule