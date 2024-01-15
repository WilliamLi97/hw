module reset_synchronizer (
    input  logic reset_ni,
    input  logic clk_i,
    output logic reset_no
);

  logic [1:0] reset_pipe;

  assign reset_no = reset_pipe[1];

  always_ff @(posedge clk_i, negedge reset_ni) begin
    if (~reset_ni) reset_pipe <= '0;
    else reset_pipe <= {reset_pipe[0], reset_ni};
  end

endmodule
