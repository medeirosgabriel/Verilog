interface SB;
        logic valid, ready;
        logic [7:0] data;
        modport m0(inout valid, ready, data);
endinterface

module source_sink(input logic clk_i, rstn_i);

        SB Intf();
        source so(Intf, clk_i, rstn_i);
        sink si(Intf, clk_i, rstn_i);

endmodule
