`define CYCLE_TIME 20
module axi_write_channel_tb;
//================================================================
//  PARAMETER
//================================================================
//  axi
parameter ID_WIDTH = 4 ,ADDR_WIDTH = 32, DATA_WIDTH = 32,
          DRAM_NUMBER = 1, WRIT_NUMBER = 1 ;
//================================================================
//  clock
//================================================================
reg clk,rst_n;

initial
    clk = 0;

always  #(`CYCLE_TIME/2.0)  clk = ~clk ;


initial
begin
    rst_n = 1;

    #10 rst_n = 0;

    # 10 rst_n = 1;
end

axi_write_channel
    #(
        .ID_WIDTH      (ID_WIDTH      ),
        .ADDR_WIDTH    (ADDR_WIDTH    ),
        .DATA_WIDTH    (DATA_WIDTH    ),
        .DRAM_NUMBER   (DRAM_NUMBER   ),
        .WRIT_NUMBER   (WRIT_NUMBER   )
    )
    u_axi_write_channel(
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .write_op           (0),
        .awid_m_inf         (),
        .awaddr_m_inf       (),
        .awsize_m_inf       (),
        .awburst_m_inf      (),
        .awlen_m_inf        (),
        .awvalid_m_inf      (),
        .awready_s_inf      (),
        .wdata_m_inf        (),
        .wlast_m_inf        (),
        .wvalid_m_inf       (),
        .wready_s_inf       (),
        .bid_s_inf          (0),
        .bresp_s_inf        (),
        .bvalid_s_inf       (),
        .bready_m_inf       (),
        .i_awid_m_inf_wr    (  0  ),
        .i_awaddr_m_inf_wr  (  0),
        .i_awsize_m_inf_wr  (  0),
        .i_awburst_m_inf_wr ( 0),
        .i_awlen_m_inf_wr   ( 0  ),
        .i_awvalid_m_inf_wr ( 0),
        .o_awready_s_inf_wr ( ),
        .i_wdata_m_inf_wr   ( 0  ),
        .i_wlast_m_inf_wr   ( 0  ),
        .i_wvalid_m_inf_wr  ( 0 ),
        .o_wready_s_inf_wr  (  ),
        .o_bid_s_inf_wr     (     ),
        .o_bresp_s_inf_wr   (  ),
        .o_bvalid_s_inf_wr  (  ),
        .i_bready_m_inf_wr  ( 0 )
    );










endmodule
