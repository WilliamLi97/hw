module gray_to_bin_converter #(
    parameter LENGTH = 3
) (
    input  logic [LENGTH-1:0] gray_i,
    output logic [LENGTH-1:0] binary_o
);

  genvar i;
  generate
    assign binary_o[LENGTH-1] = gray_i[LENGTH-1];
    for (i = LENGTH - 2; i >= 0; i = i - 1) begin : gen_binary
      assign binary_o[i] = binary_o[i+1] ^ gray_i[i];
    end
  endgenerate

endmodule
