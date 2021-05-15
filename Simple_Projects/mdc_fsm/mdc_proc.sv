module mdc_proc(input logic clk, enb,
                input logic [7:0] dtx_i, dty_i,
                output logic [7:0] dto,
                SB.bus Intf);


        logic[7:0] reg_x, reg_y;

        always @(posedge clk) begin
                if (enb) begin
                        //$display("reg_x = %0d reg_y = %1d", reg_x, reg_y);
                        if (Intf.enb_x) begin
                                if (~Intf.sel_x) begin
                                        reg_x <= dtx_i;
                                end else begin
                                        reg_x <= reg_x - reg_y;
                                end
                        end

                        if (Intf.enb_y) begin
                                if (~Intf.sel_y) begin
                                        reg_y <= dty_i;
                                end else begin
                                        reg_y <= reg_y - reg_x;
                                end
                        end

                        if (Intf.enb_o) begin
                                dto <= reg_x;
                        end

                end else begin
                        dto <= 8'bx;
                end
        end

        always_comb begin
                Intf.x_d_y = reg_x != reg_y;
                Intf.x_l_y = reg_x < reg_y;
        end

endmodule
