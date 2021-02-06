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
	
	logic [3:0] nota = SWI[3:0]; // Valor da nota
	logic situacao = SWI[7]; // Situacao do aluno
	logic [7:0] segments; // Segmentos para mostrar a nota
	
	always_comb begin
		nota = SWI[3:0]; // Atribuicao da nota
		situacao = SWI[7]; // Atribuicao da situacao
	end
	
	always_comb begin
		if (~situacao) // Caso nao queira mostrar a situacao, mostramos a nota
			case (nota)
				'b0000: segments <= 'b0111111; // 0
				'b0001: segments <= 'b0000110; // 1
				'b0010: segments <= 'b1011011; // 2
				'b0011: segments <= 'b1001111; // 3
				'b0100: segments <= 'b1100110; // 4
				'b0101: segments <= 'b1101101; // 5
				'b0110: segments <= 'b1111101; // 6
				'b0111: segments <= 'b0000111; // 7
				'b1000: segments <= 'b1111111; // 8
				'b1001: segments <= 'b1101111; // 9
				'b1010: segments <= 'b1011110; // d de dez
				default: segments <= 'b0000110; // I de impossível
			endcase
		else
			case (nota)
				'b0000: segments <= 'b1110011; // PERDEU < 4
				'b0001: segments <= 'b1110011;
				'b0010: segments <= 'b1110011;
				'b0011: segments <= 'b1110011;
				'b0100: segments <= 'b1110001; // FINAL >= 4 e <= 7
				'b0101: segments <= 'b1110001;
				'b0110: segments <= 'b1110001;
				'b0111: segments <= 'b1110111; // APROVADO >= 7
				'b1000: segments <= 'b1110111;
				'b1001: segments <= 'b1110111;
				'b1010: segments <= 'b1110111;
				default: segments <= 'b0000110; // I de impossível
			endcase
			
	end
	
	always_comb begin
		SEG[7:0] <= segments;
	end
	
endmodule

