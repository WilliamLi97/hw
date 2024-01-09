`timescale 1ns/1ns

module clock_divider5_tb ();

  logic reset;
  logic clk_en;
  logic clk;

  logic div_clk;

  clock_divider5 clock_divider5_0 (
      .reset_i(reset),
      .clk_i  (clk),
      .clk_o  (div_clk)
  );

  always @(posedge clk_en) begin
    clk = 0;
    while (clk_en) begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end

  initial begin
    clk    = 0;
    reset  = 1;
    clk_en = 1;
    #10;

    reset = 0;
    #200;

    $finish();
  end

  initial begin
    $dumpfile("clock_divider5_tb.vcd");
    $dumpvars(0, clock_divider5_tb);
  end

endmodule
