module test;

        logic clk1, rst;
        int count = 0;
        fifo fifo(clk1, rst);

        initial begin
                $dumpfile("dump.vcd");
                $dumpvars;
                reset;
                clock(30);
        end

        task reset;
                #1 clk1 = 0;
                #1 rst = 0;
                #1 rst = 1;
        endtask : reset

        task clock(int i);
                repeat(i) begin
                        $display("count = %0d", count);
                        #1 clk1 = ~clk1;
                        #1 clk1 = ~clk1;
                        count += 1;
                end
        endtask: clock


endmodule