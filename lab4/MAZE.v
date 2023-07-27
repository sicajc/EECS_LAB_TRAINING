`define C2Q 3.0
// Revision History
// VERSION      Date          AUTHOR           DESCRIPTION                                                  PERFORMANCE (AREA + CYCLE)
// 1.0
module  TT(
    input clk,
    input rst_n,
    input in_valid,
    input in,
    output[1:0] out,
    output reg out_valid
);
  //===============================
  //   PARAMETER
  //===============================
  parameter FIFO_DEPTH      = 32;
  parameter MAZE_SIZE       = 17;

  integer i,j;
  //===============================
  //   States
  //===============================
  reg[4:0] currentState, nextState;

  localparam IDLE                     = 5'b00001;
  localparam RD_MAZE                  = 5'b00010;
  localparam FILL_DEADEND             = 5'b00100;
  localparam FIND_PATH                = 5'b01000;
  localparam DONE                     = 5'b10000;

  wire state_IDLE                              = currentState[0];
  wire state_RD_MAZE                           = currentState[1];
  wire state_FILL_DEADEND                      = currentState[2];
  wire state_FIND_PATH                         = currentState[3];
  wire state_DONE                              = currentState[4];

  //============================
  //  FIFO
  //============================
  reg[$clog(FIFO_DEPTH):0] fifo_ptr;
  reg[DATA_WIDTH:0] fifo[0:FIFO_DEPTH-1];

  //============================
  //   WIRE & FFs
  //============================
  //maze starts at (1,1), ends at (17,17) = (MAZE_SIZE,MAZE_SIZE)
  reg maze[0:MAZE_SIZE+1][0:MAZE_SIZE+1];
  reg maze_wr[0:MAZE_SIZE+1][0:MAZE_SIZE+1];
  reg[8:0] cnt;
  reg[8:0] y_ptr,x_ptr;

  //================================================================
  //   DESIGN
  //================================================================
  //========================
  //   FLAGS
  //========================
  wire fifo_empty_f             = fifo_ptr == 0 && state_DONE;
  wire fifo_full_f              = fifo_ptr == FIFO_DEPTH-1;
  wire maze_rd_done_f           = cnt == 288 && state_RD_MAZE;

  reg thereIsDeadend_f;
  reg noDeadEnd_f = ~thereIsDeadend_f;
  wire dstFound_f = maze[MAZE_SIZE][MAZE_SIZE] == 0 && state_FIND_PATH;

  reg[2:0] counts;

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
        nextState            = in_valid ? RD_MAZE : IDLE;
      end
      RD_MAZE :
      begin
        nextState            = maze_rd_done_f ? FILL_DEADEND : RD_MAZE;
      end
      FILL_DEADEND:
      begin
        nextState            = noDeadEnd_f ? FIND_PATH : FILL_DEADEND;
      end
      FIND_PATH:
      begin
        nextState            = dstFound_f  ? DONE : FIND_PATH;
      end
      DONE:
      begin
        nextState            = fifo_empty_f ? IDLE : DONE;
      end
      default :
      begin
        nextState            = IDLE;
      end
    endcase
  end

  //=============================
  //   MAZE
  //=============================
  always @(posedge clk or negedge rst_n)
  begin:maze
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for(i= 0; i < MAZE_SIZE;i=i+1)
        begin
            for(j=0;j<MAZE_SIZE;j=j+1)
            begin
                maze[i][j] <= 1'b0;
            end
        end
    end
    else if(state_IDLE)
    begin
        if(in_valid)
        begin
            maze[1][1] <= 1'b1;
        end
        else
        begin
            for(i= 0; i < MAZE_SIZE;i=i+1)
            begin
                for(j=0;j<MAZE_SIZE;j=j+1)
                begin
                    maze[i][j] <= 1'b0;
                end
            end
        end
    end
    else if(state_RD_MAZE && in_valid)
    begin
        // edge to aMatrix
        maze[y][x]        <= in;
    end
    else if(state_FILL_DEADEND)
    begin
        for(i=0;i<MAZE_SIZE;i=i+1)
        begin
            for(j=0;j<MAZE_SIZE;j=j+1)
                begin
                    maze[i][j] <= maze_wr[i][j];
                end
        end
    end
    else if(state_FIND_PATH)
    begin
        maze[y_ptr][x_ptr] <= 1'b0;
    end
  end


  //======================================
  //   NEIGHBOR NXT
  //======================================
  always @(*)
  begin:NEXT_NEIGHBOR
    neighbor_nxt = 17;
    for(j=0;j<MAZE_SIZE;j=j+1)
    begin
        if(maze[vertex_from_fifo][MAZE_SIZE-j-1] == 1)
        begin
           neighbor_nxt = MAZE_SIZE-j-1;
        end
    end
  end

  //======================================
  //   OUTPUT FIFO
  //======================================
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
            fifo_ptr <= 0;
            for(j=0;j<FIFO_DEPTH;j=j+1)
            begin
                fifo[j] <= 18;
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
    end
    else if(state_IDLE)
    begin
        out_valid <= 1'b0;
    end
    else if(state_DONE)
    begin
        out_valid <= 1'b1;
    end
    else
    begin

    end
  end

endmodule