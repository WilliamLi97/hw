module mux_synchronizer_tb #(
    parameter CHAIN_LENGTH = 2,
    parameter DATA_WIDTH   = 32
) ();

  logic reset_n;
  logic reset_master_src_n;
  logic reset_master_dest_n;
  logic clk_src;
  logic clk_dest;
  logic en;
  logic next_en;
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

  mux_synchronizer #(
      .CHAIN_LENGTH(CHAIN_LENGTH),
      .DATA_WIDTH  (DATA_WIDTH)
  ) ms (
      .reset_ni(reset_master_dest_n),
      .clk_i   (clk_dest),
      .en_i    (en),
      .data_i  (data_src),
      .data_o  (data_dest)
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
    reset_n       = '0;
    next_en       = '0;
    next_data_src = '0;
    #10;

    reset_n = '1;
    #100;

    next_en       = '1;
    next_data_src = 32'hc0debeef;
    #30;

    next_en = '0;
    #30;

    next_en       = '1;
    next_data_src = 32'h00c0ffee;
    #30;

    next_en = '0;
    #100;

    $finish();
  end

  always_ff @(posedge clk_src, negedge reset_master_src_n) begin
    if (~reset_master_src_n) begin
      en       <= 0;
      data_src <= 0;
    end else begin
      en       <= next_en;
      data_src <= next_data_src;
    end
  end

  initial begin
    $dumpfile("mux_synchronizer_tb.vcd");
    $dumpvars(0, mux_synchronizer_tb);
  end

endmodule
