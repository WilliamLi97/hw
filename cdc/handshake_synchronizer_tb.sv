`timescale 1ns/1ns

module handshake_synchronizer_tb #(
    parameter CHAIN_LENGTH = 3,
    parameter DATA_WIDTH   = 32
) ();

  logic reset_n;
  logic reset_master_src_n;
  logic reset_master_dest_n;
  logic clk_src;
  logic clk_dest;
  logic busy;
  logic valid_src;
  logic next_valid_src;
  logic valid_dest;

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

  handshake_synchronizer #(
      .CHAIN_LENGTH(CHAIN_LENGTH),
      .DATA_WIDTH  (DATA_WIDTH)
  ) hs (
      .reset_src_ni (reset_master_src_n),
      .reset_dest_ni(reset_master_dest_n),
      .clk_src_i    (clk_src),
      .clk_dest_i   (clk_dest),
      .valid_i      (valid_src),
      .data_i       (data_src),
      .busy_o       (busy),
      .valid_o      (valid_dest),
      .data_o       (data_dest)
  );

  initial begin
    clk_src = '1;
    forever #5 clk_src = ~clk_src;
  end

  initial begin
    clk_dest = '1;
    forever #32 clk_dest = ~clk_dest;
  end

  initial begin
    reset_n        = '0;
    next_valid_src = '0;
    next_data_src  = '0;
    #100;

    reset_n = '1;
    #100;

    next_valid_src = '1;
    next_data_src  = 32'h00001ced;
    #100;

    next_valid_src = '0;
    next_data_src  = 32'h00c0ffee;
    while (busy) #10;

    next_valid_src = '1;
    #100;

    next_valid_src = '0;
    while (busy) #10;

    $finish();
  end

  always_ff @(posedge clk_src, negedge reset_master_src_n) begin
    if (~reset_master_src_n) begin
      valid_src <= '0;
      data_src  <= '0;
    end else begin
      valid_src <= next_valid_src;
      data_src  <= next_data_src;
    end
  end

  initial begin
    $dumpfile("handshake_synchronizer_tb.vcd");
    $dumpvars(0, handshake_synchronizer_tb);
  end

endmodule
