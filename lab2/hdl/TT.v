module  TT(
    input clk,
    input rst_n,
    input in_valid,
    input[3:0] source,
    input[3:0] destination,
    output reg out_valid,
    output reg[3:0] cost
);

  //===============================
  //   PARAMETER
  //===============================
  parameter DATA_WIDTH      = 4;
  parameter FIFO_WIDTH      = 12;
  parameter NUM_OF_STATIONS = 16;

  integer idx,depth;
  integer i,j;
  //===============================
  //   States
  //===============================
  reg[3:0] currentState, nextState;

  localparam IDLE         = 4'b0001;
  localparam RD_DATA      = 4'b0010;
  localparam BFS          = 4'b0100;
  localparam DONE         = 4'b1000;

  wire state_IDLE         = currentState[0];
  wire state_RD_DATA      = currentState[1];
  wire state_BFS          = currentState[2];
  wire state_DONE         = currentState[3];

  //============================
  //  FIFO
  //============================
  reg[5:0] fifo_ptr;
  reg[DATA_WIDTH-1:0] shifting_queue[0:FIFO_WIDTH-1];

  //============================
  //   WIRE & FFs
  //============================
  wire[DATA_WIDTH-1:0] vertex_queue;

  reg visited_list[0:NUM_OF_STATIONS];
  reg adjacency_matrix[0:NUM_OF_STATIONS][0:NUM_OF_STATIONS];

  reg [DATA_WIDTH-1:0:0] dst_ff;
  reg [DATA_WIDTH-1:0] v1,v2;

  signed wire[DATA_WIDTH:0] distance_to_vertex;
  signed reg[DATA_WIDTH-1:0] vertexDistances_list[0:NUM_OF_STATIONS-1];
  //================================================================
  //   DESIGN
  //================================================================
  //========================
  //   FLAGS
  //========================
  reg first_data_ff_flag;


  wire queue_empty_f = fifo_ptr == 0 && state_BFS;
  wire dst_found_f   = vertex_queue == dst_ff;
  reg  check_in_queue_f;
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
      currentState <= RD_DATA;
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
        nextState            = RD_DATA;
      end
      RD_DATA :
      begin
        nextState            = !in_valid ? BFS : RD_DATA;
      end
      BFS :
      begin
        nextState            = queue_empty_f ? DONE : (dst_found_f ? DONE: BFS);
      end
      DONE :
      begin
        nextState            = IDLE;
      end
      default :
      begin
        nextState            = IDLE;
      end
    endcase
  end

  //=============================
  //   ADJACENCY MATRIX
  //=============================
  always @(posedge clk or negedge rst_n)
  begin: ADJACENCY_MATRIX
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(rst_n)
    begin
        for(i= 0; i < NUM_OF_STATIONS;i=i+1)
        begin
            for(j=0;j<NUM_OF_STATIONS;j=j+1)
            begin
                adjacency_matrix[i][j] <= 1'b0;
            end
        end
    end
    else if(state_RD_DATA && in_valid && ~first_data_ff_flag)
    begin
        // edge to aMatrix
        adjacency_matrix[source][destination] <= 1'b1;
        adjacency_matrix[destination][source] <= 1'b1;
    end
    else
    begin
        ;
    end
  end

  //======================================
  //    Distances List and Visted List
  //======================================
  always @(posedge clk or negedge rst_n)
  begin
    if(~rst_n)
    begin
        for(i=0;i<NUM_OF_STATIONS;i=i+1)
        begin
            vertexDistances_list[i] <= -'d1;
            visited_list[i] <= 1'b1
        end
    end
    else
    begin

    end
  end

endmodule