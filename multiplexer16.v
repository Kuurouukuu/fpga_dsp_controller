module multiplexer16(IN1, IN2, OUT, SEL);

	input [15:0] IN1, IN2;
	input [1:0] SEL;
	output reg [15:0] OUT;
	
	always@(*)
	begin
		case (SEL)
			'b01:
				OUT <= IN1;
			'b10:
				OUT <= IN2;
			default:
				;
		endcase
	end
endmodule
