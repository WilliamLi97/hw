module full_adder (
    input  logic a_i,
    input  logic b_i,
    input  logic c_i,
    output logic s_o,
    output logic c_o
);

  assign s_o = a_i ^ b_i ^ c_i;
  assign c_o = (a_i & b_i) + (c_i & (a_i + b_i));

endmodule
