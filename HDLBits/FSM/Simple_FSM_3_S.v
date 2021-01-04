module top_module(
    input clk,
    input in,
    input reset,
    output out);
    
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;
    reg [1:0] state = A;

    // State transition logic
    // State flip-flops with synchronous reset
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= in ? B:A;
                B: state <= in ? B:C;
                C: state <= in ? D:A;
                D: state <= in ? B:C;
            endcase
        end
   	end

    // Output logic
    
    assign out = (state == D);

endmodule
