module handshake_src_fsm #(
    parameter DATA_WIDTH = 32
) (
    input  logic                  reset_ni,
    input  logic                  clk_i,
    input  logic                  valid_i,
    input  logic                  ack_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    output logic                  busy_o,
    output logic                  req_o,
    output logic [DATA_WIDTH-1:0] data_o
);

  typedef enum logic [1:0] {
    IDLE,
    HOLD,
    CLEAR
  } state_e;

  state_e current_state;
  state_e next_state;

  logic   next_busy;
  logic   next_req;

  logic [DATA_WIDTH-1:0] next_data;

  always_comb begin
    case (current_state)
      IDLE: begin
        if (valid_i) next_state = HOLD;
        else next_state = IDLE;
      end
      HOLD: begin
        if (ack_i) next_state = CLEAR;
        else next_state = HOLD;
      end
      CLEAR: begin
        if (~ack_i) next_state = IDLE;
        else next_state = CLEAR;
      end
      default: next_state = IDLE;
    endcase
  end

  always_comb begin
    case (current_state)
      IDLE: begin
        next_busy = valid_i ? '1 : '0;
        next_req  = valid_i ? '1 : '0;
        next_data = valid_i ? data_i : data_o;
      end
      HOLD: begin
        next_busy = '1;
        next_req  = ack_i ? '0 : '1;
        next_data = data_o;
      end
      CLEAR: begin
        next_busy = ~ack_i ? '0 : '1;
        next_req  = '0;
        next_data = data_o;
      end
      default: begin
        next_busy = 'x;
        next_req  = 'x;
        next_data = 'x;
      end
    endcase
  end

  always_ff @(posedge clk_i, negedge reset_ni) begin
    if (~reset_ni) current_state <= IDLE;
    else current_state <= next_state;
  end

  always_ff @(posedge clk_i, negedge reset_ni) begin
    if (~reset_ni) begin
      busy_o <= '0;
      req_o  <= '0;
      data_o <= '0;
    end else begin
      busy_o <= next_busy;
      req_o  <= next_req;
      data_o <= next_data;
    end
  end

endmodule
