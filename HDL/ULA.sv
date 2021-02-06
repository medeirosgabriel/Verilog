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

		logic [1:0] A = SWI[1:0];
		logic [1:0] B = SWI[3:2];
		logic [2:0] operation = SWI[6:4];
		logic [1:0] out;
    
		case (operation)
			'b000: LED[1:0] <= A & B;
			'b001: LED[1:0] <= A | B;
			'b010: LED[1:0] <= A + B;
			'b100: LED[1:0] <= A & ~B;
			'b101: LED[1:0] <= A | ~B;
			'b110: LED[1:0] <= A - B;
			'b111: LED[1:0] <= subF(A, B);
			default: LED[1:0] <= 0;
		endcase
	end
	
	// Fiz essas funcoes para praticar a linguagem! :)
	
	function logic [1:0] subF (logic [1:0] a,b);
		logic [1:0] out;
		logic carryInOut = 0;
		for (int i = 0; i <= 1; i++) begin
			out[i] = (a[i] ^ b[i]) ^ carryInOut;
			carryInOut = (~a[i] & b[i]) + 
						 (~a[i] & carryInOut) +
						 (b[i] & carryInOut);
		end
		subF = out;
	endfunction
	
	function logic [1:0] orNotF (logic [1:0] a,b);
		logic [1:0] out;
		for (int i = 0; i <= 1; i++) begin
			out[i] = a[i] | ~b[i];
		end
		orNotF = out;
	endfunction
	
	function logic [1:0] andNotF (logic [1:0] a,b);
		logic [1:0] out;
		for (int i = 0; i <= 1; i++) begin
			out[i] = a[i] & ~b[i];
		end
		andNotF = out;
	endfunction
	
	function logic [1:0] addF (logic [1:0] a,b);
		logic [1:0] out;
		logic carryInOut = 0;
		for (int i = 0; i <= 1; i++) begin
			out[i] <= (a[i] ^ b[i]) ^ carryInOut;
			carryInOut <= a[i] & b[i];
		end
		addF = out;
	endfunction
	
	function logic [1:0] andF (logic [1:0] a,b);
		logic [1:0] out;
		for (int i = 0; i <= 1; i++) begin
			out[i] = a[i] & b[i];
		end
		andF = out;
	endfunction
	
	function logic [1:0] orF (logic [1:0] a,b);
		logic [1:0] out;
		for (int i = 0; i <= 1; i++) begin
			out[i] = a[i] | b[i];
		end
		orF = out;
	endfunction
	
endmodule
