module mod3_counter (
    input logic clear_i,
    input logic incr_i,
    output logic [$clog2(3)-1:0] count_o
);

  logic q_ff0;
  logic qn_ff0;
  logic q_ff1;
  logic qn_ff1;

  assign count_o = {q_ff1, q_ff0};

  d_ff_async d_ff_async_0 (
      .clear_i(clear_i),
      .d_i(qn_ff1 & qn_ff0),
      .clk_i(incr_i),
      .q_o(q_ff0),
      .q_no(qn_ff0)
  );

  d_ff_async d_ff_async_1 (
      .clear_i(clear_i),
      .d_i(q_ff0),
      .clk_i(incr_i),
      .q_o(q_ff1),
      .q_no(qn_ff1)
  );

endmodule
