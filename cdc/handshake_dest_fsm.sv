module handshake_dest_fsm (
    input  logic reset_ni,
    input  logic clk_i,
    input  logic req_i,
    output logic ack_o,
    output logic valid_o
);

  typedef enum logic {
    IDLE,
    ACK
  } state_e;

  state_e current_state;
  state_e next_state;

  always_comb begin
    case (current_state)
      IDLE: begin
        if (req_i) next_state = ACK;
        else next_state = IDLE;
      end
      ACK: begin
        if (~req_i) next_state = IDLE;
        else next_state = ACK;
      end
      default: next_state = IDLE;
    endcase
  end

  always_comb begin
    ack_o = req_i;

    case (current_state)
      IDLE:    valid_o = req_i;
      ACK:     valid_o = '0;
      default: valid_o = 'x;
    endcase
  end

  always_ff @(posedge clk_i, negedge reset_ni) begin
    if (~reset_ni) current_state <= IDLE;
    else current_state <= next_state;
  end

endmodule
