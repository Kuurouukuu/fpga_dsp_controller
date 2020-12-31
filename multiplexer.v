module multiplexer(IN, OUT, SEL);

	parameter [4:0] NUM_OF_INPUT = 'd16;
	parameter [4:0] NUM_OF_SEL_BITS = 'd4; // Ceil(log2(NUM_OF_INPUT));

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
			'd4:
				OUT <= IN[4];
			'd5:
				OUT <= IN[5];
			'd6:
				OUT <= IN[6];
			'd7:
				OUT <= IN[7];
			'd8:
				OUT <= IN[8];
			'd9:
				OUT <= IN[9];
			'd10:
				OUT <= IN[10];
			'd11:
				OUT <= IN[11];
			'd12:
				OUT <= IN[12];
			'd13:
				OUT <= IN[13];
			'd14:
				OUT <= IN[14];
			'd15:
				OUT <= IN[15];
			default:
				OUT <= 'd0;
		endcase
	end
endmodule
