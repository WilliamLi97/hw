`timescale 1ns/1ns

module gray_code_converters_tb #(
    parameter LENGTH = 4
) ();

  logic [LENGTH-1:0] data_in;
  logic [LENGTH-1:0] gray_out;
  logic [LENGTH-1:0] binary_out;

  bin_to_gray_converter #(
      .LENGTH(LENGTH)
  ) bg_converter (
      .binary_i(data_in),
      .gray_o  (gray_out)
  );

  gray_to_bin_converter #(
      .LENGTH(LENGTH)
  ) gb_converter (
      .gray_i  (gray_out),
      .binary_o(binary_out)
  );

  initial begin
    data_in = 0;
    #10;

    do begin
        data_in = data_in + 1;
        #10;
    end while (data_in > 0);

    $finish();
  end

  initial begin
    $dumpfile("gray_code_converters_tb.vcd");
    $dumpvars(0, gray_code_converters_tb);
  end

endmodule
