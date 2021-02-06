// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter NINSTR_BITS = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;

module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NINSTR_BITS-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

	always_comb begin
		lcd_WriteData <= SWI;
		lcd_pc <= 'h12;
		lcd_instruction <= 'h34567890;
		lcd_SrcA <= 'hab;
		lcd_SrcB <= 'hcd;
		lcd_ALUResult <= 'hef;
		lcd_Result <= 'h11;
		lcd_ReadData <= 'h33;
		lcd_MemWrite <= SWI[0];
		lcd_Branch <= SWI[1];
		lcd_MemtoReg <= SWI[2];
		lcd_RegWrite <= SWI[3];
		for(int i=0; i<NREGS_TOP; i++) lcd_registrador[i] <= i+i*16;
		lcd_a <= {56'h1234567890ABCD, SWI};
		lcd_b <= {SWI, 56'hFEDCBA09876543};
	end

	SB Intf();
	logic [7:0] number;
	counter counter(Intf, number);

	always_comb begin
		Intf.direction = SWI[0];
		Intf.reset = SWI[1];
		Intf.clock = clk_2;
		case (number)
			8'd0: SEG <= 8'b00111111;
			8'd1: SEG <= 8'b00000110;
			8'd2: SEG <= 8'b01011011;
			8'd3: SEG <= 8'b01001111;
			8'd4: SEG <= 8'b01100110;
			8'd5: SEG <= 8'b01101101;
			8'd6: SEG <= 8'b01111101;
			8'd7: SEG <= 8'b00000111;
			8'd8: SEG <= 8'b01111111;
			8'd9: SEG <= 8'b01101111;
		endcase
	end


endmodule

interface SB;
	logic direction, reset, clock;
	logic [7:0] count_value;
endinterface

module counter(SB Intf, output logic [7:0] count_value);

	/*always_ff @(posedge Intf.clock or posedge Intf.reset) begin
		if (Intf.reset) begin
			count_value = 8'd0;
		end else if (count_value == 9) begin
			count_value = 0;
		end else begin
			count_value = count_value + 1;
		end
	end*/

	always_ff @(posedge Intf.clock or posedge Intf.reset) begin
		if (Intf.reset) begin
			count_value = 8'd0;
		end else if (Intf.direction == 1) begin
			if (count_value == 9) begin
				count_value = 0;
			end else begin
				count_value  = count_value + 1;
			end
		end else begin
			if (count_value == 0) begin
				count_value = 9;
			end else begin
				count_value  = count_value - 1;
			end
		end
	end

endmodule

