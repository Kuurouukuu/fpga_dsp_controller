module multiplexer(IN, OUT, SEL);

	parameter [4:0] NUM_OF_INPUT = 'd4;
	parameter [4:0] NUM_OF_SEL_BITS = 'd2; // Ceil(log2(NUM_OF_INPUT));

	input [NUM_OF_INPUT-1:0] IN;
	input [NUM_OF_SEL_BITS-1:0] SEL; // Change the SEL bit width when the number of master increase
	output reg OUT;
	
	always@(*)
	begin
		case (SEL)
			'd0:
				OUT <= IN[0];
			'd1:
				OUT <= IN[1];
			'd2:
				OUT <= IN[2];
			'd3:
				OUT <= IN[3];
			default:
				OUT <= 'd0;
		endcase
	end
endmodule
