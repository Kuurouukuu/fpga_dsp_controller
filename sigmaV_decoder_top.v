module sigmaV_decoder_top(clk, rst, ch_A, ch_B, count);

	input clk, rst, ch_A, ch_B;
	output [31:0] count;
	
	wire debounced_chA, debounced_chB;
	
	
	DeBounce debounce_A(
		.clk(clk), 
		.n_reset('b1), 
		.button_in(ch_A),
		.DB_out(debounced_chA)
		);
		
	DeBounce debounce_B(
		.clk(clk), 
		.n_reset('b1), 
		.button_in(ch_B),
		.DB_out(debounced_chB)
		);
	
	quad quadDecoder(
	.clk(clk), 
	.quadA(debounced_chA), 
	.quadB(debounced_chB), 
	.count(count), 
	.rst(rst)
	);
	
//	always@(posedge clk)
//	begin
//		counter <= counter + 1'd1;
//		sampling_clk[1] <= sampling_clk[0];
//	end
//	
//	always@(posedge counter[12])
//	begin
//		sampling_clk[0] <= ~sampling_clk[0];
//	end
//	
//	assign w_sampling_clk = sampling_clk[0] ^ sampling_clk[1]; // Generate sampling clock

endmodule
