module mdc_ctrl(input logic clk, enb, rstn,
                SB.bus Intf);

        logic[3:0] state;

        always @(posedge clk or negedge rstn) begin
                if (~rstn) begin
                        Intf.sel_x = 0; Intf.sel_y = 0;
                        Intf.enb_x = 1; Intf.enb_y = 1;
                        Intf.enb_o = 0;
                        state <= 3'd0;
                end else begin
                        case (state)
                                3'd0:
                                        begin
                                                if (enb) begin
                                                        Intf.sel_x = 0; Intf.sel_y = 0;
                                                        Intf.enb_x = 1; Intf.enb_y = 1;
                                                        Intf.enb_o = 0;
                                                        state <= 3'd1;
                                                end else begin
                                                        state <= 3'd0;
                                                end
                                        end
                                3'd1:
                                        begin
                                                Intf.enb_x = 0;
                                                Intf.enb_y = 0;
                                                if (Intf.x_l_y) begin
                                                        Intf.sel_y = 1;
                                                        Intf.enb_y = 1;
                                                end else begin
                                                        Intf.sel_x = 1;
                                                        Intf.enb_x = 1;
                                                end
                                                state <= 3'd2;
                                        end
                                3'd2:
                                        begin
                                                Intf.enb_x = 0;
                                                Intf.enb_y = 0;
                                                if (~Intf.x_d_y) begin
                                                        Intf.enb_o = 1;
                                                        state <= 3'd0;
                                                end else begin
                                                        state <= 3'd1;
                                                end
                                        end
                        endcase
                end
        end
endmodule
