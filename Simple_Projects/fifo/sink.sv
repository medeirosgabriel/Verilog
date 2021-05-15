module sink(SB.m0 Intf, input logic clk_i, rstn_i);

        logic [7:0] data;
        logic [1:0] state;

        always @(posedge clk_i or negedge rstn_i) begin
                if (~rstn_i) begin
                        state <= 2'd0;
                end
        end

        always @(posedge clk_i) begin
                case(state)
                        2'd0:
                                begin
                                        Intf.ready <= 1'b1;
                                        state <= 2'd1;
                                end
                        2'd1:
                                begin
                                        if (Intf.valid) begin
                                                data <= Intf.data;
                                                state <= 2'd0;
                                                Intf.ready <= 0;
                                                #5;
                                                //$display("si -> data = %0d", Intf.data);
                                        end else begin
                                                state <= 2'd1;
                                        end
                                end
                endcase
        end

endmodule