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

	enum logic [3:0] {s0,s1,s2,s3} state;
	SB sb();
	top2 top2(sb, SEG);

	always_ff @(posedge clk_2) begin
		case (state)
			s0: state <= s1;
			s1: state <= s2;
			s2: state <= s3;
			s3: state <= s0;
		endcase
		sb.s <= state;
	end
	
endmodule

interface SB;
	int s;
endinterface

module top2(SB sb, output logic [7:0] SEG);
	always_comb begin
		case(sb.s)
			4'b00: SEG <= 8'b0111111;
			4'b01: SEG <= 8'b0000110;
			4'b10: SEG <= 8'b1011011;
			4'b11: SEG <= 8'b1001111;
		endcase
	end
endmodule

