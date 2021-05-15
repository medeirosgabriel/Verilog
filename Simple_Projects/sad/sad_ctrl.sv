module sad_ctrl (SB.bus     Intf,
                 input  logic clk_i, rstn_i, enb_i,
                 output logic busy_o);

        logic [2:0] state;

        always @(posedge clk_i or negedge rstn_i) begin
                if (~rstn_i) begin
                        state <= 3'd0;
                        Intf.sum_clr <= 0;
                        Intf.sum_ld <= 0;
                        Intf.sad_reg_ld <= 0;
                        Intf.i_clr <= 0;
                        Intf.i_inc <= 0;
                end
        end

        always @(posedge clk_i) begin
                case (state)

                        3'd0:
                                begin
                                        if (enb_i) begin
                                                state <= 3'd1;
                                        end else begin
                                                state <= 3'd0;
                                        end

                                        Intf.sad_reg_ld <= 1'b0;
                                end
                        3'd1:
                                begin
                                        Intf.sum_clr <= 1'b1;
                                        Intf.i_clr <= 1'b1;
                                        busy_o <= 1'b1;
                                        state <= 3'd2;
                                end
                        3'd2:
                                begin
                                        if (Intf.i_it_256) begin
                                                state <= 3'd3;
                                        end else begin
                                                state <= 3'd4;
                                        end

                                        Intf.sum_clr <= 1'b0;
                                        Intf.i_clr <= 1'b0;
                                end
                        3'd3:
                                begin
                                        Intf.sum_ld <= 1'b1;
                                        Intf.i_inc <= 1'b1;
                                        state <= 3'd2;
                                end
                        3'd4:
                                begin
                                        Intf.sum_ld <= 1'b0;
                                        Intf.i_inc <= 1'b0;
                                        Intf.sad_reg_ld <= 1'b1;
                                        state <= 3'd0;
                                        busy_o <= 1'b0;
                                end
                endcase
        end

endmodule
