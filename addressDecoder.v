module addressDecoder(ADR, ACMP0, ACMP1);

	parameter WISHBONE_ADDRESSWIDTH = 'd16;
	input [WISHBONE_ADDRESSWIDTH-1:0] ADR;
	output reg ACMP0, ACMP1;
	
	always@*
	begin
		case (ADR[14:12])
			3'b001: begin
				// Not implicable yet
			end
			3'b010: begin // 0x2000 -0x2fff
				ACMP0 <= 1'b1;
				ACMP1 <= 1'b0;
			end
			3'b011: begin
				ACMP0 <= 1'b1; // 0x3000 - 0x3fff
				ACMP1 <= 1'b0;
			end
			3'b100: begin
				ACMP0 <= 1'b1; // 0x4000 -0x4fff
				ACMP1 <= 1'b0;
			end
			3'b000: begin
				ACMP0 <= 1'b0;
				ACMP1 <= 1'b1;
			end
			default: begin
				ACMP0 <= 1'b0;
				ACMP1 <= 1'b0;
			end
		endcase
	end
endmodule