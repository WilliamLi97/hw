`timescale 1ns / 1ns

module fifo_async_tb #(
    parameter CHAIN_LENGTH = 3,
    parameter MEM_LENGTH   = 4,
    parameter DATA_WIDTH   = 32
) ();

  logic reset_n;
  logic reset_master_src_n;
  logic reset_master_dest_n;
  logic clk_src;
  logic clk_dest;
  logic write_en;
  logic next_write_en;
  logic read_en;
  logic next_read_en;
  logic full;
  logic empty;

  logic [DATA_WIDTH-1:0] data_src;
  logic [DATA_WIDTH-1:0] next_data_src;
  logic [DATA_WIDTH-1:0] data_dest;

  reset_synchronizer rs_src (
      .reset_ni(reset_n),
      .clk_i   (clk_src),
      .reset_no(reset_master_src_n)
  );

  reset_synchronizer rs_dest (
      .reset_ni(reset_n),
      .clk_i   (clk_dest),
      .reset_no(reset_master_dest_n)
  );

  fifo_async #(
      .CHAIN_LENGTH(CHAIN_LENGTH),
      .MEM_LENGTH  (MEM_LENGTH),
      .DATA_WIDTH  (DATA_WIDTH)
  ) fifo_async_0 (
      .reset_src_ni(reset_master_src_n),
      .reset_dest_ni(reset_master_dest_n),
      .clk_src_i(clk_src),
      .clk_dest_i(clk_dest),
      .write_en_i(write_en),
      .read_en_i(read_en),
      .data_i(data_src),
      .full_o(full),
      .empty_o(empty),
      .data_o(data_dest)
  );

  initial begin
    clk_src = 1;
    forever #5 clk_src = ~clk_src;
  end

  initial begin
    clk_dest = 1;
    forever #8 clk_dest = ~clk_dest;
  end

  initial begin
    reset_n       = 0;
    next_write_en = 0;
    next_data_src = 0;
    next_read_en  = 0;
    #20;

    reset_n = 1;
    #100;

    next_write_en = 1;
    while (next_data_src < MEM_LENGTH) begin
      next_data_src = next_data_src + 1;
      #10;
    end

    next_write_en = 0;
    #10;

    while (empty) #10;

    next_read_en = 1;
    while (!empty) #10;

    next_read_en = 0;
    #100;

    $finish();
  end

  always_ff @(posedge clk_src, negedge reset_master_src_n) begin
    if (~reset_master_src_n) begin
      write_en <= 0;
      data_src <= 0;
    end else begin
      write_en <= next_write_en;
      data_src <= next_data_src;
    end
  end

  always_ff @(posedge clk_dest, negedge reset_master_dest_n) begin
    if (~reset_master_dest_n) read_en <= 0;
    else read_en <= next_read_en;
  end

  initial begin
    $dumpfile("fifo_async_tb.vcd");
    $dumpvars(0, fifo_async_tb);
  end

endmodule
