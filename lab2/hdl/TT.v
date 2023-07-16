`define C2Q 0.1
// Revision History
// VERSION      Date          AUTHOR           DESCRIPTION                                                  PERFORMANCE (AREA + CYCLE)
// 1.0          2023/7/13    JackyYEH                                                                           55644 + 21543 = 77097
// 1.1          2023/7/16    JackyYEH       Changing in fifo function                                           56252 + 21531 = 77783
// 2.0          2023/7/16    JackyYEH       Revise from 1.0 Merging Take Vertex state and BFS state             56129 + 16768 = 72897
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
  parameter FIFO_DEPTH      = 14;
  parameter NUM_OF_STATIONS = 16;

  integer i,j;
  //===============================
  //   States
  //===============================
  reg[3:0] currentState, nextState;

  localparam IDLE                     = 4'b0001;
  localparam RD_DATA                  = 4'b0010;
  localparam BFS                      = 4'b0100;
  localparam DONE                     = 4'b1000;

  wire state_IDLE                     = currentState[0];
  wire state_RD_DATA                  = currentState[1];
  wire state_BFS                      = currentState[2];
  wire state_DONE                     = currentState[3];

  //============================
  //  FIFO
  //============================
  reg[4:0] fifo_ptr;
  reg[DATA_WIDTH:0] fifo[0:FIFO_DEPTH-1];

  //============================
  //   WIRE & FFs
  //============================
  wire[DATA_WIDTH-1:0] vertex_from_fifo = fifo[0];

  reg visited_list[0:NUM_OF_STATIONS-1];
  reg adjacency_matrix[0:NUM_OF_STATIONS-1][0:NUM_OF_STATIONS-1];

  reg [DATA_WIDTH:0] dst_ff;

  reg [DATA_WIDTH:0] neighbor_nxt;

  // Note -1 means unreachable
  reg signed[DATA_WIDTH:0] vertexDistances_list[0:NUM_OF_STATIONS-1];

  wire signed[DATA_WIDTH:0] distance_to_vertex = vertexDistances_list[vertex_from_fifo] + $signed(1);

  //================================================================
  //   DESIGN
  //================================================================
  //========================
  //   FLAGS
  //========================
  wire fifo_empty_f             = fifo_ptr == 0 && state_BFS;
  wire fifo_full_f              = fifo_ptr == FIFO_DEPTH-1;
  reg  all_zeroes_f;
  always @(*)
  begin
    all_zeroes_f = 1'b1;

    for(j=0; j<NUM_OF_STATIONS; j=j+1)
    begin
        all_zeroes_f = all_zeroes_f & !adjacency_matrix[vertex_from_fifo][j];
    end
  end

  wire dst_found_f               = neighbor_nxt == dst_ff && state_BFS;
  wire neighbor_traversed_f      = all_zeroes_f && state_BFS;
//   wire  vertex_no_neighbors_f     = all_zeroes_f && state_BFS_TAKE_VERTEX;
  wire neighbor_is_valid_f       =  neighbor_nxt != 17 && adjacency_matrix[vertex_from_fifo][neighbor_nxt] == 1 &&
                                   visited_list[neighbor_nxt] == 0 && state_BFS;

  reg neighbor_not_in_fifo_f;

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
        nextState            = in_valid ? RD_DATA : IDLE;
      end
      RD_DATA :
      begin
        nextState            = in_valid ? RD_DATA : BFS;
      end
      BFS:
      begin
        if(fifo_empty_f)
        begin
            nextState = DONE;
        end
        else if(dst_found_f)
        begin
            nextState = DONE;
        end
        else
        begin
            nextState = BFS;
        end
      end
      DONE:
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
  //   ADJACENCY MATRIX & DST_FF
  //=============================
  always @(posedge clk or negedge rst_n)
  begin:ADJACENCY_MATRIX
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for(i= 0; i < NUM_OF_STATIONS;i=i+1)
        begin
            for(j=0;j<NUM_OF_STATIONS;j=j+1)
            begin
                adjacency_matrix[i][j] <= 1'b0;
            end
        end

        dst_ff <= 16;
    end
    else if(state_IDLE)
    begin
        if(in_valid)
        begin
            dst_ff <= destination;
        end
        else
        begin
            dst_ff <= 16;
        end

        for(i= 0; i < NUM_OF_STATIONS;i=i+1)
        begin
            for(j=0;j<NUM_OF_STATIONS;j=j+1)
            begin
                adjacency_matrix[i][j] <= 1'b0;
            end
        end
    end
    else if(state_RD_DATA && in_valid)
    begin
        // edge to aMatrix
        adjacency_matrix[source][destination] <= 1'b1;
        adjacency_matrix[destination][source] <= 1'b1;
    end
    else if(state_BFS)
    begin
        // Clear the edge after visiting this (neighbor,vertex)
        adjacency_matrix[vertex_from_fifo][neighbor_nxt] <= 1'b0;
        adjacency_matrix[neighbor_nxt][vertex_from_fifo] <= 1'b0;
    end
    else
    begin

    end
  end

  //======================================
  //   Visited List
  //======================================
  always @(posedge clk or negedge rst_n)
  begin:VISITED_LIST
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for(i=0;i<NUM_OF_STATIONS;i=i+1)
        begin
            visited_list[i] <= 1'b0;
        end
    end
    else if(state_IDLE)
    begin
        for(i=0;i<NUM_OF_STATIONS;i=i+1)
        begin
            visited_list[i] <= 1'b0;
        end
    end
    else if(state_BFS)
    begin
        visited_list[vertex_from_fifo] <= 1'b1;
    end
    else
    begin

    end
  end
  //======================================
  //   Distances List
  //======================================

  always @(posedge clk or negedge rst_n)
  begin:DISTANCES_LIST
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for(i=0;i<NUM_OF_STATIONS;i=i+1)
        begin
            vertexDistances_list[i] <= $signed(-'d1);
        end
    end
    else if(state_IDLE)
    begin
        if(in_valid)
        begin
            vertexDistances_list[source] <= 0;
        end
        else
        begin
            for(i=0;i<NUM_OF_STATIONS;i=i+1)
            begin
                vertexDistances_list[i] <= $signed(-'d1);
            end
        end
    end
    else if(state_BFS && neighbor_is_valid_f)
    begin
        if(vertexDistances_list[neighbor_nxt] == $signed(-'d1))
        begin
            vertexDistances_list[neighbor_nxt] <= distance_to_vertex;
        end
        else if(vertexDistances_list[neighbor_nxt] > distance_to_vertex)
        begin
            vertexDistances_list[neighbor_nxt] <= distance_to_vertex;
        end
        else
        begin

        end
    end
    else
    begin

    end
  end

  //======================================
  //   NEIGHBOR NXT
  //======================================
  always @(*)
  begin:NEXT_NEIGHBOR
    neighbor_nxt = 17;
    for(j=0;j<NUM_OF_STATIONS;j=j+1)
    begin
        if(adjacency_matrix[vertex_from_fifo][NUM_OF_STATIONS-j-1] == 1)
        begin
           neighbor_nxt = NUM_OF_STATIONS-j-1;
        end
    end
  end

  //======================================
  //   FIFO & Current Vertex
  //======================================
  always @(*)
  begin:NEIGHBOR_NOT_IN_FIFO
    neighbor_not_in_fifo_f = 1;
    for(i=0;i<FIFO_DEPTH;i=i+1)
    begin
        if(fifo[i] == neighbor_nxt)
        begin
           neighbor_not_in_fifo_f = 0;
        end
    end
  end

  always @(posedge clk or negedge rst_n)
  begin:FIFO
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        fifo_ptr <= 0;
        for(j=0;j<FIFO_DEPTH;j=j+1)
        begin
            fifo[j] <= 18;
        end
    end
    else if(state_IDLE)
    begin

        if(in_valid)
        begin
            fifo_ptr <= fifo_ptr + 1;
            fifo[0]  <= source;
        end
        else
        begin
            fifo_ptr <= 0;
            for(j=0;j<FIFO_DEPTH;j=j+1)
            begin
                fifo[j] <= 18;
            end
        end
    end
    else if(state_BFS && ~fifo_empty_f)
    begin
        if(neighbor_traversed_f)
        begin
            fifo_ptr <= fifo_ptr - 1;
            // Shifting out fifo
            fifo[FIFO_DEPTH-1] <= 18;

            for(j=1;j<FIFO_DEPTH;j=j+1)
            begin
                fifo[j-1] <= fifo[j];
            end
        end
        else if(neighbor_is_valid_f && neighbor_not_in_fifo_f)
        begin
             // Add neighbor only if neighbor is reachable
             // also check if this neighbor is already visited or not
             fifo_ptr       <= fifo_ptr + 1;
             fifo[fifo_ptr] <= neighbor_nxt;
        end
    end
    else
    begin

    end
  end

  //======================================
  //   DONE
  //======================================
  always @(posedge clk or negedge rst_n)
  begin:OUTPUT
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        out_valid <= 1'b0;
        cost      <= 'd0;
    end
    else if(state_IDLE)
    begin
        out_valid <= 1'b0;
        cost      <= 'd0;
    end
    else if(state_DONE)
    begin
        out_valid <= 1'b1;

        if(vertexDistances_list[dst_ff] == $signed(-'d1))
        begin
            cost      <= 0;
        end
        else
        begin
            cost      <= vertexDistances_list[dst_ff];
        end
    end
    else
    begin

    end
  end

endmodule