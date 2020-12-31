module genclk(i_clk, i_delay, o_word, o_stb);
	parameter BW = 32;
	localparam UPSAMPLE = 8;
	input i_clk;
	input [(BW-1):0] i_delay;
	output reg [(UPSAMPLE-1):0] o_word;
	output reg o_stb;
	
	reg [(BW-1):0] counter [0:(UPSAMPLE-1)];
	reg [(BW-1):0] r_delay;
	reg [(BW-1):0] times_three, times_five, times_seven;
	
	initial begin
		counter[0] = 'd0;
	end
	
	always@(posedge i_clk)
		times_three <= {i_delay[(BW-2):0], 1'b0} + i_delay;
		
	always@(posedge i_clk)
		times_five <= {i_delay[(BW-3):0], 2'b0} + i_delay;
		
	always@(posedge i_clk)
		times_seven <= {i_delay[(BW-4):0], 3'b0} - i_delay;
		
	always@(posedge i_clk)
		r_delay <= i_delay;
		
	always @(posedge i_clk)	// Times one
		counter[1] <= counter[0] + r_delay;

	always @(posedge i_clk)	// Times two
		counter[2] <= counter[0] + { r_delay[(BW-2):0], 1'b0 };

	always @(posedge i_clk) // Times three
		counter[3] <= counter[0] + times_three;

	always @(posedge i_clk) // Times four
		counter[4] <= counter[0] + { r_delay[(BW-3):0], 2'b0 };

	always @(posedge i_clk) // Times five
		counter[5]  <= counter[0] + times_five;

	always @(posedge i_clk)
		counter[6]  <= counter[0] + { times_three[(BW-2):0], 1'b0 };

	always @(posedge i_clk)
		counter[7] <= counter[0] + times_seven;

	always @(posedge i_clk) // Times eight---and generating the next clk wrd
		{ o_stb, counter[0] }  <= counter[0] + { r_delay[(BW-4):0], 3'h0 };
		
	always @(posedge i_clk)
		o_word <= {	// High order bit is "first"
			counter[1][(BW-1)],	// First bit
			counter[2][(BW-1)],
			counter[3][(BW-1)],
			counter[4][(BW-1)],
			counter[5][(BW-1)],
			counter[6][(BW-1)],
			counter[7][(BW-1)],
			counter[0][(BW-1)]	// Last bit in order
		};
		
endmodule