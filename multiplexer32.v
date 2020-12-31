module multiplexer_n(IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8,
	IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16, OUT, SEL);

	parameter [4:0] INPUT_WIDTH = 'd16;
	parameter [4:0] NUM_OF_SEL_BITS = 'd4; // Ceil(log2(NUM_OF_INPUT));
	
	input [INPUT_WIDTH-1:0] IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8;
	input [INPUT_WIDTH-1:0] IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16;
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
			'd4:
				OUT <= IN5;
			'd5:
				OUT <= IN6;
			'd6:
				OUT <= IN7;
			'd7:
				OUT <= IN8;
			'd8:
				OUT <= IN9;
			'd9:
				OUT <= IN10;
			'd10:
				OUT <= IN11;
			'd11:
				OUT <= IN12;
			'd12:
				OUT <= IN13;
			'd13:
				OUT <= IN14;
			'd14:
				OUT <= IN15;
			'd15:
				OUT <= IN16;
			default:
				OUT <= 'd0;
		endcase
	end
endmodule
