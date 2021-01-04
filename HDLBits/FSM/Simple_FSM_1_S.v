// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;
    reg out;

    // Fill in state name declarations

    reg present_state, next_state;
    parameter A = 1'b0, B = 1'b1;
    
    always @(*) begin
        case (present_state)
         	A: next_state <= in ? A : B;
            B: next_state <= in ? B : A;
         endcase
    end

    always @(posedge clk) begin
        if (reset) begin  
            present_state <= B;
        end else begin
            present_state <= next_state;
        end
    end
    
    assign out = present_state;

endmodule
