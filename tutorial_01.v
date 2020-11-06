module tutorial_01(input clk, input rst);

   localparam FLIT_WIDTH = 34;

   wire [FLIT_WIDTH:0] flit;
   wire                valid;
   wire                ready;

   source
     u_source(/*AUTOINST*/
              // Outputs
              .flit                     (flit[FLIT_WIDTH-1:0]),
              .valid                    (valid),
              // Inputs
              .clk                      (clk),
              .rst                      (rst),
              .ready                    (ready));

   sink
     u_sink(/*AUTOINST*/
            // Outputs
            .ready                      (ready),
            // Inputs
            .clk                        (clk),
            .rst                        (rst),
            .flit                       (flit[FLIT_WIDTH-1:0]),
            .valid                      (valid));

endmodule // tutorial_01
