module wb_compatible_uart
	(CLK_I, DAT_I, DAT_O, RST_I, CYC_O, ACK_I, STB_O, WE_O, ADR_O, STALL_I, GNT, // Wishbone bus
	tx, rx, uart_require//Module signal
	);
	
parameter [4:0] WISHBONE_DATAWIDTH = 'd16;
parameter [4:0] WISHBONE_ADDRESSWIDTH = 'd16;

input CLK_I, RST_I, ACK_I;
input [WISHBONE_DATAWIDTH-1:0] DAT_I;
input GNT;
input STALL_I;
output [WISHBONE_DATAWIDTH-1:0] DAT_O;
output [WISHBONE_ADDRESSWIDTH-1:0] ADR_O;
output CYC_O, STB_O, WE_O;
input uart_require;

output tx;
input rx; 

//Reg

reg [WISHBONE_DATAWIDTH-1:0] dataToLatch = 15'd0;
reg [WISHBONE_DATAWIDTH-1:0] dataToSend = 15'd0;
reg [WISHBONE_ADDRESSWIDTH-1:0] address = 'h0;

reg [3:0] sent_counter = 'd0;
reg [3:0] ack_counter = 'd0;

reg we = 'b0;
reg re = 'b0;
reg cyc = 'b0;
reg stb = 'b0;

assign WE_O = we | ~re;
assign ADR_O = address;
assign DAT_O = dataToSend;
assign CYC_O = cyc;
assign STB_O = stb;

// Module signal
reg bus_trigger;
reg [3:0] num_data_send = 4'd2;
reg [WISHBONE_ADDRESSWIDTH:0] module_address [15:0]; // Buffer
reg [WISHBONE_DATAWIDTH:0] module_data_out [15:0];
reg [WISHBONE_DATAWIDTH:0] module_data_in [15:0];
reg module_we = 1'b0;
wire [3:0] data_left;
assign data_left = num_data_send - sent_counter;

reg [4:0] wishbone_state = 'd0;

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
					cyc <= 1'b1;
					stb <= 1'b0;
					sent_counter <= 4'd0;
					wishbone_state <= 4'd1;
				end else
				begin
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
							wishbone_state <= 4'd5;
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
							wishbone_state <= 4'd5;
					end
				end else // Bus busy, stay in this state
					wishbone_state <= 4'd3;
			end
			4'd4: begin // Finish sending data

			end
			4'd5: begin // Wait for ACK
				stb <= 1'b0;
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

// End Wishbone bus

// UART module instantiation
 reg        rd_uart   = 1'b0;
 reg        wr_uart   = 1'b0;
 reg  [7:0] data_in   = 8'hAB   ;   
 wire [7:0] data_out        ;    
 wire       full            ;
 wire       empty           ;
 wire char_dectected;
	 
 uart #(     .DIVISOR		(15'd976),  // 150Mhz, 9600bps 
				 .DVSR_BIT		(4'd15) ,
				 .Data_Bits		(4'd8) ,
				 .FIFO_Add_Bit	(3'd4)
 ) uart (    .clk				(CLK_I)			,
				 .rd_uart		(rd_uart)	,
				 .reset			(RST_I)		,
				 .rx				(rx)			,
				 .w_data			(data_in)	,
				 .wr_uart		(wr_uart)	,
				 .r_data			(data_out)	,
				 .rx_empty		(empty)		,
				 .tx				(tx)			,
				 .tx_full		(full)		,
				 .char_detected (char_detected)
		  );        


always@(posedge CLK_I)
begin
	if (RST_I)
	begin
	
	end else if (~full)
	begin
		wr_uart     <=  1'b0;
		data_in     <=  data_in + 8'd1;
	end else
		wr_uart <= 1'b0;
end

// UART latch data to send state
reg [3:0] module_state = 4'b0;
reg [1:0] char_detected_tick;
wire char_detected_flag;

always@(posedge CLK_I) // DSP done tick
begin
	char_detected_tick <= {char_detected_tick[0], char_detected_tick[1]};
	char_detected_tick[0] <= char_detected;
end
assign char_detected_flag = char_detected_tick[0] & ~char_detected_tick[1]; // Detect rising edge

always@(posedge CLK_I)
begin
	if (RST_I)
	begin
		module_state <= 4'd0;
	end else
	begin
		case (module_state)
			4'd0: begin
				bus_trigger <= 1'b0;
				if (char_detected_flag)
				begin
					rd_uart <= 1'b1;
					module_state <= 4'd1;
					num_data_send <= 4'd0;
				end
				else begin
					rd_uart <= 1'b0;
					module_state <= 4'd0;
				end
			end
			4'd1: begin
				if (~empty & (num_data_send < 4'd15)) // There is still data in UART and send buffer full
				begin
					num_data_send <= num_data_send + 4'd1;
					module_address[num_data_send] <= 16'h4020 + num_data_send;
					module_data_out[num_data_send] <= data_out;
					module_state <= 4'd1;
				end
				else begin
					rd_uart <= 4'd0;
					module_state <= 4'd2;
				end
			end
			4'd2: begin // Start sending in bus after require data
				module_we <= 1'b1;
				bus_trigger <= 1'b1;
				module_state <= 1'b0;
			end
			default: begin
				module_state <= 1'b0;
			end
		endcase
	end
end

endmodule