interface SB;

        logic i_inc, i_clr, sum_ld, sum_clr,
                sad_reg_ld, i_it_256;

        modport bus(inout i_inc, i_clr, sum_ld, sum_clr,
                sad_reg_ld, i_it_256);

endinterface


module sad(input  logic         clk_i, enb_i, rst_i,
           input  logic [7:0]   dta_in, dtb_in,
           output logic [31:0]  dt_o,
           output logic         busy_o);

        SB Intf();
        sad_ctrl sc(Intf, clk_i, rst_i, enb_i, busy_o);
        sad_proc sp(Intf, clk_i, rst_i, dta_in, dtb_in, dt_o);

endmodule
