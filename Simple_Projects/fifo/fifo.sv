interface SB;
        logic valid, ready;
        logic [7:0] data;
        modport m0(inout valid, ready, data);
endinterface

module fifo(input logic clk_i, rstn_i);

        SB IntfSO();
        SB IntfSI();
        source so(IntfSO, clk_i, rstn_i);
        sink si(IntfSI, clk_i, rstn_i);
        logic [7:0] queue [0:7];
        logic [3:0] pointerin, pointerout, elements;
        logic [2:0] stateso, statesi;

        always @(posedge clk_i or negedge rstn_i) begin
                if (~rstn_i) begin
                        stateso <= 2'd0;
                        statesi <= 2'd0;
                        elements <= 4'd0;
                        pointerin <= 4'd0; pointerout <= 4'd0;
                        queue[0] <= 8'd0; queue[1] <= 8'd0;
                        queue[2] <= 8'd0; queue[3] <= 8'd0;
                        queue[4] <= 8'd0; queue[5] <= 8'd0;
                        queue[6] <= 8'd0; queue[7] <= 8'd0;
                end
        end

        always @(posedge clk_i) begin

                case(stateso)

                        2'd0:
                                begin
                                        if (IntfSO.valid == 1'b1 && elements < 4'd8) begin
                                                queue[pointerin] <= IntfSO.data;
                                                pointerin <= pointerin + 1;
                                                elements <= elements + 1;
                                        end

                                        //$display("source -> pointerin = %0d pointerout = %1d data = %2d valid_so = %3d", pointerin, pointerout, IntfSO.data, IntfSO.valid);
                                end

                endcase
        end

        always @(posedge clk_i) begin
                case(statesi)
                        2'd0:
                                begin
                                        if (IntfSI.ready == 1'b1 && elements > 1) begin
                                                IntfSI.data <= queue[pointerout];
                                                pointerout <= pointerout + 1;
                                        end
                                end
                endcase
        end

        always_comb begin
                IntfSO.ready = elements < 4'd8;
                IntfSI.valid = elements > 0;
        end

endmodule
