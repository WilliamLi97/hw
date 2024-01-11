module handshake_synchronizer #(
    DATA_WIDTH   = 32,
    CHAIN_LENGTH = 3
) (
    input logic reset_src_i,
    input logic reset_dest_i,
    input logic clk_src_i,
    input logic clk_dest_i,
    input logic valid_i,                    // used to mark data meant to cross CDC
    input logic [DATA_WIDTH-1:0] data_i,
    output logic busy_o,                    // used to notify source domain that the channel is busy
    output logic valid_o,                   // used to mark data that has crossed the CDC
    output logic data_o
);

endmodule
