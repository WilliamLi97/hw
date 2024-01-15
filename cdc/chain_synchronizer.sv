module chain_synchronizer #(
    parameter LENGTH = 3
) (
    input  logic reset_ni,
    input  logic clk_i,
    input  logic data_i,
    output logic data_o
);

  logic [LENGTH-1:0] pipe;

  assign data_o = pipe[LENGTH-1];

  always_ff @(posedge clk_i, negedge reset_ni) begin
    if (~reset_ni) pipe <= '0;
    else pipe <= {pipe[LENGTH-2:0], data_i};
  end

endmodule
