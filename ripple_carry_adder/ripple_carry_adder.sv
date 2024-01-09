module ripple_carry_adder #(
    parameter LENGTH = 16
) (
    input logic [LENGTH-1:0] a_i,
    input logic [LENGTH-1:0] b_i,
    output logic [LENGTH-1:0] s_o,
    output logic c_o
);

  logic [LENGTH-1:0] c;

  assign c_o = c[LENGTH-1];

  genvar i;
  generate
    full_adder full_adder_0 (
        .a_i(a_i[0]),
        .b_i(b_i[0]),
        .c_i(1'b0),
        .s_o(s_o[0]),
        .c_o(c[0])
    );

    for (i = 1; i < LENGTH; i = i + 1) begin : gen_full_adder
      full_adder full_adder (
          .a_i(a_i[i]),
          .b_i(b_i[i]),
          .c_i(c[i-1]),
          .s_o(s_o[i]),
          .c_o(c[i])
      );
    end
  endgenerate

endmodule
