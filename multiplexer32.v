module multiplexer_n(IN1, IN2, IN3, IN4, OUT, SEL);

	parameter [4:0] INPUT_WIDTH = 'd16;
	parameter [4:0] NUM_OF_SEL_BITS = 'd2; // Ceil(log2(NUM_OF_INPUT));
	
	input [INPUT_WIDTH-1:0] IN1, IN2, IN3, IN4;
	input [NUM_OF_SEL_BITS-1:0] SEL;
	output reg [INPUT_WIDTH-1:0] OUT;
	
	always@(*)
	begin
		case (SEL)
			'd0:
				OUT <= IN1;
			'd1:
				OUT <= IN2;
			'd2:
				OUT <= IN3;
			'd3:
				OUT <= IN4;
			default:
				OUT <= 'd0;
		endcase
	end
endmodule
