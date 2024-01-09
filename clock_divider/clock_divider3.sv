module clock_divider3 (
    input  logic reset_i,
    input  logic clk_i,
    output logic clk_o
);

  logic [$clog2(3)-1:0] count;
  logic msb;
  logic q_ff;

  assign msb   = count[$clog2(3)-1];
  assign clk_o = msb | q_ff;

  mod3_counter mod3_counter_0 (
      .clear_i(reset_i),
      .incr_i(clk_i),
      .count_o(count)
  );

  d_ff_async d_ff_async_0 (
      .clear_i(reset_i),
      .d_i(msb),
      .clk_i(~clk_i),
      .q_o(q_ff),
      .q_no()
  );

endmodule
