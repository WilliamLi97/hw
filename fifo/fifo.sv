module fifo #(
    parameter LENGTH = 32,
    parameter WIDTH  = 16
) (
    input logic reset_i,
    input logic clk_i,
    input logic read_en,
    input logic write_en,
    input logic [WIDTH-1:0] data_i,
    output logic empty_o,
    output logic full_o,
    output logic [WIDTH-1:0] data_o
);

  logic [$clog2(LENGTH):0] write_ptr;
  logic [$clog2(LENGTH):0] read_ptr;
  logic [WIDTH-1:0] mem [LENGTH-1:0];

  assign empty_o = (write_ptr == read_ptr) | reset_i;
  assign full_o = (write_ptr[$clog2(LENGTH)] != read_ptr[$clog2(LENGTH)] && write_ptr[$clog2(LENGTH)-1:0] == read_ptr[$clog2(LENGTH)-1:0]) & ~reset_i;

  always_ff @(posedge clk_i, posedge reset_i) begin
    if (reset_i) begin
      write_ptr <= 0;
      read_ptr  <= 0;
      data_o    <= 0;
    end else begin
      if (read_en & ~empty_o) begin
        data_o          <= mem[read_ptr];
        read_ptr        <= read_ptr + 1;
      end
      if (write_en & ~full_o) begin
        mem[write_ptr]   <= data_i;
        write_ptr        <= write_ptr + 1;
      end
    end
  end

endmodule
