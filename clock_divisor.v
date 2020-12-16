module wb_compatible_clockDivisor
	(CLK_I, DAT_I, DAT_O, RST_I, CYC_O, ACK_I, STB_O, WE_O, ADR_O, STALL_I, GNT, // Wishbone bus
	sampling_clk, divisor_update, clk_out//Module signal
	);
	
parameter [4:0] WISHBONE_DATAWIDTH = 5'd15;
parameter [4:0] WISHBONE_ADDRESSWIDTH = 5'd15;

input CLK_I, RST_I, ACK_I;
input [WISHBONE_DATAWIDTH:0] DAT_I;
input GNT;
input STALL_I;
output [WISHBONE_DATAWIDTH:0] DAT_O;
output [WISHBONE_ADDRESSWIDTH:0] ADR_O;
output CYC_O, STB_O, WE_O;

input sampling_clk, divisor_update;
output clk_out;

reg [WISHBONE_DATAWIDTH:0] dataToLatch = 15'd0; // Buffer
reg [WISHBONE_DATAWIDTH:0] dataToSend = 15'd0; // Buffer
reg [WISHBONE_ADDRESSWIDTH:0] address = 'h0;

reg [3:0] sent_counter = 'd0;
reg [3:0] ack_counter = 'd0;
//Wishbone Signal
reg we = 'b0;
reg re = 'b0;
reg cyc = 'b0;
reg stb = 'b0;

assign WE_O = we | ~re;
assign ADR_O = address;
assign DAT_O = dataToSend;
assign CYC_O = cyc;
assign STB_O = stb;

reg [4:0] wishbone_state = 'd0;

// External module signal, if simulation use REG, else use WIRE

reg [31:0] counter = 'b0;
reg clk_strobe = 1'b0;
wire divisor_update_flag;
reg [1:0] sampling_tick;
reg [1:0] divisor_update_tick;
reg [31:0] divisor = 'd0;

wire bus_trigger; // If trigger send -> Update data and address every one cycle

reg [3:0] num_data_send = 4'd2;
reg [WISHBONE_ADDRESSWIDTH:0] module_address [1:0];
reg [WISHBONE_DATAWIDTH:0] module_data_out [1:0];
reg [WISHBONE_DATAWIDTH:0] module_data_in [1:0];
reg module_we = 1'b0;
wire [3:0] data_left;
assign data_left = num_data_send - sent_counter;

initial begin
	module_we = 1'b0;
	module_address[0] = 16'h400A;
	module_address[1] = 16'h400B;
	module_data_out[0] = 16'h0000;
	module_data_out[1] = 16'h0000;
end

always@(posedge CLK_I) // Wishbone bus cycles
begin
	if (RST_I) // If reset
	begin
		wishbone_state <= 4'd0;
	end else
	begin
		case (wishbone_state)
			4'd0: begin // Idle
				if (bus_trigger)
				begin
					sent_counter <= 4'd0;
					cyc <= 1'b1;
					stb <= 1'b0;
					wishbone_state <= 4'd1;
				end else
				begin
					cyc <= 1'b0;
					stb <= 1'b0;
					re <= 1'b0;
					we <= 1'b0;
					wishbone_state <= 4'd0;
					sent_counter <= 4'd0;
				end
			end
			4'd1: begin
				if (!GNT) // Wait for grant bus
					wishbone_state <= 4'd1;
				else
					wishbone_state <= 4'd2;
			end
			4'd2: begin
				if (!GNT) // Prevent metastability
					wishbone_state <= 4'd1;
				else
				begin
					wishbone_state <= 4'd3;
				end
			end
			4'd3: begin // Bus granted
				if (!STALL_I) // Slave not busy
				begin // This module always read
					if(module_we) // WRITE
					begin
						if (data_left > 4'd0)
						begin
							re <= 1'b0;
							we <= 1'b1;
							stb <= 1'b1;
							address <= module_address[sent_counter];
							dataToSend <= module_data_out[sent_counter];
							sent_counter <= sent_counter + 4'd1;
							wishbone_state <= 4'd3;
						end else// Write all data
							wishbone_state <= 4'd4;
					end else
					begin // READ
						if (data_left > 4'd0)
						begin
							re <= 1'b1;
							we <= 1'b0;
							stb <= 1'b1;
							address <= module_address[sent_counter];
							sent_counter <= sent_counter + 4'd1;
							wishbone_state <= 4'd3;
						end else// Read all data
							wishbone_state <= 4'd4;
					end
				end else // Bus busy, stay in this state
					wishbone_state <= 4'd3;
			end
			4'd4: begin // Finish sending data
				stb <= 1'b0;
				wishbone_state <= 4'd5;
			end
			4'd5: begin // Wait for ACK
				if (ack_counter == sent_counter)
					wishbone_state <= 4'd6;
				else
					wishbone_state <= 4'd5;
			end
			4'd6: begin  // End cycle
				cyc <= 1'b0;
				re <= 1'b0;
				we <= 1'b0;
				sent_counter <= 4'd0;
				wishbone_state <= 4'd0;
			end
			default:
				wishbone_state <= 4'd0;
		endcase
	end
end

reg data_updated = 1'b0;

always@(posedge CLK_I) // ACK handle
begin
	if (cyc == 'b0 | RST_I == 1'b1)
	begin
		ack_counter <= 'd0;
		data_updated <= 1'b1;
	end else if (ACK_I & cyc)
	begin
		ack_counter <= ack_counter + 4'd1;
		if (!module_we) // If read operation
		begin
			data_updated <= 1'b0;
			module_data_in[ack_counter] <= DAT_I;
		end 
	end
end

// End wishbone bus

// Generate DSP done tick for one cycle
always@(posedge CLK_I) // DSP done tick
begin
	divisor_update_tick <= {divisor_update_tick[0], divisor_update_tick[1]};
	divisor_update_tick[0] <= divisor_update;
end
assign divisor_update_flag = divisor_update_tick[0] & ~divisor_update_tick[1]; // Detect rising edge
assign bus_trigger = divisor_update_flag;

always @(posedge CLK_I)
begin
	if (divisor != 'h0FFFFFFF && divisor != 32'h0000_0000) // When Not zero and infinity
	begin
		if ((counter < divisor))
			counter <= counter + 1'b1;
		else begin
			if (clk_strobe == 0 && CYC_O == 0) // Not participate in any bus 
				divisor <= {module_data_in[1], module_data_in[0]};
			counter <= 0;
			clk_strobe <= ~clk_strobe;
		end
	end else // If zero or infinity Keep updating
	begin if (data_updated)
		divisor <= {module_data_in[1], module_data_in[0]};
	end
end

assign clk_out = clk_strobe;

endmodule
