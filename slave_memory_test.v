module slave_memory(DAT_O, DAT_I, ACK_O, STB_I, WE_I, RST_I, CLK_I, ADR_I, CYC_I);

input CLK_I, RST_I, STB_I, WE_I, CYC_I;
input [31:0] DAT_I;
input [15:0] ADR_I;
output [31:0] DAT_O;
output ACK_O;

reg [31:0] data [7:0];
reg ack = 'b0;
reg [31:0] dataOut = 'h0;

reg [2:0] state = 'b0, state_next = 'b0;

wire [31:0] dataIn;
wire [15:0] address;

assign ACK_O = ack && STB_I; //ACK is valid when STB is high, rule
assign DAT_O = dataOut;
assign dataIn = DAT_I;
assign address = ADR_I;

always@(posedge CLK_I)
begin
	if (RST_I == 1'b1)
		dataOut <= 'h0;
	else 
	begin
		case(state)
		'd0: 
			begin
				if (STB_I == 1'b1 && WE_I == 1'b0 && !ack) // READ cycle and not assert ack yet
				begin
					case (address)
						'h400A: begin
							dataOut <= 'hABCD;
						end
						'h400B: begin
							dataOut <= 'h1234;
						end
						'h2: begin
							dataOut <= data[6];
						end
						'h3: begin
							dataOut <= data[7];
						end
					endcase
					ack <= 1'b1;
				end
				if (STB_I == 1'b1 && WE_I == 1'b1 && !ack) // Write cycles
				begin
					case (address)
						'h0: begin
							data[4] <= dataIn;
						end
						'h1: begin
							data[5] <= dataIn;
						end
						'h2: begin
							data[6] <= dataIn;
						end
						'h3: begin
							data[7] <= dataIn;
						end
					endcase
					ack <= 1'b1;
				end
			state <= 'd1;
		end
		'd1:
			begin
				if (STB_I == 'b0) // End of this data phase
				begin
					state <= 'd0;
					ack <= 'b0;
				end
				else
					state <= 'd1; // Keep holding ack low
			end
		endcase
	end
end

endmodule