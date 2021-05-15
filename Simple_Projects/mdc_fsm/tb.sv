module test;

        logic       clk, rst, enb;
        logic [7:0] dtx_in, dty_in;
        logic [7:0] dt_o;
        int count = 1;

        mdc m(clk, enb, rst, dtx_in, dty_in, dt_o);

        initial begin
                $dumpfile("dump.vcd");
                $dumpvars;
                dtx_in = 8'd86;
                dty_in = 8'd96;
                reset;
                clock(40);
        end

        task reset;
                #1 clk = 0;
                #1 rst = 0;
                #1 rst = 1;
        endtask : reset

        task clock(int i);
                enb = 1;
                repeat(i) begin
                        $display("count = %0d mdc = %1d", count, dt_o);
                        #1 clk = ~clk;
                        #1 clk = ~clk;
                        count = count + 1;
                        if (count == 30) enb = 0;
                end
        endtask : clock
endmodule
