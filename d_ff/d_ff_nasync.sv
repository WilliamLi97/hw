module d_ff_nasync (
    input  logic clear_ni,
    input  logic d_i,
    input  logic clk_i,
    output logic q_o,
    output logic q_no
);

  always_ff @(posedge clk_i, negedge clear_ni) begin
    if (~clear_ni) begin
      q_o  <= 0;
      q_no <= 1;
    end else begin
      q_o  <= d_i;
      q_no <= ~d_i;
    end
  end

endmodule
