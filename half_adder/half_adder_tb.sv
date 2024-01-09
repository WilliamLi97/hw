`timescale 1ns/1ns

module half_adder_tb ();

    logic a;
    logic b;
    logic s;
    logic c;
    logic [1:0] i;

  half_adder half_adder_0 (
    .a_i(i[1]),
    .b_i(i[0]),
    .s_o(s),
    .c_o(c)
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
    $dumpfile("half_adder_tb.vcd");
    $dumpvars(0, half_adder_tb);
  end
endmodule
