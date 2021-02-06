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
	
	always_comb begin
	
		logic [2:0] A1 = SWI[7:5]; // Valor de A
		logic signed [2:0] A2 = SWI[7:5]; // Valor de A inteiro
		logic [2:0] B1 = SWI[2:0]; // Valor de B
		logic signed [2:0] B2 = SWI[2:0]; // Valor de B inteiro
		logic [1:0] F = SWI[4:3]; // Operacao
		logic [7:0] out;
		
		case (F)
			'b00: LED[7:0] <= A1 + B1;
			'b01: LED[7:0] <= A1 - B1;
			'b10: LED[7:0] <= A1 * B1;
			'b11: LED[7:0] <= A2 * B2;
		endcase
		
	end
	
endmodule
