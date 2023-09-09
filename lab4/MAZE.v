// Revision History
// VERSION      Date          AUTHOR           DESCRIPTION                                                  PERFORMANCE (AREA + CYCLE)
// 1.0       CYCLES = 28897 , AREA =
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

localparam IDLE                     = 4'b0001;
localparam RD_MAZE                  = 4'b0010;
localparam FILL_DEADEND             = 4'b0100;
localparam OUTPUT                   = 4'b1000;

wire state_IDLE                              = currentState[0];
wire state_RD_MAZE                           = currentState[1];
wire state_FILL_DEADEND                      = currentState[2];
wire state_OUTPUT                            = currentState[3];

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
wire maze_rd_done_f           = (x_ptr == 17 && y_ptr == 17) && state_RD_MAZE;
reg thereIsDeadend_f;
reg noDeadEnd_f;
wire dstFound_f = x_ptr == MAZE_SIZE && y_ptr == MAZE_SIZE && state_OUTPUT;

//========================
//   FSM
//========================
always @(posedge clk or negedge rst_n)
begin:CUR_STATE
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
            nextState            = noDeadEnd_f ? OUTPUT : FILL_DEADEND;
        end
        OUTPUT:
        begin
            nextState            = dstFound_f ? IDLE : OUTPUT;
        end
        default :
        begin
            nextState            = IDLE;
        end
    endcase
end

//=============================
//   DATAPATH
//=============================
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        for(i= 0; i < MAZE_SIZE+2;i=i+1)
            for(j=0;j<MAZE_SIZE+2;j=j+1)
                maze[i][j] <= 1'b0;

        x_ptr     <= 1;
        y_ptr     <= 1;
        out       <= 0;
        out_valid <= 0;
    end
    else
    begin
        case(currentState)
            IDLE:
            begin
                if(in_valid)
                begin
                    maze[1][1] <= 1;
                    x_ptr <= 2;
                end
                else
                begin
                    for(i= 0; i < MAZE_SIZE+2;i=i+1)
                        for(j=0;j<MAZE_SIZE+2;j=j+1)
                            maze[i][j] <= 1'b0;
                end

                y_ptr <= 1;
                out       <= 0;
                out_valid <= 0;
            end
            RD_MAZE:
            begin
                if(maze_rd_done_f)
                begin
                    maze[y_ptr][x_ptr] <= in;
                    x_ptr <= 1;
                    y_ptr <= 1;
                end
                else if(in_valid)
                begin
                    maze[y_ptr][x_ptr] <= in;

                    if(x_ptr == 17)
                    begin
                        y_ptr <= y_ptr + 1;
                        x_ptr <= 1;
                    end
                    else
                    begin
                        x_ptr <= x_ptr + 1;
                    end
                end
            end
            FILL_DEADEND:
            begin
                for(i=0;i<MAZE_SIZE+2;i=i+1)
                    for(j=0;j<MAZE_SIZE+2;j=j+1)
                        maze[i][j] <= maze_wr[i][j];
            end
            OUTPUT:
            begin
                maze[y_ptr][x_ptr] <= 0;

                if(dstFound_f)
                begin
                    out<=0;
                    out_valid<=0;
                end
                else
                begin
                    out_valid <= 1;

                    if(maze[y_ptr-1][x_ptr] == 1)
                    begin
                        //UP
                        y_ptr <= y_ptr - 1;
                        x_ptr <= x_ptr;
                        out <= UP;
                    end
                    else if(maze[y_ptr + 1][x_ptr] == 1)
                    begin
                        //DOWN
                        y_ptr <= y_ptr + 1;
                        x_ptr <= x_ptr;
                        out <= DOWN;
                    end
                    else if(maze[y_ptr][x_ptr+1] == 1)
                    begin
                        //RIGHT
                        y_ptr <= y_ptr;
                        x_ptr <= x_ptr + 1;
                        out <= RIGHT;
                    end
                    else if(maze[y_ptr][x_ptr-1] == 1)
                    begin
                        // LEFT
                        y_ptr <= y_ptr;
                        x_ptr <= x_ptr - 1;
                        out <= LEFT;
                    end
                end
            end

        endcase
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

    //DeadEnd filling
    for(y=1;y<MAZE_SIZE+1;y=y+1)
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
            if (((counts == 3) || (counts == 4)) && (maze[y][x] != 0) &&
                    (y!=1 || x!=1) && (y!=MAZE_SIZE || x!=MAZE_SIZE))
            begin
                thereIsDeadend_f = 1'b1;
                maze_wr[y][x] = 1'b0;
            end
        end

    noDeadEnd_f = ~thereIsDeadend_f;
end

endmodule
