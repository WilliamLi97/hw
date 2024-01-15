module mux_synchronizer #(
    parameter CHAIN_LENGTH = 3,
    parameter DATA_WIDTH   = 32
) (
    input  logic                  reset_ni,
    input  logic                  clk_i,
    input  logic                  en_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    output logic [DATA_WIDTH-1:0] data_o
);

  logic en_dest;

  chain_synchronizer #(
      .LENGTH(CHAIN_LENGTH)
  ) cs (
      .reset_ni(reset_ni),
      .clk_i   (clk_i),
      .data_i  (en_i),
      .data_o  (en_dest)
  );

  always_ff @(posedge clk_i, negedge reset_ni) begin
    if (~reset_ni) data_o <= '0;
    else data_o <= en_dest ? data_i : data_o;
  end

endmodule

