module dps_xintf_test(
	clk, reset, // Input clock frequency and reset signal
	address, nCS, data, nRD, nWR, dsp_reset, dsp_interrupt, dsp_done, // Interfacing with dsp
	pulse_out, // Used to control driver, differential signal
	pulse_out_motor2,
	pulse_out_motor3,
	pulse_out_motor4,
	probe, // Used to observe signal
	control, // Used to trigger oscilloscope at maximum frequency
	dsp_direction, // Direction signal from dsp
	direction, // Control direction of servo motor, LVDS
	calculating_indicator, // Indicate that DSP is calculating
	ch_A, ch_B, encoder_require, // Get encoder data
	uart_tx, uart_rx, uart_require,
	SEN
	);
	
	input clk, reset;
	input nRD, nWR; // read, write
	input nCS; //chip select, activelow
	input dsp_done;
	input calculating_indicator;
	
	input SEN;
	
	output pulse_out;
	output pulse_out_motor2;
	output pulse_out_motor3;
	output pulse_out_motor4;
	output dsp_reset;
	output dsp_interrupt;
	input ch_A, ch_B, encoder_require;
	inout [15:0] data;
	input [14:0] address;
	
	input dsp_direction;
	output probe;
	output direction;
	output control;
	
	input uart_rx;
	output uart_tx;
	input uart_require;
	
	wire rst;
	assign rst = ~reset;
	
	// DEBUG SECTION
	assign probe = calculating_indicator; 
	
	parameter [4:0] WISHBONE_DATAWIDTH = 'd16;
	parameter [4:0] WISHBONE_ADDRESSWIDTH = 'd16;
	parameter [4:0] NUM_OF_MASTER = 'd16;
	parameter [4:0] NUM_OF_SEL_BITS = 'd4; // = Ceil(log2(NUM_OF_MASTER));
	parameter [4:0] MAX_BUFFER_SIZE = 'd4;
	
	reg [15:0] dataIn, dataReg;	
	reg [3:0] updateDivisor_state = 'd0;
	reg divisor_update = 1'b0;
	reg [1:0] SEN_reg = 2'b0;
	reg [1:0] calculating_indicator_reg = 2'b0;
	
	wire SEN_flag;
	wire clk_1s;
	wire clk_sampling;
	wire [15:0] dataOut;
	wire velocity_control_signal, velocity_control_signal_motor2, velocity_control_signal_motor3, velocity_control_signal_motor4;
	wire sampling_run_1;
	
	// Wishbone signal
	wire [15:0] DAT_m1_clockDivisor, DAT_m2_encoder, DAT_m3_clockDivisor, DAT_m4_clockDivisor, DAT_m5_clockDivisor;
	wire [15:0] DAT_s1, DAT_s2;
	wire STB_m1_clockDivisor, STB_s1, STB_m2_encoder, STB_m3_clockDivisor, STB_m4_clockDivisor, STB_m5_clockDivisor;
	wire WE_m1_clockDivisor, WEI_s1, WE_m2_encoder, WE_m3_clockDivisor, WE_m4_clockDivisor, WE_m5_clockDivisor;
	wire ACK_s1, ACK_m1_clockDivisor, ACK_m2_encoder, ACK_m3_clockDivisor, ACK_m4_clockDivisor, ACK_m5_clockDivisor;
	wire [15:0] ADR_m1_clockDivisor, ADR_m2_encoder, ADR_m3_clockDivisor, ADRI_s1, ADR_m4_clockDivisor, ADR_m5_clockDivisor;
	wire CYC_m1_clockDivisor, CYC_m2_encoder, CYC_m3_clockDivisor, CYC_m4_clockDivisor, CYC_m5_clockDivisor;
	wire STALL_s1;

	//Shared bus wire
	wire [NUM_OF_SEL_BITS-1:0] GNT;
	wire [WISHBONE_DATAWIDTH-1:0] DAT; // 16 bit data bus
	wire [WISHBONE_ADDRESSWIDTH-1:0] ADR;
	wire STB;
	wire WE;
	wire CYC;
	wire ACK;
	wire STALL;
	wire [WISHBONE_DATAWIDTH-1:0] DAT_fromSlave; // Data output from slave	
	wire ACMP0, ACMP1; // TODO: change according to number of master
	wire [15:0] GNT_mux;
	// End wishbone signal

	
	parameter [3:0] IDLE = 'd0, WAIT_WRITE_DONE = 'd1, UPDATE_FIRST_BYTE = 'd2, UPDATE_SECOND_BYTE = 'd3;
	
	wire clk_375mhz;
//	pll_clock myClockGenerator(
//		//.areset,
//		.inclk0(clk),
//		.c0(clk_375mhz)
//		//.locked
//		);

	//Master 1: Generate frequency = velocity / divisor
	wb_compatible_clockDivisor #(.DATA_HIGH(16'h400A), .DATA_LOW(16'h400B)) myClockDivisor(
		.sampling_clk(clk_sampling), 
		.divisor_update(calculating_indicator_flag), // Get sampling tick
		.DAT_I(DAT_fromSlave), 
		.DAT_O(DAT_m1_clockDivisor), 
		.RST_I(rst), 
		.CYC_O(CYC_m1_clockDivisor), 
		.ACK_I(ACK_m1_clockDivisor), 
		.STB_O(STB_m1_clockDivisor), 
		.WE_O(WE_m1_clockDivisor), 
		.ADR_O(ADR_m1_clockDivisor), 
		.GNT(GNT_mux[0]), 
		.STALL_I(STALL),
		.CLK_I(clk),// Wishbone interface
		.clk_divide(clk_375mhz),
		.clk_out(velocity_control_signal) // output control signal
	);
	
	//Master 2: Decoder
	wb_compatible_encoder decoder(
		.CLK_I(clk),
		.DAT_I(DAT_fromSlave),
		.DAT_O(DAT_m2_encoder),
		.RST_I(rst),
		.CYC_O(CYC_m2_encoder),
		.ACK_I(ACK_m2_encoder),
		.STB_O(STB_m2_encoder),
		.WE_O(WE_m2_encoder),
		.ADR_O(ADR_m2_encoder),
		.STALL_I(STALL),
		.GNT(GNT_mux[1]),		
		.ch_A(ch_A),
		.ch_B(ch_B),
		.encoder_require(encoder_require)
	);

	//Master 3: CLock divisor for Motor2
	wb_compatible_clockDivisor #(.DATA_HIGH(16'h401A), .DATA_LOW(16'h401B)) myClockDivisor_2(
		.sampling_clk(clk_sampling), 
		.divisor_update(calculating_indicator_flag), // Get sampling tick
		.DAT_I(DAT_fromSlave), 
		.DAT_O(DAT_m3_clockDivisor), 
		.RST_I(rst), 
		.CYC_O(CYC_m3_clockDivisor), 
		.ACK_I(ACK_m3_clockDivisor), 
		.STB_O(STB_m3_clockDivisor), 
		.WE_O(WE_m3_clockDivisor), 
		.ADR_O(ADR_m3_clockDivisor), 
		.GNT(GNT_mux[2]), 
		.STALL_I(STALL),
		.CLK_I(clk),// Wishbone interface
		.clk_divide(clk_375mhz),
		.clk_out(velocity_control_signal_motor2) // output control signal
	);

	wb_compatible_clockDivisor #(.DATA_HIGH(16'h402A), .DATA_LOW(16'h402B)) myClockDivisor_3(
		.sampling_clk(clk_sampling), 
		.divisor_update(calculating_indicator_flag), // Get sampling tick
		.DAT_I(DAT_fromSlave), 
		.DAT_O(DAT_m4_clockDivisor), 
		.RST_I(rst), 
		.CYC_O(CYC_m4_clockDivisor), 
		.ACK_I(ACK_m4_clockDivisor), 
		.STB_O(STB_m4_clockDivisor), 
		.WE_O(WE_m4_clockDivisor), 
		.ADR_O(ADR_m4_clockDivisor), 
		.GNT(GNT_mux[3]), 
		.STALL_I(STALL),
		.CLK_I(clk),// Wishbone interface
		.clk_divide(clk_375mhz),
		.clk_out(velocity_control_signal_motor3) // output control signal
	);
	
	wb_compatible_clockDivisor #(.DATA_HIGH(16'h403A), .DATA_LOW(16'h403B)) myClockDivisor_4(
		.sampling_clk(clk_sampling), 
		.divisor_update(calculating_indicator_flag), // Get sampling tick
		.DAT_I(DAT_fromSlave), 
		.DAT_O(DAT_m5_clockDivisor), 
		.RST_I(rst), 
		.CYC_O(CYC_m5_clockDivisor), 
		.ACK_I(ACK_m5_clockDivisor), 
		.STB_O(STB_m5_clockDivisor), 
		.WE_O(WE_m5_clockDivisor), 
		.ADR_O(ADR_m5_clockDivisor), 
		.GNT(GNT_mux[4]), 
		.STALL_I(STALL),
		.CLK_I(clk),// Wishbone interface
		.clk_divide(clk_375mhz),
		.clk_out(velocity_control_signal_motor4) // output control signal
	);
	
	clock_divisor_reset SamplingFrequencyGenerator( // Generate sampling frequency = 18750000/divisor
		.clk_in(clk),
		.divisor('d187500),
		.rst(~sampling_run_1),
		.clk_out(clk_sampling));

	reg [2:0] delayed_ack = 3'd0;
	dualport_internal_ram myDualPortRam( // Slave 1
		.address_a ( {4'b0000, address[10:0]} ), // DSP Address
		.address_b ( {4'b0000, ADR[10:0] }), // Internal address
		.clock_a ( clk ),
		.clock_b ( clk ), // Both used clock from DSP
		.enable_a ( 1'b1 ),
		.enable_b ( 1'b1 ),
		.data_a ( data ), // Data in from dsp
		.data_b (DAT), // Data in from wishbone bus
		.wren_a ( ~(nWR) & ~(nCS) ), // Controlled by DSP
		.wren_b ( WE & STB_s1 ), // Write when WE high and STB_s1 is high
		.q_a ( dataOut ), // To DSP
		.q_b ( DAT_s1 ) // Internal bus
	);	
	assign STB_s1 = STB & CYC & ACMP0;
	assign ACK_s1 = delayed_ack[1];
	assign STALL_s1 = 1'b0;
	
	always@(posedge clk)
	begin
		delayed_ack <= {delayed_ack[1], delayed_ack[0], STB_s1};		
	end
	
	assign data = (nCS == 1'b0 && nRD == 1'b0) ? dataOut : 16'hz;  // Select and read.
	
	// Always pull high
	assign dsp_reset = reset;
	
	// Output to driver
	assign pulse_out = velocity_control_signal;
	assign pulse_out_motor2 = velocity_control_signal_motor2;
	assign pulse_out_motor3 = velocity_control_signal_motor3;
	assign pulse_out_motor4 = velocity_control_signal_motor4;
	
	// DSP External Interrupt
	assign sampling_run_1 = ~dsp_done;	
	assign dsp_interrupt = clk_sampling;
	assign direction = dsp_direction;
	
	// Calculating start detector, posedge
	always@(posedge clk)
	begin
		calculating_indicator_reg <= {calculating_indicator_reg[0], calculating_indicator_reg[1]};
		calculating_indicator_reg[0] <= calculating_indicator;
	end
	assign calculating_indicator_flag = calculating_indicator_reg[0] & ~calculating_indicator_reg[1];
	
	// SEN edge detector
	always@(posedge clk)
	begin
		SEN_reg <= {SEN_reg[0], SEN_reg[1]};
		SEN_reg[0] <= SEN;
	end
	assign SEN_flag = SEN_reg[0] & ~SEN_reg[1];
	/* Wishbone bus------------------------------------------*/
	
	assign ACK = ACK_s1; // Will use multi-input OR later
	assign ACK_m1_clockDivisor = ACK & GNT_mux[0];
	assign ACK_m2_encoder = ACK & GNT_mux[1];
	assign ACK_m3_clockDivisor = ACK & GNT_mux[2];
	assign ACK_m4_clockDivisor = ACK & GNT_mux[3];
	assign ACK_m5_clockDivisor = ACK & GNT_mux[4];
	assign STALL = STALL_s1;

	// Multiplexer part - Master
	multiplexer_n #(.INPUT_WIDTH(WISHBONE_ADDRESSWIDTH)) ADR_mux(
		.IN1(ADR_m1_clockDivisor),
		.IN2(ADR_m2_encoder),
		.IN3(ADR_m3_clockDivisor),
		.IN4(ADR_m4_clockDivisor),
		.IN5(ADR_m5_clockDivisor),
		.OUT(ADR),
		.SEL(GNT));
		
	multiplexer_n #(.INPUT_WIDTH(WISHBONE_DATAWIDTH)) DATA_mux(
		.IN1(DAT_m1_clockDivisor),
		.IN2(DAT_m2_encoder),
		.IN3(DAT_m3_clockDivisor),
		.IN4(DAT_m4_clockDivisor),
		.IN5(DAT_m5_clockDivisor),
		.OUT(DAT),
		.SEL(GNT)
	);

	multiplexer #(.NUM_OF_INPUT(NUM_OF_MASTER), .NUM_OF_SEL_BITS(NUM_OF_SEL_BITS)) WE_mux(
		.IN({WE_m5_clockDivisor, WE_m4_clockDivisor, WE_m3_clockDivisor, WE_m2_encoder, WE_m1_clockDivisor}),
		.OUT(WE),
		.SEL(GNT));

	multiplexer #(.NUM_OF_INPUT(NUM_OF_MASTER), .NUM_OF_SEL_BITS(NUM_OF_SEL_BITS)) STB_mux(
		.IN({STB_m5_clockDivisor, STB_m4_clockDivisor, STB_m3_clockDivisor, STB_m2_encoder, STB_m1_clockDivisor}),
		.OUT(STB),
		.SEL(GNT));
	
	// Arbiter part
	wishbone_arbiter arbiter(
		.CYC_I({CYC_m5_clockDivisor, CYC_m4_clockDivisor, CYC_m3_clockDivisor, CYC_m2_encoder, CYC_m1_clockDivisor}), 
		.GNT(GNT),
		.CYC(CYC),
		.GNT_mux(GNT_mux),
		.CLK(clk));
		
	addressDecoder #(.WISHBONE_ADDRESSWIDTH(WISHBONE_ADDRESSWIDTH))	addressDecoder(
		.ADR(ADR),
		.ACMP0(ACMP0), 
		.ACMP1(ACMP1)
	);
	
	// Multiplexer part - slave	
	multiplexer_onehot#(.INPUT_WIDTH(WISHBONE_DATAWIDTH), .NUM_OF_SEL_BITS(4))	DATA_fromSlave_mux(
		.IN1(DAT_s1),
		.IN2(DAT_s2),
		//.IN3(),
		//.IN4(),
		.OUT(DAT_fromSlave),
		.SEL({1'b0, 1'b0, ACMP1, ACMP0})
	);
endmodule