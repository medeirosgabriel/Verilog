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
	
	// Variáveis da questão "Fim do Expediente"
	
	logic passou_6h, maquinas_fora_de_operacao, 
	sexta_feira, producao_atendida, situacao_1, situacao_2;
	
	// Variáveis da questão "Uma agência bancária"
	
	logic porta_aberta, pode_abrir, horario_expediente,
	interruptor_gerente;
	
	// Variáveis da questão "Uma estufa"
	
	logic temp_menor_que_15, temp_maior_que_20;
	
	// Variáveis da questão "As Aeronaves"
	
	parameter n_banheiros = 3;
	logic [n_banheiros - 1:0] tranca; // Trancas dos banheiros
	logic homem, mulher; // Variáveis lógicas
	
	always_comb begin
	
		// ---------------------- Fim de Expediente ----------------------
		
		passou_6h <= SWI[3]; // Variavel referente a hora. 1 = passou de 6h
		maquinas_fora_de_operacao <= SWI[4]; // Variavel referente ao funcionamento das maquinas. 1 = nao estao funcionando
		sexta_feira <= SWI[5]; // Variavel referente ao dia. 1 = sexta
		producao_atendida <= SWI[6]; // Variavel referente a producao. 1 = producao atendida
		situacao_1 <= passou_6h & maquinas_fora_de_operacao; // Situacao 1 de ativacao do alarme
		situacao_2 <= sexta_feira & producao_atendida & maquinas_fora_de_operacao; // Situacao 2 de ativacao do alarme
		if (situacao_1 | situacao_2) begin // Se algumas das situacoes forem satisfeitas, o alarme ativa
			LED[2] <= 1;
		end
		else begin
			LED[2] <= 0;
		end
		
		// --------------------- Uma agência bancária ---------------------

		porta_aberta <= SWI[0]; // Indica se a porta esta aberta
		horario_expediente <= SWI[1]; // Indica se ainda está no expediente
		interruptor_gerente <= SWI[2]; // Verifica se o interruptor do cliente esta ligado
		pode_abrir <= horario_expediente & ~interruptor_gerente; // Variavel referente as condicoes para abrir o cofre
		if (porta_aberta == 1 & pode_abrir == 0) begin // Se a porta estiver aberta e não for possível abrir, ativa o alarme
			SEG[0] <= 1;
		end
		else begin // Em outra situacao diferente da do if, é permitido abrir
			SEG[0] <= 0;
		end
		
		// -------------------------- Uma estufa --------------------------
		
		temp_menor_que_15 <= ~SWI[3]; // Variavel que indica se a temperatura esta abaixo de 15 graus
		temp_maior_que_20 <= SWI[4]; // Variavel que indica se a temperatura esta aima de 20 graus
		LED[6] = temp_menor_que_15; // Saida referente a temperatura abaixo de 15 graus
		LED[7] = temp_maior_que_20; // Saida referente a temperatura acima de 20 graus
		SEG[7] = ~temp_menor_que_15 & ~temp_maior_que_20; // Saida referente a uma temperatura entre 15 e 20
		
		// ------------------------- As Aeronaves -------------------------

		tranca[n_banheiros - 1:0] <= SWI[n_banheiros-1:0];
		// Mulher pode usar qualquer banheiro (0, 1, 2)
		mulher <= ~tranca[0] | ~tranca[1] | ~tranca[2];
		// Homem só pode usar o banheiro 1 e 2
		homem <= ~tranca[1] | ~tranca[2];

		// Saída referente a banheiros liberados para mulheres
		LED[0] <= mulher;
		// Saída referente a banheiros liberados para homens
		LED[1] <= homem;
	end
endmodule
