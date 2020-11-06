module source(/*AUTOARG*/
   // Outputs
   flit, valid,
   // Inputs
   clk, rst, ready
   );

   parameter FLIT_DATA_WIDTH = 32;
   localparam FLIT_TYPE_WIDTH = 2;
   localparam FLIT_WIDTH = FLIT_DATA_WIDTH + FLIT_TYPE_WIDTH;

   input clk;
   input rst;

   output reg [FLIT_WIDTH-1:0] flit;
   output reg                  valid;
   input                       ready;

   // For waiting phases
   int                         clkcount;
   // State variable
   int                         state;

   // The state machine is triggered on the positive edge
   always @(posedge clk) begin
      // Increment clock counter for wait phases
      clkcount <= clkcount + 1;

      // During reset: Set initial state and counter
      if (rst) begin
         state <= 0;
         clkcount <= 0;
      end else begin
         // The state machine
         case(state)
           0: begin
              // Wait for five clock cycles
              if (clkcount == 5) begin
                 state <= 1;
              end
           end
           1: begin
              // The combinational part (below) asserts flit, switch
              // state when sink is also ready at positive edge
              if (ready) begin
                 state <= 2;
                 clkcount <= 0;
              end
           end
           2: begin
              // Wait for two clock cycles
              if (clkcount == 2) begin
                 state <= 3;
              end
           end
           3: begin
              // Send a second flit like above (state 1)
              if (ready) begin
                 state <= 4;
              end
           end
           4: begin
              // do nothing
           end
         endcase // case (state)
      end
   end

   // This is the combinational part
   always @(negedge clk) begin
      // Default values
      valid <= 0;
      flit <= 'x;

      case (state)
        1: begin
           // Assert first flit
           valid <= 1;
           flit <= {2'b01, 32'h0123_4567};
        end
        3: begin
           // Assert second flit
           valid <= 1;
           flit <= {2'b10, 32'hdead_beef};
        end
      endcase
   end
endmodule // source
