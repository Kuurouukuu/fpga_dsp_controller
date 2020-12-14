module wb_compatible_encoder
	(CLK_I, DAT_I, DAT_O, RST_I, CYC_O, ACK_I, STB_O, WE_O, ADR_O, STALL_I, GNT, // Wishbone bus
	ch_A, ch_B, encoder_require//Module signal
	);

parameter [4:0] WISHBONE_DATAWIDTH = 'd15;
parameter [4:0] WISHBONE_ADDRESSWIDTH = 'd15;

input CLK_I, RST_I, ACK_I;
input [WISHBONE_DATAWIDTH:0] DAT_I;
input GNT;
input STALL_I;
output [WISHBONE_DATAWIDTH:0] DAT_O;
output [WISHBONE_ADDRESSWIDTH:0] ADR_O;
output CYC_O, STB_O, WE_O;

// Module port
input ch_A, ch_B, encoder_require;

reg reset = 1'b0;
reg [WISHBONE_DATAWIDTH:0] dataToLatch = 'h0;
reg [5:0] counter = 'h0;
reg [WISHBONE_DATAWIDTH:0] dataToSend = 'h0;
reg [WISHBONE_ADDRESSWIDTH:0] address = 'h0;
reg [WISHBONE_ADDRESSWIDTH:0] data = 'h0;

reg [15:0] sent_counter = 'd0;
reg [15:0] ack_counter = 'd0;
//Wishbone Signal
reg we = 'b0;
reg re = 'b0;
reg cyc = 'b0;
reg stb = 'b0;

wire ack;
assign ack = ACK_I;
assign WE_O = we | ~re;
assign ADR_O = address;
assign DAT_O = dataToSend;
assign CYC_O = cyc;
assign STB_O = stb;

reg [4:0] wishbone_state = 'd0;

// External module signal, if simulation use REG, else use WIRE
wire bus_trigger; // If trigger send -> Update data and address every one cycle
wire [31:0] encoder_counter;
reg [1:0] encoder_require_tick = 'd0;
wire encoder_require_flag;
assign bus_trigger = encoder_require_flag;
// Use this block for REAL

reg module_we = 1'b0;
reg [3:0] num_data_send = 4'd2;
reg [WISHBONE_DATAWIDTH:0] module_memory [1:0];
reg [WISHBONE_DATAWIDTH:0] module_data [1:0];
reg [WISHBONE_ADDRESSWIDTH:0] module_address [1:0];

initial begin
	module_address[0] = 16'h400E;
	module_address[1] = 16'h400F;
	module_we = 1'b1;
end

always@(*)
begin
	module_data[0] = encoder_counter[15:0];
	module_data[1] = encoder_counter[31:16];
end

always@(posedge CLK_I) // Wishbone bus cycles
begin
	if (RST_I) // If reset
	begin
		wishbone_state <= 4'd0;
		sent_counter <= 15'd0;
	end else
	begin
		case (wishbone_state)
			4'd0: begin // Idle
				if (bus_trigger)
				begin
					cyc <= 1'b1;
					stb <= 1'b0;
					wishbone_state <= 4'd1;
				end else
				begin
					wishbone_state <= 4'd0;
					sent_counter <= 15'd0;
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
				begin // This module always write
					if(module_we) // WRITE
					begin
						if (sent_counter < (num_data_send))
						begin
							re <= 1'b0;
							we <= 1'b1;
							stb <= 1'b1;
							address <= module_address[sent_counter];
							dataToSend <= module_data[sent_counter];
							sent_counter <= sent_counter + 15'd1;
							wishbone_state <= 4'd3;
						end else// Write all data
							wishbone_state <= 4'd4;
					end else
					begin // READ
						if (sent_counter < (num_data_send))
						begin
							re <= 1'b1;
							we <= 1'b0;
							stb <= 1'b1;
							address <= module_address[sent_counter];
							sent_counter <= sent_counter + 15'd1;
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
				sent_counter <= 15'd0;
				wishbone_state <= 4'd0;
			end
			default:
				wishbone_state <= 4'd0;
		endcase
	end
end

always@(posedge CLK_I) // ACK handle
begin
	if (cyc == 'b0 | RST_I == 1'b1)
		ack_counter <= 'd0;
	else if (ACK_I & cyc)
	begin
		ack_counter <= ack_counter + 'd1;
		if (re)
		begin
			dataToLatch <= DAT_I;
		end
	end
end

// End wishbone bus
always@(posedge CLK_I) // Sampling time tick
begin
	encoder_require_tick <= {encoder_require_tick[0], encoder_require_tick[1]};
	encoder_require_tick[0] <= encoder_require;
end
assign encoder_require_flag = encoder_require_tick[0] & ~encoder_require_tick[1]; // Detect rising edge

// Module
sigmaV_decoder_top sigmaDecoder(
	.clk(CLK_I), 
	.rst(RST_I), 
	.ch_A(ch_A), 
	.ch_B(ch_B),
	.velocity(encoder_counter)
	);
// synthesis translate_off

// synthesis translate_on
endmodule


