module bin_to_gray_converter #(
    parameter LENGTH = 3
) (
    input  logic [LENGTH-1:0] binary_i,
    output logic [LENGTH-1:0] gray_o
);

assign gray_o = {binary_i[LENGTH-1], binary_i[LENGTH-1:1] ^ binary_i[LENGTH-2:0]};

endmodule
