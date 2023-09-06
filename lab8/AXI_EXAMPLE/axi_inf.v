module axi_inf(
           // global signals
           clk,
           rst_n,

           start,
           // axi write address channel
           awid_m_inf,
           awaddr_m_inf,
           awsize_m_inf,
           awburst_m_inf,
           awlen_m_inf,
           awvalid_m_inf,
           awready_m_inf,
           // axi write data channel
           wdata_m_inf,
           wlast_m_inf,
           wvalid_m_inf,
           wready_m_inf,
           // axi write response channel
           bid_m_inf,
           bresp_m_inf,
           bvalid_m_inf,
           bready_m_inf,
           // axi read address channel
           arid_m_inf,
           araddr_m_inf,
           arlen_m_inf,
           arsize_m_inf,
           arburst_m_inf,
           arvalid_m_inf,
           // axi read data channel
           arready_m_inf,
           rid_m_inf,
           rdata_m_inf,
           rresp_m_inf,
           rlast_m_inf,
           rvalid_m_inf,
           rready_m_inf
       );

//================================================================
//  integer / genvar / parameter
//================================================================
integer i, j;
//  axi
parameter ID_WIDTH = 4 ,ADDR_WIDTH = 32, DATA_WIDTH = 32,
          DRAM_NUMBER = 1, WRIT_NUMBER = 1 ;

//================================================================
//  INPUT AND OUTPUT DECLARATION
//================================================================
// global signals
input   clk, rst_n,start;

// axi write address channel
output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  reg [WRIT_NUMBER * ADDR_WIDTH-1:0]     awaddr_m_inf;
output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output   [WRIT_NUMBER * 4 -1:0]               awlen_m_inf;
output  reg [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// ---------------------------------------------------------------
// axi write data channel
output  reg [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  reg [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  reg [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// ---------------------------------------------------------------
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]                 bvalid_m_inf;
output  reg [WRIT_NUMBER-1:0]                 bready_m_inf;
// ---------------------------------------------------------------
// axi read address channel
output  wire [DRAM_NUMBER * ID_WIDTH-1:0]        arid_m_inf;
output  reg [DRAM_NUMBER * ADDR_WIDTH-1:0]    araddr_m_inf;
output  reg [DRAM_NUMBER * 4 -1:0]             arlen_m_inf;
output  wire [DRAM_NUMBER * 3 -1:0]            arsize_m_inf;
output  wire [DRAM_NUMBER * 2 -1:0]           arburst_m_inf;
output  reg [DRAM_NUMBER-1:0]                arvalid_m_inf;
input   wire [DRAM_NUMBER-1:0]                arready_m_inf;
// ---------------------------------------------------------------
// axi read data channel
input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
output  reg [DRAM_NUMBER-1:0]                 rready_m_inf;

//================================================================
//  CONSTANT axi signals
//================================================================
// ---------------------------------------------------------------
// axi write address channel
assign    awid_m_inf = 0      ;
assign   awlen_m_inf = 1     ;
assign  awsize_m_inf = 3'b010 ;
assign awburst_m_inf = 2'b01  ;
// ---------------------------------------------------------------
// axi read address channel
assign    arid_m_inf = 0      ;
assign  arsize_m_inf = 3'b010 ;
assign arburst_m_inf = 2'b01  ;

//================================================================
//  Multiplier
//================================================================
//===================
//  MAIN FSM
//===================
localparam  IDLE = 5'b00001,RD_DATA = 5'b00010, CAL = 5'b00100, WB = 5'b01000;
localparam  DONE = 5'b10000;

localparam OKAY = 2'b00;

reg[5:0] cur_state_ff,next_state;

wire ST_IDLE    = cur_state_ff == IDLE;
wire ST_RD_DATA = cur_state_ff == RD_DATA;
wire ST_CAL     = cur_state_ff == CAL;
wire ST_WB      = cur_state_ff == WB;
wire ST_DONE    = cur_state_ff == DONE;

//===========================
//  Registers and multiplier
//===========================
reg[DATA_WIDTH-1:0] a_ff,b_ff,out_ff;

//======================
//  rd_cnt and addr_ptr,done_cnt
//======================
reg[ADDR_WIDTH-1:0] addr_ptr;
reg rd_cnt;
reg[2:0] done_cnt;


//===============================================
//             AXIs FSM
//===============================================
//========================
//        axi states
//========================
localparam AXI_IDLE  = 4'b0001, ADDR = 4'b0010, WRITE_DATA = 4'b0100, WAIT_RESPONSE = 4'b1000;
localparam AXI_READ_DATA = 4'b0100;

//========================
//        axi write
//========================
reg[3:0] axi_wr_state_ff,axi_wr_next_state;
reg[3:0] axi_rd_state_ff,axi_rd_next_state;

wire AXI_WR_idle                = axi_wr_state_ff[0];
wire AXI_WR_addr                = axi_wr_state_ff[1];
wire AXI_WR_write_data          = axi_wr_state_ff[2];
wire AXI_WR_wait_response       = axi_wr_state_ff[3];

wire AXI_RD_idle                = axi_rd_state_ff[0];
wire AXI_RD_addr                = axi_rd_state_ff[1];
wire AXI_RD_data                = axi_rd_state_ff[2];
//===============================
//              cnts
//===============================
reg[2:0] wr_burst_cnt;

//===============================
//              FLAGS
//===============================
//AXI wr
wire wr_addr_sent_f      = awvalid_m_inf && awready_m_inf;
wire data_wrote_f     = wlast_m_inf   && wvalid_m_inf && wready_m_inf;
wire write_responed_f = bvalid_m_inf  && bready_m_inf && bresp_m_inf == OKAY;
wire valid_write_transaction_f = wvalid_m_inf && wready_m_inf;

//AXI rd
wire rd_addr_sent_f   = arvalid_m_inf && arready_m_inf;
wire all_data_received_f = rlast_m_inf && rvalid_m_inf && rready_m_inf;

// Multipler
wire rd_done_f                   = rd_cnt == 1;
wire timed_out_f                 = done_cnt == 4;

//====================================================================
//                              DESIGN
//====================================================================
//===========================================
//              AXI WRITE CHANNEL
//===========================================
//===================
//       FSM
//===================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        axi_wr_state_ff <= AXI_IDLE;
    else
    begin
        axi_wr_state_ff <=axi_wr_next_state;
    end
end

always @(*)
begin
    case(axi_wr_state_ff)
        AXI_IDLE:
            axi_wr_next_state = (next_state == WB) ? ADDR : AXI_IDLE;
        ADDR:
            axi_wr_next_state = wr_addr_sent_f ? WRITE_DATA : ADDR;
        WRITE_DATA:
            axi_wr_next_state = data_wrote_f ? WAIT_RESPONSE:WRITE_DATA;
        WAIT_RESPONSE:
            axi_wr_next_state = write_responed_f ? AXI_IDLE:WAIT_RESPONSE;
        default:
            axi_wr_next_state = AXI_IDLE;
    endcase
end

//===============================
//          WR burst cnt
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        wr_burst_cnt <= 0;
    end
    else if(AXI_WR_idle)
    begin
        wr_burst_cnt <= 0;
    end
    else if(AXI_WR_addr)
    begin
        wr_burst_cnt <= awlen_m_inf;
    end
    else if(AXI_WR_write_data)
    begin
        if(valid_write_transaction_f)
            wr_burst_cnt <= wr_burst_cnt - 1;
    end
end
//===============================
//         WRITE ADDRESS
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        awaddr_m_inf  <= 0;
        awvalid_m_inf <= 0;
    end
    else if(axi_wr_state_ff != axi_wr_next_state)
    begin
        awaddr_m_inf <= 0;
        awvalid_m_inf <= 0;
    end
    else if(AXI_WR_addr)
    begin
        awaddr_m_inf  <= addr_ptr;
        awvalid_m_inf <= 1;
    end
end

//===============================
//          WRITE DATA
//===============================
wire burst_done_f = (wr_burst_cnt == 0) && AXI_WR_write_data;
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        wdata_m_inf   <= 0;
        wlast_m_inf   <= 0;
        wvalid_m_inf  <= 0;
    end
    else if(axi_wr_state_ff != axi_wr_next_state)
    begin
        wdata_m_inf   <= 0;
        wlast_m_inf   <= 0;
        wvalid_m_inf  <= 0;
    end
    else if(AXI_WR_write_data)
    begin
        wdata_m_inf   <= out_ff;
        wlast_m_inf   <= burst_done_f;
        wvalid_m_inf  <= ST_WB;
    end
end

//===============================
//          WRITE RESPONSE
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        bready_m_inf   <= 0;
    end
    else if(axi_wr_state_ff != axi_wr_next_state)
    begin
        bready_m_inf   <= 0;
    end
    else if(AXI_WR_wait_response)
    begin
        bready_m_inf   <= AXI_WR_wait_response;
    end
end

//==================================================================
//                      AXI READ TRANSACTION
//==================================================================
//=============================
//              FSM
//=============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        axi_rd_state_ff <= AXI_IDLE;
    else
    begin
        axi_rd_state_ff <= axi_rd_next_state;
    end
end

always @(*)
begin
    case(axi_rd_state_ff)
        AXI_IDLE:
            axi_rd_next_state = (next_state == RD_DATA) ? ADDR : AXI_IDLE;
        ADDR:
            axi_rd_next_state = rd_addr_sent_f ? AXI_READ_DATA : ADDR;
        AXI_READ_DATA:
            axi_rd_next_state = all_data_received_f ? AXI_IDLE :AXI_READ_DATA;
        default:
            axi_rd_next_state = AXI_IDLE;
    endcase
end

//===============================
//          RD burst cnt
//===============================
reg[2:0] rd_burst_cnt;
wire valid_read_transaction_f = rready_m_inf && rvalid_m_inf;
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        rd_burst_cnt <= 0;
    end
    else if(AXI_RD_idle)
    begin
        rd_burst_cnt <= 0;
    end
    else if(AXI_RD_addr)
    begin
        rd_burst_cnt <= arlen_m_inf;
    end
    else if(AXI_RD_data)
    begin
        if(rd_burst_cnt == 0)
            rd_burst_cnt <= rd_burst_cnt;
        else if(valid_read_transaction_f)
            rd_burst_cnt <= rd_burst_cnt - 1;
    end
end
//===============================
//         READ ADDRESS
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        araddr_m_inf   <= 0;
        arvalid_m_inf  <= 0;
        arlen_m_inf    <= 0;
    end
    else if(axi_rd_state_ff != axi_rd_next_state)
    begin
        araddr_m_inf   <= 0;
        arvalid_m_inf  <= 0;
        arlen_m_inf    <= 0;
    end
    else if(AXI_RD_addr)
    begin
        araddr_m_inf   <= addr_ptr;
        arvalid_m_inf  <= 1;
        arlen_m_inf    <= 4;
    end
end
//===============================
//         READ DATA
//===============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        rready_m_inf   <= 0;
    end
    else if(axi_rd_state_ff != axi_rd_next_state)
    begin
        rready_m_inf   <= 0;
    end
    else if(AXI_RD_data)
    begin
        rready_m_inf   <= 1;
    end
end

//==================================================================
//                              MULT
//==================================================================
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
        begin
            if(start)
            begin
                next_state = RD_DATA;
            end
            else
            begin
                next_state = IDLE;
            end
        end
        RD_DATA:
        begin
            if(rd_done_f && mult_in_valid)
            begin
                next_state = CAL;
            end
            else
            begin
                next_state = RD_DATA;
            end
        end
        CAL:
        begin
            next_state = WB;
        end
        WB:
        begin
            //Write response okay
            if(write_responed_f)
            begin
                if(addr_ptr == 32'h1fff)
                begin
                    next_state = DONE;
                end
                else
                begin
                    next_state = RD_DATA;
                end
            end
            else
            begin
                next_state = WB;
            end
        end
        DONE:
        begin
            if(timed_out_f)
            begin
                next_state = IDLE;
            end
            else
            begin
                next_state = DONE;
            end
        end
        default:
        begin
            next_state = IDLE;
        end
    endcase
end
//==============================
//  rd_cnt,addr_ptr and done_cnt
//==============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        rd_cnt <= 0;
        addr_ptr <= 0;
        done_cnt <= 0;
    end
    else if(ST_IDLE)
    begin
        rd_cnt <= 0;
        addr_ptr <= 0;
        done_cnt <= 0;
    end
    else if(ST_RD_DATA)
    begin
        rd_cnt <= mult_in_valid ? rd_cnt + 1 : rd_cnt;
    end
    else if(ST_WB)
    begin
        if(write_responed_f)
        begin
            addr_ptr <= addr_ptr + 4;
        end
    end
    else if(ST_DONE)
    begin
        done_cnt <= timed_out_f ? 0 : done_cnt + 1;
    end
end

//==============================
//  MULT Registers
//==============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        out_ff <= 0;
    end
    else if(ST_IDLE)
    begin
        out_ff <= 0;
    end
    else if(ST_CAL)
    begin
        out_ff <= a_ff * b_ff;
    end
    else
    begin
        out_ff <= out_ff;
    end
end

wire mult_in_valid;
assign mult_in_valid = rvalid_m_inf && rready_m_inf;

//a_ff and b_ff
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        a_ff<= 0;
        b_ff<= 0;
    end
    else if(ST_IDLE)
    begin
        a_ff<= 0;
        b_ff<= 0;
    end
    else if(ST_RD_DATA)
    begin
        if(rd_cnt == 0 && mult_in_valid)
        begin
            a_ff<= rdata_m_inf;
        end
        else if(burst_done_f && mult_in_valid)
        begin
            b_ff<= rdata_m_inf;
        end
    end
    else
    begin
        a_ff<= a_ff;
        b_ff<= b_ff;
    end
end


endmodule
