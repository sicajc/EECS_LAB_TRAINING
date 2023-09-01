module axi_inf(
           // global signals
           clk,
           rst_n,
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
input   clk, rst_n;

// axi write address channel
output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  wire [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output  wire [WRIT_NUMBER * 4 -1:0]             awlen_m_inf;
output  wire [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// ---------------------------------------------------------------
// axi write data channel
output  wire [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  wire [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  wire [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// ---------------------------------------------------------------
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]                 bvalid_m_inf;
output  wire [WRIT_NUMBER-1:0]                 bready_m_inf;
// ---------------------------------------------------------------
// axi read address channel
output  wire [DRAM_NUMBER * ID_WIDTH-1:0]        arid_m_inf;
output  wire [DRAM_NUMBER * ADDR_WIDTH-1:0]    araddr_m_inf;
output  wire [DRAM_NUMBER * 4 -1:0]             arlen_m_inf;
output  wire [DRAM_NUMBER * 3 -1:0]            arsize_m_inf;
output  wire [DRAM_NUMBER * 2 -1:0]           arburst_m_inf;
output  wire [DRAM_NUMBER-1:0]                arvalid_m_inf;
input   wire [DRAM_NUMBER-1:0]                arready_m_inf;
// ---------------------------------------------------------------
// axi read data channel
input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
output  wire [DRAM_NUMBER-1:0]                 rready_m_inf;

//=========================================================================
//  Wire : for convenience, pulls the axi in and wire value to these line
//=========================================================================
// ---------------------------------------------------------------
// axi read address channel
wire [ID_WIDTH-1:0]     arid_m_inf_w;
reg  [ADDR_WIDTH-1:0] araddr_m_inf_w_ff;
wire [4-1:0]           arlen_m_inf_w;
wire [3-1:0]          arsize_m_inf_w;
wire [2-1:0]         arburst_m_inf_w;
reg                 arvalid_m_inf_w_ff;

assign    arid_m_inf =     arid_m_inf_w  ;
assign  araddr_m_inf =   araddr_m_inf_w  ;
assign   arlen_m_inf =    arlen_m_inf_w  ;
assign  arsize_m_inf =   arsize_m_inf_w  ;
assign arburst_m_inf =  arburst_m_inf_w  ;
assign arvalid_m_inf =  arvalid_m_inf_w  ;

wire                 arready_m_inf_w;
assign arready_m_inf_w = arready_m_inf ;
// ---------------------------------------------------------------
// axi write data channel
//AW
reg[ADDR_WIDTH-1:0] awaddr_m_inf_ff;
reg awvalid_m_inf_ff;
//W
reg[DATA_WIDTH-1:0] wdata_m_inf_ff;
reg wlast_m_inf_ff;
reg wvalid_m_inf_ff;
//B
reg bvalid_m_inf_ff;

assign awaddr_m_inf  = awaddr_m_inf_ff;
assign awvalid_m_inf = awvalid_m_inf_ff;
assign wdata_m_inf   = wdata_m_inf_ff;
assign wvalid_m_inf  = wvalid_m_inf_ff;
assign bvalid_m_inf  = bvalid_m_inf_ff;
assign wlast_m_inf   = wlast_m_inf_ff;

// axi read data channel
wire [ID_WIDTH-1:0]     rid_m_inf_w;
wire [DATA_WIDTH-1:0] rdata_m_inf_w;
wire [2-1:0]          rresp_m_inf_w;
wire                  rlast_m_inf_w;
wire                 rvalid_m_inf_w;

assign    rid_m_inf_w =    rid_m_inf;
assign  rdata_m_inf_w =  rdata_m_inf;
assign  rresp_m_inf_w =  rresp_m_inf;
assign  rlast_m_inf_w =  rlast_m_inf;
assign rvalid_m_inf_w = rvalid_m_inf;

wire                 rready_m_inf_w;
assign rready_m_inf = rready_m_inf_w[0] ;
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
assign    arid_m_inf_w = 0      ;
assign  arsize_m_inf_w = 3'b010 ;
assign arburst_m_inf_w = 2'b01  ;

//================================================================
//  Multiplier
//================================================================
//===================
//  MAIN FSM
//===================
localparam  IDLE = 5'b00001,RD_DATA = 5'b00010, CAL = 5'b00100, WB = 5'b01000;
localparam  DONE = 5'b10000;

reg[5:0] cur_state_ff,next_state;

wire ST_IDLE = cur_state_ff == IDLE;
wire ST_RD_DATA = cur_state_ff == RD_DATA;
wire ST_CAL = cur_state_ff == CAL;
wire ST_WB = cur_state_ff == WB;
wire ST_DONE = cur_state_ff == DONE;

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

//======================
//  flags
//======================
wire rd_done_f = rd_cnt == 1;
wire timed_out_f = done_cnt == 4;
wire write_transaction_success_f = bresp_m_inf==2'b00 & bvalid_m_inf && bready_m_inf;

//===============================
//  AXI FSM
//===============================
localparam AXI_IDLE = 4'b0000;


//==========================================================
//  DESIGN
//==========================================================
//===============================
//  AXI FSM
//===============================


//===============================
//  AXI WRITE TRANSACTION
//===============================
//AW
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        awaddr_m_inf_ff <= 0;
        awvalid_m_inf_ff <= 0;
    end
    else if(ST_IDLE)
    begin
        awaddr_m_inf_ff <= 0;
        awvalid_m_inf_ff <= 0;
    end
    else if(ST_WB)
    begin
        awaddr_m_inf_ff  <= addr_ptr;
        awvalid_m_inf_ff <= 1;
    end
end

//W
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        wdata_m_inf_ff  <= 0;
        wlast_m_inf_ff  <= 0;
        wvalid_m_inf_ff <= 0;
    end
    else if(ST_IDLE)
    begin
        wdata_m_inf_ff  <= 0;
        wlast_m_inf_ff  <= 0;
        wvalid_m_inf_ff <= 0;
    end
    else if(ST_WB)
    begin

    end
end



//B



//===============================
//  AXI READ TRANSACTION
//===============================


//===================
//  MULT FSM
//===================
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
            if(write_transaction_success_f)
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
        if(write_transaction_success_f)
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
assign mult_in_valid = rvalid_m_inf_w && rready_m_inf_w;

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
            a_ff<= rdata_m_inf_w;
        end
        else if(rlast_m_inf_w && mult_in_valid)
        begin
            b_ff<= rdata_m_inf_w;
        end
    end
    else
    begin
        a_ff<= a_ff;
        b_ff<= b_ff;
    end
end







endmodule
