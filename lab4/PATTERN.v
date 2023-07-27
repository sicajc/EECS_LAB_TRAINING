//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   Lab03          : MAZE (MAZE)
//   Author         : Jacky Yeh
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : PATTERN.v
//   Module Name : PATTERN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifdef RTL
    `timescale 1ns/10ps
    `include "MAZE.v"
    `define CYCLE_TIME 7.0
`endif
`ifdef GATE
    `timescale 1ns/10ps
    `include "MAZE_SYN.v"
    `define CYCLE_TIME 7.0
`endif

module PATTERN(
           // Output signals
           clk,
           rst_n,
           in_valid,
           in,
           // Input signals
           out_valid,
           out
       );
//================================================================
//  INPUT AND OUTPUT DECLARATION
//================================================================
output reg clk, rst_n, in_valid;
output reg in;
input out_valid;
input [1:0] out;
//================================================================
//  parameters & integer
//================================================================
integer a,b, c, i,j, gap, pat_input_file,pat_golden_out_file;
integer PATNUM;
integer MAZE_SIZE = 17;
integer golden_checked_flag;
integer total_cycles;
integer total_pat;
integer patcount;
integer cycles;
integer color_stage = 0, color, r = 5, g = 0, b = 0;
string golden_ans;
//================================================================
//  wire & registers
//================================================================
reg [1:0] golden_out;
//================================================================
//  clock
//================================================================
always  #(`CYCLE_TIME/2.0)  clk = ~clk ;
initial
    clk = 0 ;
//================================================================
//  initial
//================================================================
initial
begin
    pat_input_file      = $fopen("C:/Users/HIBIKI/Desktop/EECS_LAB_TRAINING/lab4/pattern/input.txt", "r");
    pat_golden_out_file = $fopen("C:/Users/HIBIKI/Desktop/EECS_LAB_TRAINING/lab4/pattern/output.txt", "r");

    a = $fscanf(pat_input_file, "NUM_OF_PAT: %d\n\n", PATNUM);

    //Initialize signals
    in_valid = 0 ;
    in = 1'bx ;
    rst_n = 1 ;
    total_cycles = 0 ;
    total_pat = 0 ;

    //Forcing the clk
    reset_task;

    @(negedge clk);
    for( patcount=0 ; patcount<PATNUM ; patcount=patcount+1 )
    begin
        // $display("maze_task");
        maze_task;
        total_pat = total_pat + 1 ;
        // $display("wait_outvalid");
        wait_outvalid;
        // $display("check_ans");
        check_ans;
        delay_task;
        case(color_stage)
            0:
            begin
                r = r - 1;
                g = g + 1;
                if(r == 0)
                    color_stage = 1;
            end
            1:
            begin
                g = g - 1;
                b = b + 1;
                if(g == 0)
                    color_stage = 2;
            end
            2:
            begin
                b = b - 1;
                r = r + 1;
                if(b == 0)
                    color_stage = 0;
            end
        endcase
        color = 16 + r*36 + g*6 + b;
        if(color < 100)
            $display("\033[38;5;%2dmPASS PATTERN NO.%4d\033[00m", color, patcount+1);
        else
            $display("\033[38;5;%3dmPASS PATTERN NO.%4d\033[00m", color, patcount+1);
    end
    #(1000);
    YOU_PASS_task;
    $finish;
end
//================================================================
//  task
//================================================================
//================================================================
//  answer task
//================================================================
task check_ans ;
    begin
        if (out_valid===1)
        begin
            // Another method is using fscanf to detect the char E
            // Do string processing to check for end of line in the string
            // c = $fgets(golden_ans,pat_input_file);
            // $display("String read in:\n",c);
            // $display("%s",c);
            // $display("Length of string: ",$size(c));
            c = $fscanf(pat_input_file,"%d",golden_out);
            golden_checked_flag = 0;

            // If out valid if high
            while(out_valid===1)
            begin
                if(golden_out == "E")
                begin
                    golden_checked_flag = 1;
                    break;
                end

                golden_out = golden_ans[j];

                if (out!==golden_out)
                begin
                    fail;
                    // Spec. 7
                    // When out_valid is pulled up and there exists a solution for the grid, out should be correct, and out_valid is limited to be high for 15 cycles.
                    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                SPEC 7 FAIL!                                                                ");
                    $display ("                                            The out should be Correct when out valid is high                                                ");
                    $display ("                                            Your output of %d moves is: %d , Golden_ans : %d                                                ",j,out,golden_out);
                    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                    repeat(5)  @(negedge clk);
                    $finish;
                end

                j=j+1;
                @(negedge clk);
            end
        end

        if(golden_checked_flag == 0)
        begin
            fail;
            // Spec. 7
            // When out_valid is pulled up and there exists a solution for the grid, out should be correct, and out_valid is limited to be high for 15 cycles.
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display ("                                                                SPEC 7 FAIL!                                                                ");
            $display ("                                            The out should be Correct when out valid is high                                                ");
            $display ("                                                 There are still more Answers to check                                                      ");
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            repeat(5)  @(negedge clk);
            $finish;
        end
    end
endtask

task wait_outvalid;
    begin
        cycles = 0 ;
        while( out_valid!==1 )
        begin
            cycles = cycles + 1 ;
            if (out!==0)
            begin
                fail;
                // Spec. 4
                // The out should be reset whenever your out_valid isn’t high.
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                $display ("                                                                SPEC 4 FAIL!                                                                ");
                $display ("                                 The out should be set to 0 after the reset signal is asserted                                              ");
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                repeat(5)  @(negedge clk);
                $finish;
            end
            if (cycles==3000)
            begin
                fail;
                // Spec. 6
                // The execution latency is limited in 300 cycles.
                // The latency is the clock cycles between the falling edge of the last cycle of in_valid and the rising edge of the out_valid.
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                $display ("                                                                SPEC 6 FAIL!                                                                ");
                $display ("                                              The execution latency is limited in 3000 cycles                                               ");
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                repeat(5)  @(negedge clk);
                $finish;
            end
            @(negedge clk);
        end
        total_cycles = total_cycles + cycles ;
    end
endtask
//================================================================
//  input task
//================================================================
task maze_task ;
    begin
        in_valid = 1 ;
        for( i=0 ; i< MAZE_SIZE; i=i+1 )
        begin
            for(j = 0; j < MAZE_SIZE ; j=j+1)
            begin
                if (out!==0)
                begin
                    fail;
                    // Spec. 4
                    // The out should be set to 0 whenever your out_valid isn’t high.
                    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                SPEC 4 FAIL!                                                                ");
                    $display ("                                     The out should be set to 0 whenever your out_valid isn’t high                                          ");
                    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                    repeat(5)  @(negedge clk);
                    $finish;
                end
                if (out_valid===1)
                begin
                    fail;
                    // Spec. 5
                    // The out_valid should not be high when in_valid is high.
                    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                SPEC 5 FAIL!                                                                ");
                    $display ("                                         The out_valid should not be high when in_valid is high                                             ");
                    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                    repeat(5)  @(negedge clk);
                    $finish;
                end
                //Feed value in at negedge
                a = $fscanf(pat_input_file, "PATTERN NO: 0\n");
                a = $fscanf(pat_input_file, "%d ", in);
                @(negedge clk);
            end
            a = $fscanf(pat_input_file,"\n");
        end
        in_valid = 0 ;
        in = 1'bx ;
    end
endtask
//================================================================
//  env task
//================================================================
task reset_task ;
    begin
        force clk = 0 ;
        #(0.5);
        rst_n = 0 ;
        #(2.0);
        if ((out_valid!==0)||(out!==0))
        begin
            fail;
            // Spec. 3
            // The reset signal (rst_n) would be given only once at the beginning of simulation.
            // All output signals should be reset after the reset signal is asserted.
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display ("                                                                SPEC 3 FAIL!                                                                ");
            $display ("                                     All output signals should be reset after the reset signal is asserted at %4d ps                        ",$time*1000);
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");

            #(100);
            $finish;
        end
        #(1.0);
        rst_n = 1 ;
        #(3.0);
        release clk;
    end
endtask

task delay_task ;
    begin
        gap =  $urandom(SEED) % 3 + 2;
        repeat(gap) @(negedge clk);
    end
endtask
//================================================================
//  pass/fail task
//================================================================
task YOU_PASS_task;
    begin
        // image_.success;
        $display ("----------------------------------------------------------------------------------------------------------------------");
        $display ("                                                  Congratulations!                                                    ");
        $display ("                                           You have passed all patterns!                                              ");
        $display ("                                                                                                                      ");
        $display ("                                        Your execution cycles   = %5d cycles                                          ", total_cycles);
        $display ("                                        Your clock period       = %.1f ns                                             ", `CYCLE_TIME);
        $display ("                                        Total latency           = %.1f ns                                             ", (total_cycles + total_pat)*`CYCLE_TIME);
        $display ("----------------------------------------------------------------------------------------------------------------------");

        $finish;
    end
endtask

task fail;
    begin
        $display(":( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL :( FAIL        ");
    end
endtask
endmodule
