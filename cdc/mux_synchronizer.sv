module moduleName #(
    parameter DATA_WIDTH   = 32,
    parameter CHAIN_LENGTH = 3
) (
    input logic reset_i,
    input logic clk_i,
    input logic en_src_i,
    input logic [DATA_WIDTH-1:0] data_i,
    output logic [DATA_WIDTH-1:0] data_o
);

  logic en_dest;

  chain_synchronizer #(
      .LENGTH(3)
  ) cs_0 (
      .reset_i(reset_i),
      .clk_i  (clk_i),
      .data_i (en_src_i),
      .data_o (en_dest)
  );

  always_ff @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      data_o <= 0;
    end else begin
      if (en_dest) begin
        data_o <= data_i;
      end else begin
        data_o <= data_o;
      end
    end
  end

endmodule

