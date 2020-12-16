module wishbone_arbiter(CYC_I, GNT, CYC, GNT_mux, CLK, RST);

	input [3:0] CYC_I;
	input CLK;
	input RST;
	output [1:0] GNT;
	output reg [3:0] GNT_mux;
	output reg CYC;
	
	reg [3:0] state = 0;
	reg [1:0] GNT_local = 'd0;
	reg bus_require = 'b0;
	
	assign GNT = GNT_local;
	
	always@(*)
	begin
		case (GNT_local)
			'd0:
				GNT_mux = 'b0001;
			'd1:
				GNT_mux = 'b0010;
			'd2:
				GNT_mux = 'b0100;
			'd3:
				GNT_mux = 'b1000;
			default:
				GNT_mux = 'b0000;
		endcase
	end
	
	always@(*)
	begin
	if(RST)
		bus_require = 0;
	else
		bus_require = |CYC_I & ~CYC; // Some master required bus and bus is not granted
	end
	
	always@(*)
	begin
		if(RST)
			CYC = 0;
		else
			case (GNT)
				'd0: begin
					CYC = CYC_I[0];	
				end
				'd1: begin
					CYC = CYC_I[1];
				end
				'd2: begin
					CYC = CYC_I[2];
				end
				'd3: begin
					CYC = CYC_I[3];
				end
				default:
					CYC = 1'b0;
			endcase
	end

	
	always@(posedge CLK)
	begin
		case (state)
			'd0: begin
				if (bus_require) begin
					if (CYC_I[1]) begin
						GNT_local <= 'd1;
						state <= 'd1;
					end
					else if (CYC_I[2]) begin
						GNT_local <= 'd2;
						state <= 'd2;
					end
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
				end else begin
					GNT_local <= 'd0;
					state <= 'd0;
				end
			end
			'd1: begin
				if (bus_require) begin
					if (CYC_I[2]) begin
						GNT_local <= 'd2;
						state <= 'd2;
					end
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[0]) begin
						GNT_local <= 'd0;
						state <= 'd0;
					end
				end else begin
					GNT_local <= 'd1;
					state <= 'd1;
				end
			end
			'd2: begin				
				if (bus_require) begin
					if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[0]) begin
						GNT_local <= 'd0;
						state <= 'd0;
					end
					else if (CYC_I[1]) begin
						GNT_local <= 'd1;
						state <= 'd1;
					end
				end else begin
					GNT_local <= 'd2;
					state <= 'd2;
				end
			end
			'd3: begin
				if (bus_require) begin
					if (CYC_I[0]) begin
						GNT_local <= 'd0;
						state <= 'd0;
					end
					else if (CYC_I[1]) begin
						GNT_local <= 'd1;
						state <= 'd1;
					end
					else if (CYC_I[2]) begin
						GNT_local <= 'd2;
						state <= 'd2;
					end
				end else begin
					GNT_local <= 'd3;
					state <= 'd3;
				end
			end
		endcase
	end
endmodule
	