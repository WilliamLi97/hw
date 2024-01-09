`timescale 1ns / 1ns

module double_half_adder_tb ();

  logic [2:0] i;
  logic s;
  logic c_out;

  double_half_adder double_half_adder_0 (
      .a_i(i[0]),
      .b_i(i[1]),
      .c_i(i[2]),
      .s_o(s),
      .c_o(c_out)
  );

  initial begin
    i = 0;

    do begin
      #10;
      i = i + 1;
    end while (i != 0);

    $finish();
  end

  initial begin
    $dumpfile("double_half_adder_tb.vcd");
    $dumpvars(0, double_half_adder_tb);
  end
endmodule
