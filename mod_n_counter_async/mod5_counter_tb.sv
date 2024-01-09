module mod5_counter_tb ();
  logic clk;
  logic clk_en;
  logic clear;

  logic [$clog2(5)-1:0] count;

  mod5_counter mod5_counter_0 (
      .clear_i(clear),
      .incr_i (clk),
      .count_o(count)
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
    clear  = 1;
    clk_en = 1;
    #10;

    clear = 0;
    #200;

    $finish();
  end

  initial begin
    $dumpfile("mod5_counter_tb.vcd");
    $dumpvars(0, mod5_counter_tb);
  end
endmodule
