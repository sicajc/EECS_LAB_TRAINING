// -----------------------------------------------------------------------------
// Revision History
// VERSION      Date          AUTHOR           DESCRIPTION      PERFORMANCE (AREA)
// 1.0          2023/7/6    JackyYEH                       25846
// 1.1          2023/7/6    JackyYEH                       25779
// 2.0          2023/7/7    JackyYEH                       24728


module CC(

           input[3:0] in_n0,
           input[3:0] in_n1,
           input[3:0] in_n2,
           input[3:0] in_n3,
           input[3:0] in_n4,
           input[3:0] in_n5,
           input[2:0] opt,
           input equ,
           output[9:0] out_n
       );

//===============================
//   PARAMETERS & GENVARS
//===============================
parameter SORTERS_WIDTH        = 5;
parameter NORM_AND_SHIFT_WIDTH = 5;
parameter EQ_WIDTH             = 10;
parameter NUM_OF_ELEMENT       = 6;

integer i;
genvar idx,j,k;

//===============================
//   wires and regs
//===============================
reg signed[SORTERS_WIDTH-1:0] sign_ex_values[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] sorted_results[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] ascend_or_descend[0:NUM_OF_ELEMENT-1];

reg signed[NORM_AND_SHIFT_WIDTH-1:0] normalised_result[0:NUM_OF_ELEMENT-1];

reg signed[EQ_WIDTH-1:0] equation_result;

//===============================
//   DESIGN
//===============================
// Sign extension
always @(*)
begin
    if(opt[0]==1'b1)
    begin
        sign_ex_values[0] = $signed({in_n0[3],in_n0});
        sign_ex_values[1] = $signed({in_n1[3],in_n1});
        sign_ex_values[2] = $signed({in_n2[3],in_n2});
        sign_ex_values[3] = $signed({in_n3[3],in_n3});
        sign_ex_values[4] = $signed({in_n4[3],in_n4});
        sign_ex_values[5] = $signed({in_n5[3],in_n5});
    end
    else
    begin
        sign_ex_values[0] = $signed({1'b0,in_n0});
        sign_ex_values[1] = $signed({1'b0,in_n1});
        sign_ex_values[2] = $signed({1'b0,in_n2});
        sign_ex_values[3] = $signed({1'b0,in_n3});
        sign_ex_values[4] = $signed({1'b0,in_n4});
        sign_ex_values[5] = $signed({1'b0,in_n5});
    end
end


//bitonic sorter
reg signed[SORTERS_WIDTH-1:0] stage_zero[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_one[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_two[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_three[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_four[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_five[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_six[0:NUM_OF_ELEMENT-1];
reg signed[SORTERS_WIDTH-1:0] stage_seven[0:NUM_OF_ELEMENT-1];

always @(*)
begin: BITONIC_SORT
    // Initilize value for all the variables
    // stage 0
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_zero[i]   = sign_ex_values[i];
    end

    stage_zero[1] = (sign_ex_values[1]>sign_ex_values[2]) ? sign_ex_values[1]:
              sign_ex_values[2];

    stage_zero[2] = (sign_ex_values[1]>sign_ex_values[2]) ? sign_ex_values[2]:
              sign_ex_values[1];

    stage_zero[4] = (sign_ex_values[4]>sign_ex_values[5]) ? sign_ex_values[5]:
              sign_ex_values[4];

    stage_zero[5] = (sign_ex_values[4]>sign_ex_values[5]) ? sign_ex_values[4]:
              sign_ex_values[5];

    //stage 1
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_one[i]   = stage_zero[i];
    end

    stage_one[0] = (stage_zero[0]>stage_zero[2]) ? stage_zero[0]:
             stage_zero[2];

    stage_one[2] = (stage_zero[0]>stage_zero[2]) ? stage_zero[2]:
             stage_zero[0];

    stage_one[3] = (stage_zero[3]>stage_zero[5]) ? stage_zero[5]:
             stage_zero[3];

    stage_one[5] = (stage_zero[3]>stage_zero[5]) ? stage_zero[3]:
             stage_zero[5];

    //stage 2
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_two[i]   = stage_one[i];
    end

    stage_two[0] = (stage_one[0]>stage_one[1]) ? stage_one[0]:
             stage_one[1];

    stage_two[1] = (stage_one[0]>stage_one[1]) ? stage_one[1]:
             stage_one[0];

    stage_two[3] = (stage_one[3]>stage_one[4]) ? stage_one[4]:
             stage_one[3];

    stage_two[4] = (stage_one[3]>stage_one[4]) ? stage_one[3]:
             stage_one[4];

    //stage 3
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_three[i]   = stage_two[i];
    end

    stage_three[0] = (stage_two[0]>stage_two[4]) ? stage_two[4]:
               stage_two[0];

    stage_three[4] = (stage_two[0]>stage_two[4]) ? stage_two[0]:
               stage_two[4];
    //stage 4
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_four[i]   = stage_three[i];
    end

    stage_four[1] = (stage_three[1]>stage_three[5]) ? stage_three[5]:
              stage_three[1];

    stage_four[5] = (stage_three[1]>stage_three[5]) ? stage_three[1]:
              stage_three[5];

    //stage 5
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_five[i]   = stage_four[i];
    end

    stage_five[0] = (stage_four[0]>stage_four[2]) ? stage_four[2]:
              stage_four[0];

    stage_five[2] = (stage_four[0]>stage_four[2]) ? stage_four[0]:
              stage_four[2];

    //stage 6
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_six[i]   = stage_five[i];
    end

    stage_six[1] = (stage_five[1]>stage_five[3]) ? stage_five[3]:
             stage_five[1];

    stage_six[3] = (stage_five[1]>stage_five[3]) ? stage_five[1]:
             stage_five[3];

    // stage 7
    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        stage_seven[i]   = stage_five[i];
    end

    stage_seven[0] = (stage_six[0]>stage_six[1]) ? stage_six[1]:
               stage_six[0];

    stage_seven[1] = (stage_six[0]>stage_six[1]) ? stage_six[0]:
               stage_six[1];

    stage_seven[2] = (stage_six[2]>stage_six[3]) ? stage_six[3]:
               stage_six[2];

    stage_seven[3] = (stage_six[2]>stage_six[3]) ? stage_six[2]:
               stage_six[3];

    stage_seven[4] = (stage_six[4]>stage_six[5]) ? stage_six[5]:
               stage_six[4];

    stage_seven[5] = (stage_six[4]>stage_six[5]) ? stage_six[4]:
               stage_six[5];

    for(i=0;i<NUM_OF_ELEMENT;i=i+1)
    begin
        sorted_results[i] = stage_seven[i];
    end
end


//Ascend or descend of the sorted results
generate
    for(idx=0;idx<NUM_OF_ELEMENT;idx=idx+1)
    begin: ASCEND_DESCEND
        always @(*)
        begin
            if(opt[1] == 1'b0)
            begin
                ascend_or_descend[idx] = sorted_results[idx];
            end
            else
            begin
                ascend_or_descend[idx] = sorted_results[5-idx];
            end
        end
    end
endgenerate

reg signed[NORM_AND_SHIFT_WIDTH-1:0] normalised_temp[0:NUM_OF_ELEMENT-1];
//Cumulation and Shifter
always @(*)
begin:CUMULATION_SHIFT
    if(opt[2] == 1'b1)
    begin
        // Initilization
        // for(i=0;i<NUM_OF_ELEMENT;i=i+1)
        // begin
        //     normalised_result[i] = $signed(0);
        // end

        // i = 0
        normalised_result[0] = ascend_or_descend[0];

        for(i=1;i<NUM_OF_ELEMENT;i=i+1)
        begin
            normalised_result[i] = (normalised_result[i-1] * $signed(2) + ascend_or_descend[i])/$signed(3);
        end
    end
    else
    begin
        normalised_result[0] = 'd0;

        //Shifter
        for(i=1;i<NUM_OF_ELEMENT;i=i+1)
        begin
            normalised_result[i] = ascend_or_descend[i] - ascend_or_descend[0];
        end
    end
end

reg signed[7:0] add1_temp;
reg signed[12:0] mult1;

//eq
always @(*)
begin:EQU
    equation_result = 0;

    if(equ == 1'b1)
    begin
        add1_temp = (normalised_result[1] - normalised_result[0]);
        mult1 = normalised_result[5] * add1_temp;

        // Absolute value
        if(mult1 >= $signed(0))
        begin
            equation_result = mult1;
        end
        else
        begin
            equation_result = ~mult1 + 1;
        end
    end
    else
    begin
        add1_temp = normalised_result[3] + normalised_result[4] * $signed(4);
        mult1 = normalised_result[5] * add1_temp;
        equation_result = mult1 / $signed(3);
    end
end

assign out_n = equation_result;

endmodule
