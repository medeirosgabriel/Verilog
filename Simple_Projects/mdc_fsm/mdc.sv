interface SB;
        logic sel_x, sel_y,
                enb_x, enb_y,
                x_d_y, x_l_y, enb_o;

        modport bus(inout sel_x, sel_y, enb_x, enb_y, x_d_y, x_l_y, enb_o);
endinterface


module mdc(input logic clk_i, enb_i, rstn_i,
           input logic [7:0] dtx_in, dty_in,
           output logic [7:0] dt_o);

        SB Intf();
        mdc_ctrl mc(clk_i, enb_i, rstn_i, Intf);
        mdc_proc mp(clk_i, enb_i, dtx_in, dty_in, dt_o, Intf);

endmodule