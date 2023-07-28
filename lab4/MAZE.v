`define C2Q 3.0
// Revision History
// VERSION      Date          AUTHOR           DESCRIPTION                                                  PERFORMANCE (AREA + CYCLE)
// 1.0
module  MAZE(
    input clk,
    input rst_n,
    input in_valid,
    input in,
    output reg[1:0] out,
    output reg out_valid
);
  //===============================
  //   PARAMETER
  //===============================
  parameter FIFO_DEPTH      = 150;
  parameter MAZE_SIZE       = 17;

  localparam RIGHT = 0;
  localparam DOWN  = 1;
  localparam LEFT  = 2;
  localparam UP    = 3;
  localparam NONE  = 4;

  integer i,j,x,y;
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
  reg[8:0] fifo_ptr;
  reg[2:0] fifo[0:FIFO_DEPTH-1];

  //============================
  //   WIRE & FFs
  //============================
  //maze starts at (1,1), ends at (17,17) = (MAZE_SIZE,MAZE_SIZE)
  reg maze[0:MAZE_SIZE+1][0:MAZE_SIZE+1];// This is a padded maze to handle boundary condition
  reg maze_wr[0:MAZE_SIZE+1][0:MAZE_SIZE+1];
  reg[8:0] y_ptr,x_ptr;

  reg[2:0] counts;
  //================================================================
  //   DESIGN
  //================================================================
  //========================
  //   FLAGS
  //========================
  wire fifo_empty_f             = fifo_ptr == 0 && state_DONE;
  wire fifo_full_f              = fifo_ptr == FIFO_DEPTH-1;
  wire maze_rd_done_f           = (x_ptr == 16 && y_ptr == 16) && state_RD_MAZE;

  reg thereIsDeadend_f;
  reg noDeadEnd_f;
  wire dstFound_f = maze[MAZE_SIZE][MAZE_SIZE] == 0 && state_FIND_PATH;


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
  begin:MAZE
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
        for(i= 0; i < MAZE_SIZE+2;i=i+1)
        begin
            for(j=0;j<MAZE_SIZE+2;j=j+1)
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
            for(i= 0; i < MAZE_SIZE+2;i=i+1)
              for(j=0;j<MAZE_SIZE+2;j=j+1)
                  maze[i][j] <= 1'b0;
        end
    end
    else if(state_RD_MAZE && in_valid)
    begin
        maze[y_ptr+1][x_ptr+1]        <= in;
    end
    else if(state_FILL_DEADEND)
    begin
        for(i=0;i<MAZE_SIZE+2;i=i+1)
        begin
            for(j=0;j<MAZE_SIZE+2;j=j+1)
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
  //   x_ptr,y_ptr,fifo
  //======================================
  always @(posedge clk or negedge rst_n)
  begin:PTRS
    //synopsys_translate_off
    # `C2Q;
    //synopsys_translate_on
    if(~rst_n)
    begin
      x_ptr <= 0;
      y_ptr <= 0;

      fifo_ptr <= 0;
      for(j=0;j<FIFO_DEPTH;j=j+1)
      begin
          fifo[j] <= NONE;
      end
    end
    else if(state_IDLE)
    begin
      if(in_valid)
      begin
        x_ptr <= x_ptr + 1;
      end
      else
      begin
        x_ptr <= 0;
        y_ptr <= 0;
      end

      fifo_ptr <= 0;
      for(j=0;j<FIFO_DEPTH;j=j+1)
      begin
          fifo[j] <= NONE;
      end
    end
    else if(state_RD_MAZE)
    begin
      if(in_valid)
      begin
        if(maze_rd_done_f)
        begin
          x_ptr <= 1;
          y_ptr <= 1;
        end
        else if(x_ptr == 16)
        begin
          x_ptr <= 0;
          y_ptr <= y_ptr + 1;
        end
        else
        begin
          x_ptr<=x_ptr+1;
        end
      end
    end
    else if(state_FIND_PATH)
    begin
      if(maze[y_ptr-1][x_ptr] == 1)
      begin
        //UP
        y_ptr <= y_ptr - 1;
        x_ptr <= x_ptr;
        fifo_ptr <= fifo_ptr + 1;
        fifo[fifo_ptr] <= UP;
      end
      else if(maze[y_ptr + 1][x_ptr] == 1)
      begin
        //DOWN
        y_ptr <= y_ptr + 1;
        x_ptr <= x_ptr;
        fifo_ptr <= fifo_ptr + 1;
        fifo[fifo_ptr] <= DOWN;
      end
      else if(maze[y_ptr][x_ptr+1] == 1)
      begin
        //RIGHT
        y_ptr <= y_ptr;
        x_ptr <= x_ptr + 1;
        fifo_ptr <= fifo_ptr + 1;
        fifo[fifo_ptr] <= RIGHT;
      end
      else if(maze[y_ptr][x_ptr-1] == 1)
      begin
        // LEFT
        y_ptr <= y_ptr;
        x_ptr <= x_ptr - 1;
        fifo_ptr <= fifo_ptr + 1;
        fifo[fifo_ptr] <= LEFT;
      end
    end
    else if(state_DONE)
    begin
          fifo_ptr <= fifo_ptr - 1;
          // Shifting out fifo
          fifo[FIFO_DEPTH-1] <= NONE;

          for(j=1;j<FIFO_DEPTH;j=j+1)
          begin
              fifo[j-1] <= fifo[j];
          end
    end
  end


  //======================================
  //   maze_wr & checks if deadends exists
  //======================================
  always @(*)
  begin
    // Initilization
    thereIsDeadend_f = 1'b0;
    noDeadEnd_f = 1'b0;
    counts = 0;
    for ( y= 0; y<MAZE_SIZE+2; y=y+1)
      for( x= 0; x<MAZE_SIZE+2;x=x+1)
        maze_wr[y][x] = maze[y][x];

    for(y=1;y<MAZE_SIZE+1;y=y+1)
    begin
      for(x=1;x<MAZE_SIZE+1;x=x+1)
      begin
          counts = 0;

          //UP
          if(maze[y-1][x] == 0)
            counts = counts + 1;
          //DOWN
          if(maze[y+1][x] == 0)
            counts = counts + 1;
          //RIGHT
          if(maze[y][x+1] == 0)
            counts = counts + 1;
          //LEFT
          if(maze[y][x-1] == 0)
            counts = counts + 1;

          //This (y,x) is a deadend
          if ((counts == 3) && (maze[y][x] != 0) && (y!=1 || x!=1) && (y!=MAZE_SIZE || x!=MAZE_SIZE))
          begin
            thereIsDeadend_f = 1'b1;
            maze_wr[y][x] = 1'b0;
          end
      end
    end

    noDeadEnd_f = ~thereIsDeadend_f;
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
        out       <= 0;
    end
    else if(state_IDLE)
    begin
        out_valid <= 1'b0;
        out       <= 0;
    end
    else if(state_DONE)
    begin
        out_valid <= 1'b1;
        out       <= fifo[0][1:0];
    end
    else
    begin

    end
  end

endmodule