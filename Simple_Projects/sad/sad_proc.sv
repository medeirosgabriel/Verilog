module sad_proc (SB.bus     Intf,
                 input  logic         clk_i, rst_i,
                 input  logic [7:0]   dta_i, dtb_i,
                 output logic [31:0]  sad_reg);

        logic [31:0] sum;
        logic [7:0]  i, diff;
        logic [7:0] data_a, data_b;

        always @(posedge clk_i or negedge rst_i) begin
                if (~rst_i) begin
                        data_a <= dta_i;
                        data_b <= dtb_i;
                        sum <= 0;
                        i <= 0;
                        diff <= 0;
                        sad_reg <= 0;
                        Intf.i_it_256 <= 1'b1;
                        data_a <= dta_i;
                        data_b <= dtb_i;
                end
                //$display("sum_clr = %0d | sum_ld = %1d | i_inc = %2d | id_clr = %3d | i_it_256 = %4d | sad_reg_ld = %5d | sum = %6d | i = %7d | sad_reg = %8d",
                //Intf.sum_clr, Intf.sum_ld, Intf.i_inc, Intf.i_clr, Intf.i_it_256, Intf.sad_reg_ld, sum, i, sad_reg);
        end

        always @(posedge clk_i) begin
                if (Intf.sum_clr) begin
                        sum <= 0;
                end
                if (Intf.i_clr) begin
                        i <= 0;
                end
        end

        always @(posedge clk_i) begin
                if (Intf.sum_ld) begin
                        if (data_a > data_b) begin
                                diff <= data_a[i] - data_b[i];
                        end else begin
                                diff <= data_b[i] - data_a[i];
                        end
                        if (i < 8) begin // Only Tests
                                sum <= sum + i; // Only Tests
                        end
                end
                if (Intf.i_inc) begin
                        i <= i + 1;
                        if (i < 8) begin
                                Intf.i_it_256 <= 1'b1;
                        end else begin
                                Intf.i_it_256 <= 1'b0;
                        end
                end
        end

        always @(posedge clk_i) begin
                if (Intf.sad_reg_ld) begin
                        sad_reg <= sum;
                end
        end

endmodule
