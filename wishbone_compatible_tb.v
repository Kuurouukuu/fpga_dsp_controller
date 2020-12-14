//vlog -vlog01compat -work work +incdir+E:/AlteraProject/sigmaV_decoder {E:\AlteraProject\test_address_range_dsp/wishbone_compatible_tb.v}
//vlog -vlog01compat -work work +incdir+E:/AlteraProject/sigmaV_decoder {E:\AlteraProject\test_address_range_dsp/slave_memory_test.v}

module wishbone_compatible_testbench;

	reg clk;
	reg rst;
	reg [15:0] address = 'h0000;
	
	wire [31:0] DAT_m1, DAT_s1, DAT_m2;
	wire [31:0] DATI_s1, DATI_m1, DATI_m2;
	wire STB_m1, STBI_s1, STB_m2;
	wire WE_m1, WEI_s1, WE_m2;
	wire ACK_s1, ACK_m1, ACK_m2;
	wire [15:0] ADR_m1, ADR_m2, ADRI_s1;
	wire CYC_m1, CYC_m2;
	
	wire clk_out;
	
	reg sampling_clk = 'b0;	
	reg [2:0] updateDivisor_state = 'd0;
	reg divisor_update = 'b0;
	reg [31:0] counter = 'd0;
	
	parameter [3:0] IDLE = 'd0, WAIT_WRITE_DONE = 'd1, UPDATE_FIRST_BYTE = 'd2, UPDATE_SECOND_BYTE = 'd3;
	
	initial begin
		clk = 0;
		rst = 0;
		
		#100
		forever #5 clk = ~clk;
	end
	
	initial begin
		@(posedge clk);
		repeat(10)
			@(posedge clk);
		sampling_clk = 'b1;
		@(posedge clk);
		sampling_clk = 'b0;
		#100
		address = 'h400A;
		#100
		address = 'h400B;
		#100
		address = 'h400C;
	end
	
	clock_divisor myClockDivisor(
		.sampling_clk(sampling_clk), 
		.divisor_update(divisor_update), // Get sampling tick
		.DAT_I(DAT_s1), 
		.DAT_O(DAT_m1), 
		.RST_I(rst), 
		.CYC_O(CYC_m1), 
		.ACK_I(ACK_s1), 
		.STB_O(STB_m1), 
		.WE_O(WE_m1), 
		.ADR_O(ADR_m1), 
		//.GNT, 
		.CLK_I(clk),// Wishbone interface
		.clk_out(clk_out) // output control signal
	); 
	
	slave_memory testMemroy(
		.DAT_O(DAT_s1), 
		.DAT_I(DAT_m1), 
		.ACK_O(ACK_s1), 
		.STB_I(STB_m1), 
		.WE_I(WE_m1), 
		.RST_I(rst), 
		.CLK_I(clk), 
		.ADR_I(ADR_m1), 
		.CYC_I(CYC_m1)
	);

	always@(posedge clk)
	begin
		case (updateDivisor_state)
			IDLE: begin
				if (address == 'h400A | address == 'h400B) begin // There is update
					updateDivisor_state <= WAIT_WRITE_DONE;
					divisor_update <= 1'b0;
				end else begin
					updateDivisor_state <= IDLE;
				end
			end
			WAIT_WRITE_DONE: 
			begin
				if ( address != 'h400A & address != 'h400B ) 
				begin
					updateDivisor_state <= IDLE;
					divisor_update <= 1'b1;
				end else
					updateDivisor_state <= updateDivisor_state;
			end
			default: 
			begin
				updateDivisor_state <= IDLE;
				divisor_update <= 1'b0;
			end
		endcase
	end
endmodule
	
	
	
	