module fifo_async #(
    parameter CHAIN_LENGTH = 3,
    parameter MEM_LENGTH   = 32,
    parameter DATA_WIDTH   = 16
) (
    input  logic                  reset_src_ni,
    input  logic                  reset_dest_ni,
    input  logic                  clk_src_i,
    input  logic                  clk_dest_i,
    input  logic                  write_en_i,
    input  logic                  read_en_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    output logic                  full_o,
    output logic                  empty_o,
    output logic [DATA_WIDTH-1:0] data_o
);

  localparam PTR_LENGTH = $clog2(MEM_LENGTH);

  logic [PTR_LENGTH:0] write_ptr;
  logic [PTR_LENGTH:0] read_ptr;
  logic [PTR_LENGTH:0] write_ptr_gray;
  logic [PTR_LENGTH:0] read_ptr_gray;
  logic [PTR_LENGTH:0] read_ptr_gray_src;
  logic [PTR_LENGTH:0] write_ptr_gray_dest;

  logic [DATA_WIDTH-1:0] mem[MEM_LENGTH-1:0];

  genvar i;
  generate
    bin_to_gray_converter write_ptr_bg_converter (
        .binary_i(write_ptr),
        .gray_o  (write_ptr_gray)
    );

    bin_to_gray_converter read_ptr_bg_converter (
        .binary_i(read_ptr),
        .gray_o  (read_ptr_gray)
    );

    for (i = 0; i <= $clog2(MEM_LENGTH); i = i + 1) begin : gen_ptr_pipes
      chain_synchronizer #(
          .LENGTH(CHAIN_LENGTH)
      ) write_ptr_pipe (
          .reset_ni(reset_dest_ni),
          .clk_i   (clk_dest_i),
          .data_i  (write_ptr_gray[i]),
          .data_o  (write_ptr_gray_dest[i])
      );

      chain_synchronizer #(
          .LENGTH(CHAIN_LENGTH)
      ) read_ptr_pipe (
          .reset_ni(reset_src_ni),
          .clk_i   (clk_src_i),
          .data_i  (read_ptr_gray[i]),
          .data_o  (read_ptr_gray_src[i])
      );
    end
  endgenerate

  assign full_o = (write_ptr_gray[PTR_LENGTH:PTR_LENGTH-1] == ~read_ptr_gray_src[PTR_LENGTH:PTR_LENGTH-1]) & (write_ptr_gray[PTR_LENGTH-2:0] == read_ptr_gray_src[PTR_LENGTH-2:0]);
  assign empty_o = read_ptr_gray == write_ptr_gray_dest;

  always_ff @(posedge clk_src_i, negedge reset_src_ni) begin
    if (~reset_src_ni) begin
      write_ptr <= 0;
    end else begin
      if (write_en_i & ~full_o) begin
        mem[write_ptr] <= data_i;
        write_ptr      <= write_ptr + 1;
      end
    end
  end

  always_ff @(posedge clk_dest_i, negedge reset_dest_ni) begin
    if (~reset_dest_ni) begin
      read_ptr <= 0;
      data_o   <= 0;
    end else begin
      if (read_en_i & ~empty_o) begin
        data_o   <= mem[read_ptr];
        read_ptr <= read_ptr + 1;
      end
    end
  end
endmodule
