module mod3_counter (
    input logic clear_i,
    input logic incr_i,
    output logic [$clog2(3)-1:0] count_o
);

  logic q_dff0;
  logic qn_dff0;

  logic q_dff1;
  logic qn_dff1;

  logic clear;

  assign clear = (q_dff1 & q_dff0) | clear_i;
  assign count_o = {q_dff1, q_dff0};

  d_ff_async d_ff_async_0 (
      .clear_i(clear),
      .d_i(qn_dff0),
      .clk_i(incr_i),
      .q_o(q_dff0),
      .q_no(qn_dff0)
  );

  d_ff_async d_ff_async_1 (
      .clear_i(clear),
      .d_i(qn_dff1),
      .clk_i(qn_dff0),
      .q_o(q_dff1),
      .q_no(qn_dff1)
  );

endmodule
