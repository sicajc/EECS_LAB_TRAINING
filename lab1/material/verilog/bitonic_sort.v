module BitonicSorter #(parameter NUM_OF_ELEMENT = 8, SORTERS_WIDTH = 8)
(
  input wire clk,
  input wire rst,
  input wire signed[SORTERS_WIDTH-1:0] sign_ex_values[0:NUM_OF_ELEMENT-1],
  output wire signed[SORTERS_WIDTH-1:0] sorted_results[0:NUM_OF_ELEMENT-1]
);

  reg signed[SORTERS_WIDTH-1:0] stage_zero[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_one[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_two[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_three[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_four[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_five[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_six[0:NUM_OF_ELEMENT-1];
  reg signed[SORTERS_WIDTH-1:0] stage_seven[0:NUM_OF_ELEMENT-1];
  integer i;



endmodule
