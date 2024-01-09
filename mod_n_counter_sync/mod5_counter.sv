module mod5_counter (
    input logic clear_i,
    input logic incr_i,
    output logic [$clog2(5)-1:0] count_o
);

  logic q_ff0;
  logic qn_ff0;
  logic q_ff1;
  logic qn_ff1;
  logic q_ff2;
  logic qn_ff2;

  assign count_o = {q_ff2, q_ff1, q_ff0};

  d_ff_async d_ff_async_0 (
      .clear_i(clear_i),
      .d_i(qn_ff2 & qn_ff0),
      .clk_i(incr_i),
      .q_o(q_ff0),
      .q_no(qn_ff0)
  );

  d_ff_async d_ff_async_1 (
      .clear_i(clear_i),
      .d_i(q_ff1 ^ q_ff0),
      .clk_i(incr_i),
      .q_o(q_ff1),
      .q_no(qn_ff1)
  );

  d_ff_async d_ff_async_2 (
      .clear_i(clear_i),
      .d_i(q_ff1 & q_ff0),
      .clk_i(incr_i),
      .q_o(q_ff2),
      .q_no(qn_ff2)
  );

endmodule
