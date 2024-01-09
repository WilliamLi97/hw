`timescale 1ns / 1ns

module fifo_tb #(
    parameter LENGTH = 4,
    parameter WIDTH  = 16
) ();

  logic reset;
  logic clk_en;
  logic clk;
  logic read_en;
  logic write_en;
  logic empty;
  logic full;
  logic [WIDTH-1:0] data_in;
  logic [WIDTH-1:0] data_out;

  fifo #(
      .LENGTH(LENGTH),
      .WIDTH (WIDTH)
  ) fifo_0 (
      .reset_i(reset),
      .clk_i(clk),
      .read_en(read_en),
      .write_en(write_en),
      .data_i(data_in),
      .empty_o(empty),
      .full_o(full),
      .data_o(data_out)
  );

  always @(posedge clk_en) begin
    clk = 0;
    while (clk_en) begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end

  initial begin
    clk      = 0;
    reset    = 1;
    clk_en   = 1;
    read_en  = 0;
    write_en = 0;
    data_in  = 0;
    #10;

    reset = 0;
    #10;

    write_en = 1;
    data_in  = 16'hbeef;
    #10;

    write_en = 1;
    data_in  = 16'hceef;
    #10;

    write_en = 1;
    data_in  = 16'hdeef;
    #10;

    write_en = 1;
    data_in  = 16'heeef;
    #10;

    write_en = 0;
    data_in  = 0;
    read_en  = 1;
    #10;

    read_en = 1;
    #10;

    read_en = 1;
    #10;

    read_en = 1;
    #10;

    read_en = 0;
    #10;

    $finish();
  end

  integer i;
  initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, fifo_tb);
    // for (i = 0; i < LENGTH; i = i + 1) begin
    //   $dumpvars(0, fifo_0.mem[i]);
    // end
  end

endmodule
