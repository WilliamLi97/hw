module gray_counter3_sync (
    input  logic       reset_ni,
    input  logic       clk_i,
    input  logic       incr_i,
    output logic [2:0] count_o
);

  logic [2:0] count_n;
  logic [2:0] next_count;

  d_ff_nasync d_ff_n2 (
      .clear_ni(reset_ni),
      .d_i(next_count[2]),
      .clk_i(clk_i),
      .q_o(count_o[2]),
      .q_no(count_n[2])
  );

  d_ff_nasync d_ff_n1 (
      .clear_ni(reset_ni),
      .d_i(next_count[1]),
      .clk_i(clk_i),
      .q_o(count_o[1]),
      .q_no(count_n[1])
  );

  d_ff_nasync d_ff_n0 (
      .clear_ni(reset_ni),
      .d_i(next_count[0]),
      .clk_i(clk_i),
      .q_o(count_o[0]),
      .q_no(count_n[0])
  );

  assign next_count[2] = incr_i ? (count_o[1] & count_n[0]) | (count_o[2] & count_o[0]) : count_o[2];
  assign next_count[1] = incr_i ? (count_o[1] & count_n[0]) | (count_n[2] & count_o[0]) : count_o[1];
  assign next_count[0] = incr_i ? (count_n[2] & count_n[1]) | (count_o[2] & count_o[1]) : count_o[0];

endmodule
