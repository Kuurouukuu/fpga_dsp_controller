module wishbone_arbiter(CYC_I, GNT, CYC, GNT_mux, CLK, RST);

	input [15:0] CYC_I;
	input CLK;
	input RST;
	output [3:0] GNT;
	output reg [15:0] GNT_mux;
	output reg CYC;
	
	reg [4:0] state = 0;
	reg [4:0] GNT_local = 'd0;
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
			'd4:
				GNT_mux = 'b1_0000;
			'd5:
				GNT_mux = 'b10_0000;
			'd6:
				GNT_mux = 'b100_0000;
			'd7:
				GNT_mux = 'b1000_0000;
			'd8:
				GNT_mux = 'b1_0000_0000;
			'd9:
				GNT_mux = 'b10_0000_0000;
			'd10:
				GNT_mux = 'b100_0000_0000;
			'd11:
				GNT_mux = 'b1000_0000_0000;
			'd12:
				GNT_mux = 'b1_0000_0000_0000;
			'd13:
				GNT_mux = 'b10_0000_0000_0000;
			'd14:
				GNT_mux = 'b100_0000_0000_0000;
			'd15:
				GNT_mux = 'b1000_0000_0000_0000;
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
				'd0:
					CYC <= CYC_I[0];
				'd1:
					CYC <= CYC_I[1];
				'd2:
					CYC <= CYC_I[2];
				'd3:
					CYC <= CYC_I[3];
				'd4:
					CYC <= CYC_I[4];
				'd5:
					CYC <= CYC_I[5];
				'd6:
					CYC <= CYC_I[6];
				'd7:
					CYC <= CYC_I[7];
				'd8:
					CYC <= CYC_I[8];
				'd9:
					CYC <= CYC_I[9];
				'd10:
					CYC <= CYC_I[10];
				'd11:
					CYC <= CYC_I[11];
				'd12:
					CYC <= CYC_I[12];
				'd13:
					CYC <= CYC_I[13];
				'd14:
					CYC <= CYC_I[14];
				'd15:
					CYC <= CYC_I[15];
				default:
					CYC <= 1'b0;
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
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end
				end else begin
					GNT_local <= 'd0;
					state <= 'd0;
				end
			end
			'd1: begin
				if (bus_require) 
				begin
					if (CYC_I[2]) begin
						GNT_local <= 'd2;
						state <= 'd2;
					end
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
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
				if (bus_require) 
				begin
					if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
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
					if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
			'd4: begin
				if (bus_require) begin
					if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
				end else begin
					GNT_local <= 'd4;
					state <= 'd4;
				end
			end
			'd5: begin
				if (bus_require) begin
					if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end
				end else begin
					GNT_local <= 'd5;
					state <= 'd5;
				end
			end
			'd6: begin
				if (bus_require) begin
					if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
				end else begin
					GNT_local <= 'd6;
					state <= 'd6;
				end
			end
			'd7: begin
				if (bus_require) begin
					if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
				end else begin
					GNT_local <= 'd7;
					state <= 'd7;
				end
			end
			'd8: begin
				if (bus_require) begin
					if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
				end else begin
					GNT_local <= 'd8;
					state <= 'd8;
				end
			end
			'd9: begin
				if (bus_require) begin
					if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end
				end else begin
					GNT_local <= 'd9;
					state <= 'd9;
				end
			end
			'd10: begin
				if (bus_require) begin
					if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					else if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end 
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
				end else begin
					GNT_local <= 'd10;
					state <= 'd10;
				end
			end
			'd11: begin
				if (bus_require) begin
					if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end 
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
				end else begin
					GNT_local <= 'd11;
					state <= 'd11;
				end
			end
			'd12: begin
				if (bus_require) begin
					if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end 
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
				end else begin
					GNT_local <= 'd12;
					state <= 'd12;
				end
			end
			'd13: begin
				if (bus_require) begin
					if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
					else if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end 
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
				end else begin
					GNT_local <= 'd13;
					state <= 'd13;
				end
			end	
			'd14: begin
				if (bus_require) begin
					if (CYC_I[15]) begin
						GNT_local <= 'd15;
						state <= 'd15;
					end 
					else if (CYC_I[0]) begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end 
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
				end else begin
					GNT_local <= 'd14;
					state <= 'd14;
				end
			end
			'd15: begin
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
					else if (CYC_I[3]) begin
						GNT_local <= 'd3;
						state <= 'd3;
					end
					else if (CYC_I[4]) begin
						GNT_local <= 'd4;
						state <= 'd4;
					end 
					else if (CYC_I[5]) begin
						GNT_local <= 'd5;
						state <= 'd5;
					end
					else if (CYC_I[6]) begin
						GNT_local <= 'd6;
						state <= 'd6;
					end
					else if (CYC_I[7]) begin
						GNT_local <= 'd7;
						state <= 'd7;
					end
					else if (CYC_I[8]) begin
						GNT_local <= 'd8;
						state <= 'd8;
					end 
					else if (CYC_I[9]) begin
						GNT_local <= 'd9;
						state <= 'd9;
					end
					else if (CYC_I[10]) begin
						GNT_local <= 'd10;
						state <= 'd10;
					end
					else if (CYC_I[11]) begin
						GNT_local <= 'd11;
						state <= 'd11;
					end
					if (CYC_I[12]) begin
						GNT_local <= 'd12;
						state <= 'd12;
					end
					else if (CYC_I[13]) begin
						GNT_local <= 'd13;
						state <= 'd13;
					end
					else if (CYC_I[14]) begin
						GNT_local <= 'd14;
						state <= 'd14;
					end
				end else begin
					GNT_local <= 'd15;
					state <= 'd15;
				end
			end
		endcase
	end
endmodule
	