module wb_arbiter_tb();
// vlog -vlog01compat -work work +incdir+E:/AlteraProject/Wishbone_test {E:/AlteraProject/Wishbone_test/wb_arbiter_tb.v}
	reg CYC0, CYC1, CYC2, CYC3;
	reg CLK, RST;
	
	wire [1:0] GNT;
	wire CYC;
	
	initial begin
		CYC0 = 0;
		CYC1 = 0;
		CYC2 = 0;
		CYC3 = 0;
		CLK = 0;
		RST = 0;
		#100
		forever #5 CLK = ~CLK;
	end
	
	wishbone_arbiter UUT(
		.CYC_I({CYC3, CYC2, CYC1, CYC0}),
		.GNT(GNT), 
		.CYC(CYC), 
		//.GNT_mux, 
		.CLK(CLK), 
		.RST(RST));
		
	initial begin
		@(posedge CLK);
		CYC1 = 1;
		@(posedge CLK);
		CYC0 = 1;
		repeat(5) @(posedge CLK);
		CYC2 = 1;
		CYC3 = 1;
		repeat(5) @(posedge CLK);
		CYC1 = 0;
		repeat(5) @(posedge CLK);
		CYC1 = 1;
		CYC2 = 0;
		repeat(5) @(posedge CLK);
		CYC3 = 0;
		repeat(5) @(posedge CLK);		
	end

endmodule