module reset_synchronizer_tb ();

  logic reset_ni_event;
  logic clk;
  logic reset_ni_master;

  reset_synchronizer rs (
      .reset_ni(reset_ni_event),
      .clk_i(clk),
      .reset_no(reset_ni_master)
  );

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    reset_ni_event = 1;
    #3;

    reset_ni_event = 0;
    #3;

    reset_ni_event = 1;
    #50;

    $finish();
  end

  initial begin
    $dumpfile("reset_synchronizer_tb.vcd");
    $dumpvars(0, reset_synchronizer_tb);
  end

endmodule
