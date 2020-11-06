module sink(/*AUTOARG*/
   // Outputs
   ready,
   // Inputs
   clk, rst, flit, valid
   );

   parameter FLIT_DATA_WIDTH = 32;
   localparam FLIT_TYPE_WIDTH = 2;
   localparam FLIT_WIDTH = FLIT_DATA_WIDTH + FLIT_TYPE_WIDTH;

   input clk;
   input rst;

   input [FLIT_WIDTH-1:0] flit;
   input                  valid;
   output reg             ready;

   // Clock counting variable
   int                         clkcount;
   // The state
   int                         state;

   // The state machine is triggered on the positive edge
   always @(posedge clk) begin
      // Increment clock counter
      clkcount <= clkcount + 1;

      // Set initials during reset
      if (rst) begin
         state <= 0;
         clkcount <= 0;
      end else begin
         case(state)
           0: begin
              // Wait six cycles
              if (clkcount == 6) begin
                 state <= 1;
              end
           end
           1: begin
              // Wait for flit
              if (valid) begin
                 $display("Received %x", flit);
                 state <= 2;
              end
           end
           2: begin
              // Wait for second flit
              if (valid) begin
                 $display("Received %x", flit);
                 state <= 3;
              end
           end
           3: begin

           end
         endcase // case (state)
      end
   end

   // This is the combinational part
   always @(negedge clk) begin
      // Default
      ready <= 0;

      case (state)
        1: begin
           // Set ready
           ready <= 1;
        end
        2: begin
           // Set ready
           ready <= 1;
        end
      endcase
   end
endmodule // sink
