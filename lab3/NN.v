`define C2Q 0.3
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
parameter inst_arch = 1;

// DIV
parameter faithful_round = 0;

// CMP

// DATAWIDTH OF DATAPATH
parameter DATA_WIDTH = 32;
parameter PADDED_IMAGE_WIDTH = 6;
parameter KERNAL_WIDTH = 3;
parameter IMAGE_WIDTH = 4;

// Integers
integer i,j,k;

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input  clk, rst_n, in_valid_i, in_valid_k, in_valid_o;
input [inst_sig_width+inst_exp_width:0] Image1, Image2, Image3;
input [inst_sig_width+inst_exp_width:0] Kernel1, Kernel2, Kernel3;
input [1:0] Opt;
output reg	out_valid;
output reg [DATA_WIDTH-1:0] out;

//---------------------------------------------------------------------
//   Registers
//---------------------------------------------------------------------
reg[DATA_WIDTH-1:0] padded_img1[0:PADDED_IMAGE_WIDTH-1][0:PADDED_IMAGE_WIDTH-1];
reg[DATA_WIDTH-1:0] padded_img2[0:PADDED_IMAGE_WIDTH-1][0:PADDED_IMAGE_WIDTH-1];
reg[DATA_WIDTH-1:0] padded_img3[0:PADDED_IMAGE_WIDTH-1][0:PADDED_IMAGE_WIDTH-1];

reg[DATA_WIDTH-1:0] kernal1[0:3][0:KERNAL_WIDTH-1][0:KERNAL_WIDTH-1];
reg[DATA_WIDTH-1:0] kernal2[0:3][0:KERNAL_WIDTH-1][0:KERNAL_WIDTH-1];
reg[DATA_WIDTH-1:0] kernal3[0:3][0:KERNAL_WIDTH-1][0:KERNAL_WIDTH-1];

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

reg[2:0] kernalNum_mac1_mac2_pipe;
reg[2:0] kernalNum_mac2_pixelSumACT0_pipe;
reg[2:0] kernalNum_pixelSumACT0_expACT1_pipe;
reg[2:0] kernalNum_expACT1_wbDivACT2_pipe;

//w_en
reg w_en;

reg w_en_mac1_mac2_pipe;
reg w_en_mac2_pixelSumACT0_pipe;
reg w_en_pixelSumACT0_expACT1_pipe;
reg w_en_expACT1_wbDivACT2_pipe;


always @(posedge clk or negedge rst_n)
begin:CTR_PIPELINES
    if(~rst_n)
    begin
        //row
        row_ptr_mac1_mac2_pipe <= 0;
        row_ptr_mac2_pixelSumACT0_pipe <= 0;
        row_ptr_pixelSumACT0_expACT1_pipe <= 0;
        row_ptr_expACT1_wbDivACT2_pipe <= 0;
        //col
        col_ptr_mac1_mac2_pipe <= 0 ;
        col_ptr_mac2_pixelSumACT0_pipe <= 0 ;
        col_ptr_pixelSumACT0_expACT1_pipe <= 0 ;
        col_ptr_expACT1_wbDivACT2_pipe <= 0 ;
        //w_en
        w_en_mac1_mac2_pipe <= 0;
        w_en_mac2_pixelSumACT0_pipe <= 0;
        w_en_pixelSumACT0_expACT1_pipe <= 0;
        w_en_expACT1_wbDivACT2_pipe <= 0;

        //kernalNum pipe
        kernalNum_mac1_mac2_pipe <= 0;
        kernalNum_mac2_pixelSumACT0_pipe <= 0;
        kernalNum_pixelSumACT0_expACT1_pipe <= 0;
        kernalNum_expACT1_wbDivACT2_pipe <= 0;
    end
    else
    begin
        //row
        row_ptr_mac1_mac2_pipe <= row_ptr;
        row_ptr_mac2_pixelSumACT0_pipe <= row_ptr_mac1_mac2_pipe;
        row_ptr_pixelSumACT0_expACT1_pipe <= row_ptr_mac2_pixelSumACT0_pipe;
        row_ptr_expACT1_wbDivACT2_pipe <= row_ptr_pixelSumACT0_expACT1_pipe;
        //col
        col_ptr_mac1_mac2_pipe <= col_ptr;
        col_ptr_mac2_pixelSumACT0_pipe <= col_ptr_mac1_mac2_pipe ;
        col_ptr_pixelSumACT0_expACT1_pipe <= col_ptr_mac2_pixelSumACT0_pipe;
        col_ptr_expACT1_wbDivACT2_pipe <= col_ptr_pixelSumACT0_expACT1_pipe;
        //w_en
        w_en_mac1_mac2_pipe <= w_en;
        w_en_mac2_pixelSumACT0_pipe <= w_en_mac1_mac2_pipe;
        w_en_pixelSumACT0_expACT1_pipe <= w_en_mac2_pixelSumACT0_pipe;
        w_en_expACT1_wbDivACT2_pipe <= w_en_pixelSumACT0_expACT1_pipe;

        //kernalNum pipe
        kernalNum_mac1_mac2_pipe <= kernalNum_cnt;
        kernalNum_mac2_pixelSumACT0_pipe <= kernalNum_mac1_mac2_pipe;
        kernalNum_pixelSumACT0_expACT1_pipe <= kernalNum_mac2_pixelSumACT0_pipe;
        kernalNum_expACT1_wbDivACT2_pipe <= kernalNum_pixelSumACT0_expACT1_pipe;
    end
end

reg[1:0] opt_ff;

//---------------------------------------------------------------------
//   Reg/wire for Module & IP
//---------------------------------------------------------------------
reg[7:0] nn_cnt;
wire[1:0] img_i = nn_cnt / 4;
wire[1:0] img_j = nn_cnt % 4;

// Incorrect value
wire[1:0] kernal_i = nn_cnt/3;
wire[1:0] kernal_j = nn_cnt % 3;
wire[1:0] kernal_NO = nn_cnt / 16;

//---------------------------------------------------------------------
//   State parameters
//---------------------------------------------------------------------
reg[4:0] currentState, nextState;

localparam IDLE        = 5'b00001;
localparam RD_DATA_IMG = 5'b00010;
localparam RD_KERNAL   = 5'b00100;
localparam PROCESSING  = 5'b01000;
localparam DONE        = 5'b10000;

wire state_IDLE                           = currentState[0];
wire state_RD_DATA_IMG                    = currentState[1];
wire state_RD_KERNAL                      = currentState[2];
wire state_PROCESSING                     = currentState[3];
wire state_DONE                           = currentState[4];

//---------------------------------------------------------------------
//   FLAGS
//---------------------------------------------------------------------
wire rd_img_done_f       = nn_cnt == 15;

wire rd_kernal_done_f    = nn_cnt == 35;

wire nn_processed_done_f = row_ptr_expACT1_wbDivACT2_pipe == 3 && col_ptr_expACT1_wbDivACT2_pipe == 3
     && kernalNum_expACT1_wbDivACT2_pipe == 3;

wire output_done_f = nn_cnt == 63;

wire img_right_bound_reach_f  = col_ptr == 3;
wire img_bottom_bound_reach_f = row_ptr == 3;
wire one_img_sent_completed_f     = img_right_bound_reach_f && img_bottom_bound_reach_f;
wire all_img_sent_done_f = one_img_sent_completed_f && kernalNum_cnt == 3;
reg  all_img_sent_ff_f;

//---------------------------------------------------------------------
//   Declare for Module & IP
//---------------------------------------------------------------------
parameter en_ubr_flag = 0;

//---------------------------------------------------------------------
//   Design
//---------------------------------------------------------------------\
//========================
//   CTR
//========================
always @(posedge clk or negedge rst_n)
begin:CUR_STATE
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        currentState <= IDLE;
    end
    else
    begin
        currentState <= nextState;
    end
end

always @(*)
begin: NXT_STATE
    case (currentState)
        IDLE    :
        begin
            nextState            = in_valid_o ? RD_DATA_IMG : IDLE;
        end
        RD_DATA_IMG :
        begin
            nextState            = rd_img_done_f ? RD_KERNAL : RD_DATA_IMG;
        end
        RD_KERNAL:
        begin
            nextState            = rd_kernal_done_f ? PROCESSING : RD_KERNAL;
        end
        PROCESSING:
        begin
            nextState            = nn_processed_done_f ? DONE : PROCESSING;
        end
        DONE:
        begin
            nextState            = output_done_f ? IDLE : DONE;
        end
        default :
        begin
            nextState            = IDLE;
        end
    endcase
end

//========================
//   opt
//========================
always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        opt_ff <= 0;
    end
    else if(state_IDLE)
    begin
        if(in_valid_o)
        begin
            opt_ff <= Opt;
        end
        else
        begin
            opt_ff <= 0;
        end
    end
    else
    begin

    end
end

//========================
//   CNTS
//========================
always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        nn_cnt <= 0;
    end
    else if(state_IDLE)
    begin
        nn_cnt <= 0;
    end
    else if(state_RD_DATA_IMG)
    begin
        if(rd_img_done_f)
        begin
            nn_cnt <= 0;
        end
        else if(in_valid_i)
        begin
            nn_cnt <= nn_cnt+1;
        end
    end
    else if(state_RD_KERNAL)
    begin
        if(rd_kernal_done_f)
        begin
            nn_cnt <= 0;
        end
        else if(in_valid_k)
        begin
            nn_cnt <= nn_cnt + 1;
        end
    end
    else if(state_DONE)
    begin
        nn_cnt <= nn_cnt + 1;
    end
    else
    begin

    end
end
//=================================
//   ROW_PTR, COL_PTR, KERNAL_CNT
//=================================


always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        all_img_sent_ff_f <= 0;
    end
    else if(state_IDLE)
    begin
        all_img_sent_ff_f <= 0;
    end
    else if(all_img_sent_done_f)
    begin
        all_img_sent_ff_f <= 1;
    end
end
always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        w_en <= 0;
        row_ptr <= 0;
        col_ptr <= 0;
        kernalNum_cnt <= 0;
    end
    else if(state_IDLE)
    begin
        w_en <= 0;
        row_ptr <= 0;
        col_ptr <= 0;
        kernalNum_cnt <= 0;
    end
    else if(state_RD_KERNAL)
    begin
        // CORRECT HERE
        if(in_valid_k)
        begin

        end
        else
        begin
            row_ptr <= 0;
            col_ptr <= 0;
        end
    end
    else if(state_PROCESSING)
    begin
        if(all_img_sent_ff_f || all_img_sent_done_f)
        begin
            w_en <= 0;
            row_ptr <= 0;
            col_ptr <= 0;
        end
        else if(one_img_sent_completed_f)
        begin
            w_en <= 1;
            row_ptr <= 0;
            col_ptr <= 0;
        end
        else if(img_right_bound_reach_f)
        begin
            w_en <= 1;
            row_ptr <= row_ptr + 1;
            col_ptr <= 0;
        end
        else
        begin
            w_en <= 1;
            row_ptr <= row_ptr;
            col_ptr <= col_ptr + 1;
        end

        if(all_img_sent_ff_f || all_img_sent_done_f)
        begin
            kernalNum_cnt <= 0;
        end
        else if(one_img_sent_completed_f)
        begin
            kernalNum_cnt <= kernalNum_cnt + 1;
        end
    end
end

//========================
//   Padded Imgs
//========================
wire[2:0] img_offset_i = img_i + 1;
wire[2:0] img_offset_j = img_j + 1;

always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for (i = 0;i<PADDED_IMAGE_WIDTH ;i=i+1 )
        begin
            for(j=0;j<PADDED_IMAGE_WIDTH;j=j+1)
            begin
                padded_img1[i][j]<=0;
                padded_img2[i][j]<=0;
                padded_img3[i][j]<=0;
            end
        end
    end
    else if(state_IDLE)
    begin
        for (i = 0;i<PADDED_IMAGE_WIDTH ;i=i+1 )
        begin
            for(j=0;j<PADDED_IMAGE_WIDTH;j=j+1)
            begin
                padded_img1[i][j]<=0;
                padded_img2[i][j]<=0;
                padded_img3[i][j]<=0;
            end
        end
    end
    else if(state_RD_DATA_IMG)
    begin
        if(in_valid_i)
        begin
            case(opt_ff)
                2'b00,2'b01:
                begin
                    // Replication
                    // Corners
                    if(img_i == 0 && img_j == 0)
                    begin
                        // (0,0) -> (1,1)
                        //       >  (0,0)
                        //       >  (1,0)
                        //       >  (0,1)
                        padded_img1[0][0] <= Image1;
                        padded_img1[0][1] <= Image1;
                        padded_img1[1][1] <= Image1;
                        padded_img1[1][0] <= Image1;

                        padded_img2[0][0] <= Image2;
                        padded_img2[0][1] <= Image2;
                        padded_img2[1][1] <= Image2;
                        padded_img2[1][0] <= Image2;

                        padded_img3[0][0] <= Image3;
                        padded_img3[0][1] <= Image3;
                        padded_img3[1][1] <= Image3;
                        padded_img3[1][0] <= Image3;
                    end
                    else if(img_i == 0 && img_j == 3)
                    begin
                        //(0,3) -> (1,5)
                        //       > (0,5)
                        //       > (0,4)
                        //       > (1,4)
                        padded_img1[1][5] <= Image1;
                        padded_img1[0][5] <= Image1;
                        padded_img1[0][4] <= Image1;
                        padded_img1[1][4] <= Image1;

                        padded_img2[1][5] <= Image2;
                        padded_img2[0][5] <= Image2;
                        padded_img2[0][4] <= Image2;
                        padded_img2[1][4] <= Image2;

                        padded_img3[1][5] <= Image3;
                        padded_img3[0][5] <= Image3;
                        padded_img3[0][4] <= Image3;
                        padded_img3[1][4] <= Image3;
                    end
                    else if(img_i == 3 && img_j == 3)
                    begin
                        //(3,3) -> (4,4)
                        //       > (4,5)
                        //       > (5,4)
                        //       > (5,5)
                        padded_img1[4][4] <= Image1;
                        padded_img1[4][5] <= Image1;
                        padded_img1[5][4] <= Image1;
                        padded_img1[5][5] <= Image1;

                        padded_img2[4][4] <= Image2;
                        padded_img2[4][5] <= Image2;
                        padded_img2[5][4] <= Image2;
                        padded_img2[5][5] <= Image2;

                        padded_img3[4][4] <= Image3;
                        padded_img3[4][5] <= Image3;
                        padded_img3[5][4] <= Image3;
                        padded_img3[5][5] <= Image3;
                    end
                    else if(img_i == 3 && img_j == 0)
                    begin
                        //(3,0) -> (4,1)
                        //       > (4,0)
                        //       > (5,1)
                        //       > (5,0)
                        padded_img1[4][1] <= Image1;
                        padded_img1[4][0] <= Image1;
                        padded_img1[5][1] <= Image1;
                        padded_img1[5][0] <= Image1;

                        padded_img2[4][1] <= Image2;
                        padded_img2[4][0] <= Image2;
                        padded_img2[5][1] <= Image2;
                        padded_img2[5][0] <= Image2;

                        padded_img3[4][1] <= Image3;
                        padded_img3[4][0] <= Image3;
                        padded_img3[5][1] <= Image3;
                        padded_img3[5][0] <= Image3;
                    end
                    else if(img_i == 0) // Horizontal Boundaries
                    begin
                        // (0,j) -> (1,j+1)
                        //        > (0,j+1)
                        padded_img1[1][img_offset_j] <= Image1;
                        padded_img1[0][img_offset_j] <= Image1;

                        padded_img2[1][img_offset_j] <= Image2;
                        padded_img2[0][img_offset_j] <= Image2;

                        padded_img3[1][img_offset_j] <= Image3;
                        padded_img3[0][img_offset_j] <= Image3;
                    end
                    else if(img_j == 0)
                    begin
                        // (i,0) -> (i+1,1)
                        //        > (i+1,0)
                        padded_img1[img_offset_i][1] <= Image1;
                        padded_img1[img_offset_i][0] <= Image1;

                        padded_img2[img_offset_i][1] <= Image2;
                        padded_img2[img_offset_i][0] <= Image2;

                        padded_img3[img_offset_i][1] <= Image3;
                        padded_img3[img_offset_i][0] <= Image3;
                    end
                    else if(img_i == 3)
                    begin
                        // (3,j) -> (4,j+1)
                        //        > (5,j+1)
                        padded_img1[4][img_offset_j] <= Image1;
                        padded_img1[5][img_offset_j] <= Image1;

                        padded_img2[4][img_offset_j] <= Image2;
                        padded_img2[5][img_offset_j] <= Image2;

                        padded_img3[4][img_offset_j] <= Image3;
                        padded_img3[5][img_offset_j] <= Image3;
                    end
                    else if(img_j == 3)
                    begin
                        // (i,3) -> (i+1,4)
                        //        > (i+1,5)
                        padded_img1[img_offset_i][4] <= Image1;
                        padded_img1[img_offset_i][5] <= Image1;

                        padded_img2[img_offset_i][4] <= Image2;
                        padded_img2[img_offset_i][5] <= Image2;

                        padded_img3[img_offset_i][4] <= Image3;
                        padded_img3[img_offset_i][5] <= Image3;
                    end
                    else
                    begin
                        // other cases.
                        padded_img1[img_offset_i][img_offset_j] <= Image1;

                        padded_img2[img_offset_i][img_offset_j] <= Image2;

                        padded_img3[img_offset_i][img_offset_j] <= Image3;
                    end
                end
                2'b10,2'b11:
                begin // Zero padding
                    padded_img1[img_offset_i][img_offset_j] <= Image1;
                    padded_img2[img_offset_i][img_offset_j] <= Image2;
                    padded_img3[img_offset_i][img_offset_j] <= Image3;
                end
                default:
                begin
                    padded_img1[img_i][img_j] <= 'bz;
                    padded_img2[img_i][img_j] <= 'bz;
                    padded_img3[img_i][img_j] <= 'bz;
                end
            endcase
        end
    end
    else
    begin

    end
end

//========================
//   KERNALS
//========================
always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for(i=0;i<4;i=i+1)
            for(j=0;j<3;j=j+1)
                for(k=0;k<3;k=k+1)
                begin
                    kernal1[i][j][k] <= 0;
                    kernal2[i][j][k] <= 0;
                    kernal3[i][j][k] <= 0;
                end
    end
    else if(state_IDLE)
    begin
        for(i=0;i<4;i=i+1)
            for(j=0;j<3;j=j+1)
                for(k=0;k<3;k=k+1)
                begin
                    kernal1[i][j][k] <= 0;
                    kernal2[i][j][k] <= 0;
                    kernal3[i][j][k] <= 0;
                end
    end
    else if(state_RD_KERNAL)
    begin
        if(in_valid_k)
        begin
            kernal1[kernal_NO][kernal_i][kernal_j] <= Kernel1;
            kernal2[kernal_NO][kernal_i][kernal_j] <= Kernel2;
            kernal3[kernal_NO][kernal_i][kernal_j] <= Kernel3;
        end
        else
        begin

        end
    end
    else
    begin

    end
end

//==========================================
//   MAC Stage  3 SUM stage
//==========================================
wire[DATA_WIDTH-1:0] mac_outputs[0:2];
wire[DATA_WIDTH-1:0] mac_sum;

wire[4:0] row_00 = row_ptr;
wire[4:0] row_01 = row_ptr;
wire[4:0] row_02 = row_ptr;
wire[4:0] row_10 = row_ptr + 1;
wire[4:0] row_11 = row_ptr + 1;
wire[4:0] row_12 = row_ptr + 1;
wire[4:0] row_20 = row_ptr + 2;
wire[4:0] row_21 = row_ptr + 2;
wire[4:0] row_22 = row_ptr + 2;

wire[4:0] col_00 = col_ptr;
wire[4:0] col_01 = col_ptr;
wire[4:0] col_02 = col_ptr;
wire[4:0] col_10 = col_ptr + 1;
wire[4:0] col_11 = col_ptr + 1;
wire[4:0] col_12 = col_ptr + 1;
wire[4:0] col_20 = col_ptr + 2;
wire[4:0] col_21 = col_ptr + 2;
wire[4:0] col_22 = col_ptr + 2;


MAC#(
       .DATA_WIDTH      (DATA_WIDTH      ),
       .sig_width       (inst_sig_width       ),
       .exp_width       (inst_exp_width       ),
       .ieee_compliance (inst_ieee_compliance ),
       .en_ubr_flag     (en_ubr_flag     ),
       .inst_arch_type  (inst_arch  )
   )
   u_MAC1(
       .clk(clk),
       .rst_n(rst_n),
       .pixel0       (padded_img1[row_00][col_00]),
       .pixel1       (padded_img1[row_01][col_01]),
       .pixel2       (padded_img1[row_02][col_02]),
       .pixel3       (padded_img1[row_10][col_10]),
       .pixel4       (padded_img1[row_11][col_11]),
       .pixel5       (padded_img1[row_12][col_12]),
       .pixel6       (padded_img1[row_20][col_20]),
       .pixel7       (padded_img1[row_21][col_21]),
       .pixel8       (padded_img1[row_22][col_22]),

       .kernal0      (kernal1[kernalNum_cnt][0][0]),
       .kernal1      (kernal1[kernalNum_cnt][0][1]),
       .kernal2      (kernal1[kernalNum_cnt][0][2]),
       .kernal3      (kernal1[kernalNum_cnt][1][0]),
       .kernal4      (kernal1[kernalNum_cnt][1][1]),
       .kernal5      (kernal1[kernalNum_cnt][1][2]),
       .kernal6      (kernal1[kernalNum_cnt][2][0]),
       .kernal7      (kernal1[kernalNum_cnt][2][1]),
       .kernal8      (kernal1[kernalNum_cnt][2][2]),
       .macResult_ff (mac_outputs[0] )
   );

MAC#(
       .DATA_WIDTH      (DATA_WIDTH      ),
       .sig_width       (inst_sig_width       ),
       .exp_width       (inst_exp_width       ),
       .ieee_compliance (inst_ieee_compliance ),
       .en_ubr_flag     (en_ubr_flag     ),
       .inst_arch_type  (inst_arch  )
   )
   u_MAC2(
       .clk(clk),
       .rst_n(rst_n),
       .pixel0       (padded_img2[row_00][col_00]),
       .pixel1       (padded_img2[row_01][col_01]),
       .pixel2       (padded_img2[row_02][col_02]),
       .pixel3       (padded_img2[row_10][col_10]),
       .pixel4       (padded_img2[row_11][col_11]),
       .pixel5       (padded_img2[row_12][col_12]),
       .pixel6       (padded_img2[row_20][col_20]),
       .pixel7       (padded_img2[row_21][col_21]),
       .pixel8       (padded_img2[row_22][col_22]),

       .kernal0      (kernal2[kernalNum_cnt][0][0]),
       .kernal1      (kernal2[kernalNum_cnt][0][1]),
       .kernal2      (kernal2[kernalNum_cnt][0][2]),
       .kernal3      (kernal2[kernalNum_cnt][1][0]),
       .kernal4      (kernal2[kernalNum_cnt][1][1]),
       .kernal5      (kernal2[kernalNum_cnt][1][2]),
       .kernal6      (kernal2[kernalNum_cnt][2][0]),
       .kernal7      (kernal2[kernalNum_cnt][2][1]),
       .kernal8      (kernal2[kernalNum_cnt][2][2]),
       .macResult_ff (mac_outputs[1] )
   );

MAC#(
       .DATA_WIDTH      (DATA_WIDTH      ),
       .sig_width       (inst_sig_width       ),
       .exp_width       (inst_exp_width       ),
       .ieee_compliance (inst_ieee_compliance ),
       .en_ubr_flag     (en_ubr_flag     ),
       .inst_arch_type  (inst_arch  )
   )
   u_MAC3(
       .clk(clk),
       .rst_n(rst_n),
       .pixel0       (padded_img3[row_00][col_00]),
       .pixel1       (padded_img3[row_01][col_01]),
       .pixel2       (padded_img3[row_02][col_02]),
       .pixel3       (padded_img3[row_10][col_10]),
       .pixel4       (padded_img3[row_11][col_11]),
       .pixel5       (padded_img3[row_12][col_12]),
       .pixel6       (padded_img3[row_20][col_20]),
       .pixel7       (padded_img3[row_21][col_21]),
       .pixel8       (padded_img3[row_22][col_22]),

       .kernal0      (kernal3[kernalNum_cnt][0][0]),
       .kernal1      (kernal3[kernalNum_cnt][0][1]),
       .kernal2      (kernal3[kernalNum_cnt][0][2]),
       .kernal3      (kernal3[kernalNum_cnt][1][0]),
       .kernal4      (kernal3[kernalNum_cnt][1][1]),
       .kernal5      (kernal3[kernalNum_cnt][1][2]),
       .kernal6      (kernal3[kernalNum_cnt][2][0]),
       .kernal7      (kernal3[kernalNum_cnt][2][1]),
       .kernal8      (kernal3[kernalNum_cnt][2][2]),
       .macResult_ff (mac_outputs[2] )
   );

DW_fp_sum3_inst
    #(
        .inst_sig_width       (inst_sig_width       ),
        .inst_exp_width       (inst_exp_width       ),
        .inst_ieee_compliance (inst_ieee_compliance ),
        .inst_arch_type       (inst_arch       )
    )
    u_mac_sum(
        .inst_a      (mac_outputs[0]      ),
        .inst_b      (mac_outputs[1]      ),
        .inst_c      (mac_outputs[2]      ),
        .inst_rnd    (3'b000    ),
        .z_inst      (mac_sum      ),
        .status_inst ( )
    );


//============================
//    PIXELSUM ACT0 STAGE
//============================
localparam FP_ZERO = 32'h00000000;
localparam FP_ONE  = 32'h3f800000;
localparam FP_POINT_ONE = 32'h3dcccccd;

wire[DATA_WIDTH-1:0] act0_stage_fp_add_out;
wire[DATA_WIDTH-1:0] act0_stage_fp_mult_out;
wire act0_stage_fp_cmp_out;
reg[DATA_WIDTH-1:0]  result_act0_act1_pipe;


DW_fp_add_inst
    #(
        .sig_width       (inst_sig_width),
        .exp_width       (inst_exp_width),
        .ieee_compliance (inst_ieee_compliance)
    )
    u_DW_fp_add_ACT0(
        .inst_a      (mac_sum      ),
        .inst_b      (FP_ONE      ),
        .inst_rnd    (3'b000   ),
        .z_inst      (act0_stage_fp_add_out      ),
        .status_inst ( )
    );

// Read the document
DW_fp_cmp_inst
    #(
        .sig_width       (inst_sig_width),
        .exp_width       (inst_exp_width),
        .ieee_compliance (inst_ieee_compliance)
    )
    u_DW_fp_cmp_inst(
        .inst_a         (mac_sum         ),
        .inst_b         (FP_ZERO         ),
        .inst_zctr      (      ),
        .aeqb_inst      (      ),
        .altb_inst      (      ),
        .agtb_inst      (act0_stage_fp_cmp_out),
        .unordered_inst ( ),
        .z0_inst        (        ),
        .z1_inst        (        ),
        .status0_inst   (   ),
        .status1_inst   (   )
    );

DW_fp_mult_inst
    #(
        .sig_width       (inst_sig_width),
        .exp_width       (inst_exp_width),
        .ieee_compliance (inst_ieee_compliance),
        .en_ubr_flag     (en_ubr_flag     )
    )
    u_DW_fp_mult_inst(
        .inst_a      (mac_sum      ),
        .inst_b      (FP_POINT_ONE      ),
        .inst_rnd    (3'b000    ),
        .z_inst      (act0_stage_fp_mult_out      ),
        .status_inst ( )
    );

always @(posedge clk or negedge rst_n)
begin:RESULT_ACT0_ACT1_PIPE
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        result_act0_act1_pipe <= FP_ZERO;
    end
    else if(state_IDLE)
    begin
        result_act0_act1_pipe <= FP_ZERO;
    end
    else
    begin
        case(opt_ff)
            2'b00:
                result_act0_act1_pipe <= act0_stage_fp_cmp_out ? mac_sum : FP_ZERO;
            2'b01:
                result_act0_act1_pipe <= act0_stage_fp_cmp_out ? mac_sum : act0_stage_fp_mult_out;
            2'b10:
                result_act0_act1_pipe <= act0_stage_fp_add_out;
            2'b11:
                result_act0_act1_pipe <= act0_stage_fp_add_out;
            default:
                result_act0_act1_pipe <= FP_ZERO;
        endcase
    end
end


//============================
//    ACT1_EXP STAGE
//============================
wire[DATA_WIDTH-1:0] negation = {~result_act0_act1_pipe[31],result_act0_act1_pipe[30:0]};
wire[DATA_WIDTH-1:0] act1_exp_result;
reg[DATA_WIDTH-1:0]  result_act1Exp_act2WB_pipe;

DW_fp_exp_inst
    #(
        .inst_sig_width       (inst_sig_width       ),
        .inst_exp_width       (inst_exp_width       ),
        .inst_ieee_compliance (inst_ieee_compliance ),
        .inst_arch            (inst_arch            )
    )
    u_DW_fp_exp(
        .inst_a      (negation      ),
        .z_inst      (act1_exp_result      ),
        .status_inst ( )
    );

always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        result_act1Exp_act2WB_pipe <= FP_ZERO;
    end
    else
    begin
        result_act1Exp_act2WB_pipe <= (opt_ff == 2'b00 || opt_ff == 2'b01) ?
                                   result_act0_act1_pipe : act1_exp_result;
    end
end

//==============================================================================
//    ACT2_DIV_WB STAGE
//==============================================================================
wire[DATA_WIDTH-1:0] fp_act2_sub_result;
wire[DATA_WIDTH-1:0] fp_act2_add_result;
wire[DATA_WIDTH-1:0] fp_act2_div_result;
wire[DATA_WIDTH-1:0] fp_div_in = (opt_ff == 2'b01) ? FP_ONE : fp_act2_sub_result;

DW_fp_sub_inst
    #(
        .sig_width       (inst_sig_width       ),
        .exp_width       (inst_exp_width       ),
        .ieee_compliance (inst_ieee_compliance )
    )
    u_DW_fp_sub_ACT2(
        .inst_a      (FP_ONE      ),
        .inst_b      (result_act1Exp_act2WB_pipe      ),
        .inst_rnd    (3'b000    ),
        .z_inst      (fp_act2_sub_result      ),
        .status_inst ( )
    );

DW_fp_add_inst
    #(
        .sig_width       (inst_sig_width       ),
        .exp_width       (inst_exp_width       ),
        .ieee_compliance (inst_ieee_compliance )
    )
    u_DW_fp_add_ACT2(
        .inst_a      (result_act1Exp_act2WB_pipe      ),
        .inst_b      (FP_ONE      ),
        .inst_rnd    (3'b000    ),
        .z_inst      (fp_act2_add_result      ),
        .status_inst ( )
    );

DW_fp_div_inst
    #(
        .sig_width       (inst_sig_width       ),
        .exp_width       (inst_exp_width       ),
        .ieee_compliance (inst_ieee_compliance ),
        .faithful_round  (faithful_round  ),
        .en_ubr_flag     (en_ubr_flag     )
    )
    u_DW_fp_div_ACT2(
        .inst_a      (fp_div_in      ),
        .inst_b      (fp_act2_add_result      ),
        .inst_rnd    (3'b000    ),
        .z_inst      (fp_act2_div_result      ),
        .status_inst ( )
    );

//============================
//    Shuffled img
//============================
wire[7:0] shuffled_img_offset_row = row_ptr_expACT1_wbDivACT2_pipe*2;
wire[7:0] shuffled_img_offset_col = col_ptr_expACT1_wbDivACT2_pipe*2;

wire[7:0] kernal0_shuffled_offset_row = shuffled_img_offset_row;
wire[7:0] kernal0_shuffled_offset_col = shuffled_img_offset_col;


wire[7:0] kernal1_shuffled_offset_row = shuffled_img_offset_row;
wire[7:0] kernal1_shuffled_offset_col = shuffled_img_offset_col+1;

wire[7:0] kernal2_shuffled_offset_row = shuffled_img_offset_row+1;
wire[7:0] kernal2_shuffled_offset_col = shuffled_img_offset_col;

wire[7:0] kernal3_shuffled_offset_row = shuffled_img_offset_row+1;
wire[7:0] kernal3_shuffled_offset_col = shuffled_img_offset_col+1;



always @(posedge clk or negedge rst_n)
begin
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for (i = 0;i<PADDED_IMAGE_WIDTH ;i=i+1 )
        begin
            for(j=0;j<PADDED_IMAGE_WIDTH;j=j+1)
            begin
                shuffled_img[i][j]<=0;
                shuffled_img[i][j]<=0;
                shuffled_img[i][j]<=0;
            end
        end
    end
    else if(state_IDLE)
    begin
        for (i = 0;i<PADDED_IMAGE_WIDTH ;i=i+1 )
        begin
            for(j=0;j<PADDED_IMAGE_WIDTH;j=j+1)
            begin
                shuffled_img[i][j]<=0;
                shuffled_img[i][j]<=0;
                shuffled_img[i][j]<=0;
            end
        end
    end
    else if(state_PROCESSING)
    begin
        if(w_en_expACT1_wbDivACT2_pipe)
        begin
            case(kernalNum_expACT1_wbDivACT2_pipe)
                2'd0:
                begin
                    shuffled_img[kernal0_shuffled_offset_row][kernal0_shuffled_offset_col] <=
                    result_act1Exp_act2WB_pipe;
                end
                2'd1:
                begin
                    shuffled_img[kernal1_shuffled_offset_row][kernal1_shuffled_offset_col] <=
                    result_act1Exp_act2WB_pipe;
                end
                2'd2:
                begin
                    shuffled_img[kernal2_shuffled_offset_row][kernal2_shuffled_offset_col] <=
                    result_act1Exp_act2WB_pipe;
                end
                2'd3:
                begin
                    shuffled_img[kernal3_shuffled_offset_row][kernal3_shuffled_offset_col] <=
                    result_act1Exp_act2WB_pipe;
                end
                default:
                begin
                    shuffled_img[row_ptr_expACT1_wbDivACT2_pipe][col_ptr_expACT1_wbDivACT2_pipe] <=
                    result_act1Exp_act2WB_pipe;
                end
            endcase
        end
    end
end

//====================
//   OUT and out_valid
//====================
wire[2:0] shuffled_img_i = state_DONE ? nn_cnt/8 : 0;
wire[2:0] shuffled_img_j = state_DONE ? nn_cnt%8 : 0;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        out_valid <= 0;
        out <= 0;
    end
    else if(state_IDLE)
    begin
        out_valid<=0;
        out<=0;
    end
    else if(state_DONE)
    begin
        out_valid <= 1;
        out <= shuffled_img[shuffled_img_i][shuffled_img_j];
    end
end


endmodule

    //---------------------------------------------------------------------
    //   Module Design
    //---------------------------------------------------------------------

    module MAC#(parameter DATA_WIDTH = 32,
                parameter sig_width = 23,
                parameter exp_width = 8,
                parameter ieee_compliance = 1,
                parameter en_ubr_flag = 0,
                parameter inst_arch_type = 2) (
        input clk,
        input rst_n,
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

        output reg[DATA_WIDTH-1:0] macResult_ff

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
    begin:PARRALLEL_MULTS
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
                u_DW_fp_sum3_inst1(
                    .inst_a   ( mults_result[0]),
                    .inst_b   ( mults_result[1]),
                    .inst_c   ( mults_result[2]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[0]   ),
                    .status_inst  (   )
                );

DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst2(
                    .inst_a   ( mults_result[3]),
                    .inst_b   ( mults_result[4]),
                    .inst_c   ( mults_result[5]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[1]),
                    .status_inst  (   )
                );

DW_fp_sum3_inst #(sig_width,exp_width,ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst3(
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
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
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
          U1 ( .a(inst_a), .b(inst_b), .zctr(inst_zctr), .aeqb(aeqb_inst),
               .altb(altb_inst), .agtb(agtb_inst), .unordered(unordered_inst),
               .z0(z0_inst), .z1(z1_inst), .status0(status0_inst),
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
