`timescale 1ns / 1ns

module full_adder_tb ();

  logic [2:0] i;
  logic s;
  logic c_out;

  full_adder full_adder_0 (
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
    $dumpfile("full_adder_tb.vcd");
    $dumpvars(0, full_adder_tb);
  end
endmodule
