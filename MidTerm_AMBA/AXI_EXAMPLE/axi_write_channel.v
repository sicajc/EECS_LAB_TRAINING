module axi_write_channel(
           // global signals
           clk,
           rst_n,
           //operation
           write_op,
           //===============================
           //  PORTS to INTERCONNECT
           //===============================
           // axi write address channel
           awid_m_inf,
           awaddr_m_inf,
           awsize_m_inf,
           awburst_m_inf,
           awlen_m_inf,
           awvalid_m_inf,
           awready_s_inf,
           // axi write data channel
           wdata_m_inf,
           wlast_m_inf,
           wvalid_m_inf,
           wready_s_inf,
           // axi write response channel
           bid_s_inf,
           bresp_s_inf,
           bvalid_s_inf,
           bready_m_inf,
           //===============================
           //  PORTS to IP
           //===============================
           // axi write address channel
           i_awid_m_inf_wr,
           i_awaddr_m_inf_wr,
           i_awsize_m_inf_wr,
           i_awburst_m_inf_wr,
           i_awlen_m_inf_wr,
           i_awvalid_m_inf_wr,
           o_awready_s_inf_wr,
           // axi write data channel
           i_wdata_m_inf_wr,
           i_wlast_m_inf_wr,
           i_wvalid_m_inf_wr,
           o_wready_s_inf_wr,
           // axi write response channel
           o_bid_s_inf_wr,
           o_bresp_s_inf_wr,
           o_bvalid_s_inf_wr,
           i_bready_m_inf_wr,
       );
//================================================================
//  integer / genvar / parameter
//================================================================
//  axi
parameter ID_WIDTH = 4 ,ADDR_WIDTH = 32, DATA_WIDTH = 32,
          DRAM_NUMBER = 1, WRIT_NUMBER = 1 ;
// States
localparam IDLE = 4'b0001, ADDR = 4'b0010, WRITE_DATA = 4'b0100, WAIT_RESPONSE = 4'b1000;

//================================================================
//  INPUT AND OUTPUT DECLARATION
//================================================================
// global signals
input clk;
input rst_n;
//;peration
input write_op;
//===============================
//     PORTS to INTERCONNECT
//   axi write address channel
//===============================
output[3:0] awid_m_inf;
output reg[DATA_WIDTH-1:0]  awaddr_m_inf;
output[2:0] awsize_m_inf;
output[1:0] awburst_m_inf;
output reg[3:0] awlen_m_inf;
output reg awvalid_m_inf;
input  awready_s_inf;
//axi write data channel
output reg [DATA_WIDTH-1:0]wdata_m_inf;
output reg wlast_m_inf;
output reg wvalid_m_inf;
input  wready_s_inf;
//axi write response channel
input[3:0] bid_s_inf;
input[1:0] bresp_s_inf;
input bvalid_s_inf;
output reg bready_m_inf;
//===============================
//       PORTS to IP
//===============================
//  axi write address channel
input[3:0] i_awid_m_inf_wr;
input[ADDR_WIDTH-1:0] i_awaddr_m_inf_wr;
input[2:0] i_awsize_m_inf_wr;
input[1:0] i_awburst_m_inf_wr;
input[3:0] i_awlen_m_inf_wr;
input i_awvalid_m_inf_wr;
output o_awready_s_inf_wr;
//;axi write data channel
input [DATA_WIDTH-1:0]i_wdata_m_inf_wr;
input i_wlast_m_inf_wr;
input i_wvalid_m_inf_wr;
output o_wready_s_inf_wr;
//;axi write response channel
output[3:0]  o_bid_s_inf_wr;
output[1:0] o_bresp_s_inf_wr;
output o_bvalid_s_inf_wr;
input  i_bready_m_inf_wr;
//===============================
//              FSM
//===============================
reg[3:0] cur_state_ff,next_state;
wire ST_idle                = cur_state_ff[0];
wire ST_addr                = cur_state_ff[1];
wire ST_write_data          = cur_state_ff[2];
wire ST_wait_response       = cur_state_ff[3];
//===============================
//              cnts
//===============================
reg[2:0] burst_cnt;
//===============================
//              FLAGS
//===============================
wire addr_sent_f      = awvalid_m_inf && awready_s_inf;
wire data_wrote_f     = wlast_m_inf   && wvalid_m_inf && wready_s_inf;
wire write_responed_f = bvalid_s_inf  && bready_m_inf && bresp_s_inf;
wire valid_write_transaction_f = wvalid_m_inf && wready_s_inf;

//==================================================
//              MAIN DESIGN
//==================================================
//===============================
//              FSM
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        cur_state_ff <= IDLE;
    else
    begin
        cur_state_ff <=next_state;
    end
end

always @(*)
begin
    case(cur_state_ff)
        IDLE:
            next_state = write_op    ? ADDR : IDLE;
        ADDR:
            next_state = addr_sent_f ? WRITE_DATA : ADDR;
        WRITE_DATA:
            next_state = data_wrote_f ? WAIT_RESPONSE:WRITE_DATA;
        WAIT_RESPONSE:
            next_state = write_responed_f ? IDLE:WAIT_RESPONSE;
        default:
            next_state = IDLE;
    endcase
end
//===============================
//          burst cnt
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        burst_cnt <= 0;
    end
    else if(ST_idle)
    begin
        burst_cnt <= 0;
    end
    else if(ST_addr)
    begin
        burst_cnt <= i_awlen_m_inf_wr;
    end
    else if(ST_write_data)
    begin
        if(valid_write_transaction_f)
            burst_cnt <= burst_cnt - 1;
    end
end

//===============================
//         WRITE ADDRESS
//===============================
assign awid_m_inf = i_awaddr_m_inf_wr;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        awaddr_m_inf  <= 0;
        awlen_m_inf   <= 0;
        awvalid_m_inf <= 0;
    end
    else if(cur_state_ff != next_state)
    begin
        awaddr_m_inf <= 0;
        awvalid_m_inf <= 0;
        awlen_m_inf   <= 0;
    end
    else if(ST_addr)
    begin
        awaddr_m_inf  <= i_awaddr_m_inf_wr;
        awvalid_m_inf <= i_awvalid_m_inf_wr;
        awlen_m_inf   <= i_awlen_m_inf_wr;
    end
end

assign awsize_m_inf       = i_awsize_m_inf_wr;
assign awburst_m_inf      = i_awburst_m_inf_wr;
assign o_awready_s_inf_wr = awready_s_inf;

//===============================
//          WRITE DATA
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        wdata_m_inf   <= 0;
        wlast_m_inf   <= 0;
        wvalid_m_inf  <= 0;
    end
    else if(cur_state_ff != next_state)
    begin
        wdata_m_inf   <= 0;
        wlast_m_inf   <= 0;
        wvalid_m_inf  <= 0;
    end
    else if(ST_write_data)
    begin
        wdata_m_inf   <= i_wdata_m_inf_wr;
        wlast_m_inf   <= (burst_cnt == 0);
        wvalid_m_inf  <= i_wvalid_m_inf_wr;
    end
end

assign o_wready_s_inf_wr = wready_s_inf;
//===============================
//          WRITE RESPONSE
//===============================
assign o_bid_s_inf_wr   = bid_s_inf;
assign o_bresp_s_inf_wr = bresp_s_inf;
assign o_bvalid_s_inf_wr = bvalid_s_inf;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        bready_m_inf   <= 0;
    end
    else if(cur_state_ff != next_state)
    begin
        bready_m_inf   <= 0;
    end
    else if(ST_wait_response)
    begin
        bready_m_inf   <= i_bready_m_inf_wr;
    end
end


endmodule
