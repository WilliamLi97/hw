module half_adder (
    input  logic a_i,
    input  logic b_i,
    output logic s_o,
    output logic c_o
);

  assign s_o = a_i ^ b_i;
  assign c_o = a_i & b_i;

endmodule
