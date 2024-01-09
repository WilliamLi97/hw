module double_half_adder (
    input  logic a_i,
    input  logic b_i,
    input  logic c_i,
    output logic s_o,
    output logic c_o
);

  logic s_0;
  logic c_0;
  logic s_1;
  logic c_1;

  assign s_o = s_1;
  assign c_o = c_1 + c_0;

  half_adder half_adder_0 (
      .a_i(a_i),
      .b_i(b_i),
      .s_o(s_0),
      .c_o(c_0)
  );

  half_adder half_adder_1 (
      .a_i(s_0),
      .b_i(c_i),
      .s_o(s_1),
      .c_o(c_1)
  );

endmodule
