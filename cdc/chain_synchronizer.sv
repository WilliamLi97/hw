module chain_synchronizer #(
    parameter LENGTH = 3
) (
    input  logic reset_i,
    input  logic clk_i,
    input  logic data_i,
    output logic data_o
);

  logic [LENGTH-1:0] pipe;

  assign data_o = pipe[LENGTH-1];

  always_ff @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
        pipe <= 0;
    end else begin
        pipe <= {pipe[LENGTH-2:1], data_i};
    end
  end

endmodule
