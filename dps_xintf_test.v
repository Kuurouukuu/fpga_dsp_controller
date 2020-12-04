module dps_xintf_test(
	clk, // Input clock frequency
	address, nCS, data, nRD, nWR, dsp_reset, dsp_interrupt, dsp_done, // Interfacing with dsp
	pulse_out, // Used to control driver, differential signal
	probe, // Used to observe signal
	trigger, // Used to trigger oscilloscope at maximum frequency
	dsp_direction, // Direction signal from dsp
	direction // Control direction of servo motor, LVDS
	);

	input clk;
	input nRD, nWR; // read, write
	input nCS; //chip select, activelow
	input dsp_done;
	output pulse_out;
	output dsp_reset;
	output dsp_interrupt;
	inout [15:0] data;
	input [14:0] address;
	
	input dsp_direction;
	output probe;
	output trigger;
	output direction;
	
	reg [15:0] dataIn, dataReg;
	reg o_dsp_interrupt = 'b0;
	reg [14:0] internal_address = 'b0;
	reg [31:0] divisor = 'b0;	
	reg [3:0] updateDivisor_state;
	reg [2:0] updateDivisor_counter = 'd0;
	reg divisor_rst = 1'b0;
	
	wire [15:0] internal_data;
	wire clk_1s;
	wire clk_sampling;
	wire [15:0] dataOut;
	wire velocity_control_signal;
	wire sampling_run_1;
	
	parameter [3:0] IDLE = 'd0, WAIT_WRITE_DONE = 'd1, UPDATE_FIRST_BYTE = 'd2, UPDATE_SECOND_BYTE = 'd3;
		
	clock_divisor myClockDivisor( // Generate frequency according to velocity; f_out = f_clk / velocity
		.clk_in(clk),
		.divisor(divisor), // The 32th bit is the sign bit
		.rst(divisor_rst),
		.clk_out(velocity_control_signal));
		
	clock_divisor OneSecondGenerator( // Generate 1 second, used for debug
		.clk_in(clk),
		.divisor('d18_750_000),
		.rst('b0),
		.clk_out(clk_1s));
		
	clock_divisor_reset SamplingFrequencyGenerator( // Generate sampling frequency = 18750000/divisor
		.clk_in(clk),
		.divisor('d187500),
		.rst(~sampling_run_1),
		.clk_out(clk_sampling));
		
	dualport_internal_ram myDualPortRam(
		.address_a ( {4'b0000, address[10:0]} ),
		.address_b ( {4'b0000, internal_address[10:0]} ),
		.clock ( clk ),
		.enable ( 1'b1 ),
		.data_a ( data ),
		//.data_b (), // No data in
		.wren_a ( ~nWR ),
		.wren_b ( 1'b0 ), // Not write for now
		.q_a ( dataOut ),
		.q_b ( internal_data )
	);

	// FSM for update divisor value
	always@(posedge clk)
	begin
		case (updateDivisor_state)
			IDLE: begin
				if (address == 'h400A | address == 'h400B) begin // There is update
					updateDivisor_state <= WAIT_WRITE_DONE;
					divisor_rst <= 1'b1;
				end else begin
					divisor_rst <= 1'b0;
					updateDivisor_state <= IDLE;
				end
			end
			WAIT_WRITE_DONE: begin
				if ( address != 'h400A & address != 'h400B ) begin
					updateDivisor_state <= UPDATE_FIRST_BYTE;
					internal_address <= 'h400A;
				end else
					updateDivisor_state <= updateDivisor_state;
			end
			UPDATE_FIRST_BYTE: begin
				if (updateDivisor_counter == 2) begin
					divisor_rst <= 1'b1;
					updateDivisor_counter <= 'b0;
					divisor[15:0] <= internal_data;
					internal_address <= 'h400b;
					updateDivisor_state <= UPDATE_SECOND_BYTE;
				end else begin
					updateDivisor_counter <= updateDivisor_counter + 'b1;
					updateDivisor_state <= updateDivisor_state;
				end
			end
			UPDATE_SECOND_BYTE: begin
				if (updateDivisor_counter == 2) begin
					divisor_rst <= 1'b1;
					divisor[31:16] <= internal_data;
					internal_address <= 'h400a;
					updateDivisor_state <= IDLE;
				end else begin
					updateDivisor_counter <= updateDivisor_counter + 'b1;
					updateDivisor_state <= updateDivisor_state;
				end
			end
			default: 
				updateDivisor_state <= IDLE;
		endcase
	end
		
	
	assign data = (nCS == 1'b0 && nRD == 1'b0) ? dataOut : 'hz;  // Select and read.
	
	// Always pull high
	assign dsp_reset = 1'b1;
	
	// Output to driver
	assign pulse_out = velocity_control_signal;
	
	// DSP External Interrupt
	assign sampling_run_1 = ~dsp_done;	
	assign dsp_interrupt = clk_sampling;
	assign direction = dsp_direction;
endmodule