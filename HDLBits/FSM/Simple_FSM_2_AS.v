module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out);

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case (state)
            OFF: next_state <= j ? ON : OFF;
            ON: next_state <= k ? OFF : ON;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
        	state <= next_state;
        end
    end

    // Output logic
    assign out = state;

endmodule
