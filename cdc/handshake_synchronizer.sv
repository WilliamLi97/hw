module handshake_synchronizer #(
    parameter CHAIN_LENGTH = 3,
    parameter DATA_WIDTH   = 32
) (
    input  logic                  reset_src_ni,
    input  logic                  reset_dest_ni,
    input  logic                  clk_src_i,
    input  logic                  clk_dest_i,
    input  logic                  valid_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    output logic                  busy_o,
    output logic                  valid_o,
    output logic [DATA_WIDTH-1:0] data_o
);

  logic req;
  logic req_dest;
  logic ack;
  logic ack_src;

  chain_synchronizer #(
      .LENGTH(CHAIN_LENGTH)
  ) cs_req (
      .reset_ni(reset_dest_ni),
      .clk_i  (clk_dest_i),
      .data_i (req),
      .data_o (req_dest)
  );

  chain_synchronizer #(
      .LENGTH(CHAIN_LENGTH)
  ) cs_ack (
      .reset_ni(reset_src_ni),
      .clk_i  (clk_src_i),
      .data_i (ack),
      .data_o (ack_src)
  );

  handshake_src_fsm #(
      .DATA_WIDTH(DATA_WIDTH)
  ) src_fsm (
      .reset_ni(reset_src_ni),
      .clk_i(clk_src_i),
      .valid_i(valid_i),
      .ack_i(ack_src),
      .data_i(data_i),
      .busy_o(busy_o),
      .req_o(req),
      .data_o(data_o)
  );

  handshake_dest_fsm dest_fsm (
      .reset_ni(reset_dest_ni),
      .clk_i(clk_dest_i),
      .req_i(req_dest),
      .ack_o(ack),
      .valid_o(valid_o)
  );

endmodule
