module clock_divider5 (
    input  logic reset_i,
    input  logic clk_i,
    output logic clk_o
);

  logic [$clog2(5)-1:0] count;
  logic clk_pre_flop;
  logic clk_post_flop;

  assign clk_pre_flop = count[2] | (count[1] & count[0]);
  assign clk_o        = clk_pre_flop | clk_post_flop;

  mod5_counter mod5_counter_0 (
      .clear_i(reset_i),
      .incr_i (clk_i),
      .count_o(count)
  );

  d_ff_async d_ff_async_0 (
      .clear_i(reset_i),
      .d_i(clk_pre_flop),
      .clk_i(~clk_i),
      .q_o(clk_post_flop),
      .q_no()
  );

endmodule
