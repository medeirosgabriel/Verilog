module test;

        logic clk, rst, enb, busy_o;
        logic [7:0] dta_in, dtb_in;
        logic [31:0] dt_o;
        int count = 1;

        sad s(
                clk, enb, rst,
                dta_in, dtb_in,
                dt_o,
                busy_o
        );

        initial begin
                $dumpfile("dump.vcd");
                $dumpvars;
                dta_in = 8'd24;
                dtb_in = 8'd32;
                reset;
                clock(20);
        end

        task reset;
                #1 clk = 0;
                #1 rst = 0;
                #1 rst = 1;
        endtask : reset

        task clock(int i);
                enb = 1;
                repeat(i) begin
                        $display("count = %0d sum = %1d", count, dt_o);
                        #1 clk = ~clk;
                        #1 clk = ~clk;
                        enb = 0;
                        if (count == 15) enb = 1;
                        count = count + 1;
                end
        endtask : clock

endmodule
