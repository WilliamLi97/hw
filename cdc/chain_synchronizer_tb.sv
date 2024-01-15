`timescale 1ns / 1ns

module chain_synchronizer_tb #(
    parameter LENGTH = 3
) ();

  logic reset_n;
  logic reset_master_src_n;
  logic reset_master_dest_n;
  logic clk_src;
  logic clk_dest;
  logic data_src;
  logic data_dest;
  logic next_data_src;

  reset_synchronizer rs_src (
      .reset_ni(reset_n),
      .clk_i(clk_src),
      .reset_no(reset_master_src_n)
  );

  reset_synchronizer rs_dest (
      .reset_ni(reset_n),
      .clk_i(clk_dest),
      .reset_no(reset_master_dest_n)
  );

  chain_synchronizer #(
      .LENGTH(LENGTH)
  ) cs (
      .reset_ni(reset_master_dest_n),
      .clk_i(clk_dest),
      .data_i(data_src),
      .data_o(data_dest)
  );

  initial begin
    clk_src = '1;
    forever #15 clk_src = ~clk_src;
  end

  initial begin
    clk_dest = '1;
    forever #5 clk_dest = ~clk_dest;
  end

  initial begin
    reset_n = '0;
    next_data_src = '0;
    #10;

    reset_n = '1;
    #100;

    next_data_src = '1;
    #30;

    next_data_src = '0;
    #100;

    $finish();
  end

  always_ff @(posedge clk_src, negedge reset_master_src_n) begin
    if (~reset_master_src_n) data_src <= 0;
    else data_src <= next_data_src;
  end

  initial begin
    $dumpfile("chain_synchronizer_tb.vcd");
    $dumpvars(0, chain_synchronizer_tb);
  end

endmodule
