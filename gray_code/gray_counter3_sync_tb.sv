`timescale 1ns / 1ns

module gray_counter3_sync_tb ();

  localparam LENGTH = 3;

  logic reset_n;
  logic reset_master_n;
  logic clk;
  logic incr;
  logic [LENGTH-1:0] count_gray;
  logic [LENGTH-1:0] count_bin;

  reset_synchronizer rs (
      .reset_ni(reset_n),
      .clk_i   (clk),
      .reset_no(reset_master_n)
  );

  gray_counter3_sync gray_counter (
      .reset_ni(reset_master_n),
      .clk_i   (clk),
      .incr_i  (incr),
      .count_o (count_gray)
  );

  gray_to_bin_converter #(
      .LENGTH(LENGTH)
  ) gb_converter (
      .gray_i  (count_gray),
      .binary_o(count_bin)
  );

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    reset_n = 0;
    incr    = 0;
    #10;

    reset_n = 1;
    #50;

    incr = 1;
    #200;

    $finish();
  end

  initial begin
    $dumpfile("gray_counter3_sync_tb.vcd");
    $dumpvars(0, gray_counter3_sync_tb);
  end

endmodule
