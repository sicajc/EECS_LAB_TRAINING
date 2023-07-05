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
  parameter NORM_AND_SHIFT_WIDTH = 6;
  parameter EQ_WIDTH             = 10;
  parameter NUM_OF_ELEMENT       = 6;

  integer i;
  genvar idx,j,k;

  //===============================
  //   wires and regs
  //===============================
  reg signed[SORTERS_WIDTH-1:0] sign_ex_values[0:NUM_OF_ELEMENT];
  reg signed[SORTERS_WIDTH-1:0] sorted_results[0:NUM_OF_ELEMENT];
  reg signed[SORTERS_WIDTH-1:0] ascend_or_descend[0:NUM_OF_ELEMENT];

  reg signed[NORM_AND_SHIFT_WIDTH-1:0] cu_normalised[0:NUM_OF_ELEMENT];

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
        sign_ex_values[1] = $signed({in_n0[3],in_n1});
        sign_ex_values[2] = $signed({in_n0[3],in_n2});
        sign_ex_values[3] = $signed({in_n0[3],in_n3});
        sign_ex_values[4] = $signed({in_n0[3],in_n4});
        sign_ex_values[5] = $signed({in_n0[3],in_n5});
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
  always @(*)
  begin: BITONIC_SORT
     // Initilize value
     for(i=0;i<NUM_OF_ELEMENT;i=i+1)
     begin
        sorted_results[i] = sign_ex_values[i];
     end

     // stage 0
     sorted_results[1] = (sorted_results[1]>sorted_results[2]) ? sorted_results[1]:
     sorted_results[2];

     sorted_results[2] = (sorted_results[1]>sorted_results[2]) ? sorted_results[2]:
     sorted_results[1];

     sorted_results[4] = (sorted_results[4]>sorted_results[5]) ? sorted_results[5]:
     sorted_results[4];

     sorted_results[5] = (sorted_results[4]>sorted_results[5]) ? sorted_results[4]:
     sorted_results[5];

     //stage 1
     sorted_results[0] = (sorted_results[0]>sorted_results[2]) ? sorted_results[0]:
     sorted_results[2];

     sorted_results[2] = (sorted_results[0]>sorted_results[2]) ? sorted_results[2]:
     sorted_results[0];

     sorted_results[3] = (sorted_results[3]>sorted_results[5]) ? sorted_results[5]:
     sorted_results[3];

     sorted_results[5] = (sorted_results[3]>sorted_results[5]) ? sorted_results[3]:
     sorted_results[5];

     //stage 2
     sorted_results[0] = (sorted_results[0]>sorted_results[1]) ? sorted_results[0]:
     sorted_results[1];

     sorted_results[1] = (sorted_results[0]>sorted_results[1]) ? sorted_results[1]:
     sorted_results[0];

     sorted_results[3] = (sorted_results[3]>sorted_results[4]) ? sorted_results[4]:
     sorted_results[3];

     sorted_results[4] = (sorted_results[3]>sorted_results[4]) ? sorted_results[3]:
     sorted_results[4];

     //stage 3
     sorted_results[0] = (sorted_results[0]>sorted_results[4]) ? sorted_results[4]:
     sorted_results[0];

     sorted_results[4] = (sorted_results[0]>sorted_results[4]) ? sorted_results[0]:
     sorted_results[4];
     //stage 4
     sorted_results[1] = (sorted_results[1]>sorted_results[5]) ? sorted_results[5]:
     sorted_results[1];

     sorted_results[5] = (sorted_results[1]>sorted_results[5]) ? sorted_results[1]:
     sorted_results[5];

     //stage 5
     sorted_results[0] = (sorted_results[0]>sorted_results[2]) ? sorted_results[2]:
     sorted_results[0];

     sorted_results[2] = (sorted_results[0]>sorted_results[2]) ? sorted_results[0]:
     sorted_results[2];

     //stage 6
     sorted_results[1] = (sorted_results[1]>sorted_results[3]) ? sorted_results[3]:
     sorted_results[1];

     sorted_results[3] = (sorted_results[1]>sorted_results[3]) ? sorted_results[1]:
     sorted_results[3];

     // stage 7
     sorted_results[0] = (sorted_results[0]>sorted_results[1]) ? sorted_results[1]:
     sorted_results[0];

     sorted_results[1] = (sorted_results[0]>sorted_results[1]) ? sorted_results[0]:
     sorted_results[1];

     sorted_results[2] = (sorted_results[2]>sorted_results[3]) ? sorted_results[3]:
     sorted_results[2];

     sorted_results[3] = (sorted_results[2]>sorted_results[3]) ? sorted_results[2]:
     sorted_results[3];

     sorted_results[4] = (sorted_results[4]>sorted_results[5]) ? sorted_results[5]:
     sorted_results[4];

     sorted_results[5] = (sorted_results[4]>sorted_results[5]) ? sorted_results[4]:
     sorted_results[5];
  end

  //Ascend or descend of the sorted results
  generate
    for(idx=0;idx<NUM_OF_ELEMENT;idx=idx+1)
    begin: ASCEND_DESCEND
        always @(*)
        begin
          if(opt[1] == 1'b1)
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

  //Cumulation and Shifter
  always @(*)
  begin:CUMULATION_SHIFT
    if(opt[2] == 1'b1)
    begin
        //Moving average normalization
        cu_normalised[0] = ascend_or_descend[0];

        for(i=1;i<NUM_OF_ELEMENT;i=i+1)
        begin
            cu_normalised[i] = (cu_normalised[i-1] * $signed(2) + ascend_or_descend[i])/$signed(3);
        end
    end
    else
    begin
        //Shifter
        for(i=0;i<NUM_OF_ELEMENT;i=i+1)
        begin
            if(ascend_or_descend[0] > $signed(0))
            begin
                cu_normalised[i] = cu_normalised[i] - ascend_or_descend[0];
            end
            else
            begin
                cu_normalised[i] = cu_normalised[i] + ascend_or_descend[0];
            end
        end
    end
  end

  //eq
  always @(*)
  begin:EQU
    if(equ == 1'b1)
    begin
        equation_result = cu_normalised[5] * (cu_normalised[1] - cu_normalised[0]);

        if(equation_result >= $signed(0))
        begin
            equation_result = equation_result;
        end
        else
        begin
            equation_result = ~equation_result + $signed('d1);
        end
    end
    else
    begin
        equation_result = cu_normalised[3];
        equation_result = equation_result + cu_normalised[4] * $signed(4);
        equation_result = equation_result / $signed(3);
    end
  end

  assign out_n = equation_result;

endmodule