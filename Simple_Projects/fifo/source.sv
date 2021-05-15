module source(SB.m0 Intf, input logic clk_i, rstn_i);

        logic [7:0] data;
        logic [1:0] state;

        always @(posedge clk_i or negedge rstn_i) begin
                if (~rstn_i) begin
                        data <= 8'd0;
                        state <= 2'd0;
                end
        end

        always @(posedge clk_i) begin
                //$display("source* -> data = %0d ready = %1d valid = %2d", data, Intf.ready, Intf.valid);

                case(state)
                        2'd0:
                                begin
                                        Intf.valid <= 1'b0;
                                        data += 1;
                                        state <= 2'd1;
                                end
                        2'd1:
                                begin
                                        if (Intf.ready) begin
                                                Intf.valid <= 1'b1;
                                                Intf.data <= data;
                                                state <= 2'd0;
                                        end else begin
                                                state <= 2'd1;
                                        end
                                end
                endcase
        end

endmodule
