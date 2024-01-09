`timescale 1ns / 1ns

module ripple_carry_adder_tb #(
    parameter LENGTH = 16
) ();

  logic [LENGTH-1:0] a;
  logic [LENGTH-1:0] b;
  logic [LENGTH-1:0] s;
  logic c;

  ripple_carry_adder #(
      .LENGTH(LENGTH)
  ) ripple_carry_adder_0 (
      .a_i(a),
      .b_i(b),
      .s_o(s),
      .c_o(c)
  );

  initial begin
    a = 16'h0010;
    b = 16'h1011;
    #10;

    a = 16'hffff;
    b = 16'h0001;
    #10;

    a = 16'hffff;
    b = 16'hffff;
    #10;

    $finish();
  end

  initial begin
    $dumpfile("ripple_carry_adder_tb.vcd");
    $dumpvars(0, ripple_carry_adder_tb);
  end

endmodule
