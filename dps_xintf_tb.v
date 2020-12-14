// vlog -L work E:/AlteraProject/test_address_range_dsp/dps_xintf_tb.v
// vsim -L altera_mf_ver work.dps_xintf_tb
`define NUM 2000

module dps_xintf_tb;

	reg [14:0] address;
	reg clk;
	reg nRD, nWR;
	reg nCS;
	reg [15:0] dataReg;
	
	wire dsp_reset;
	wire [15:0] data;
	assign data = (nWR == 1'b0 && nCS == 1'b0) ? dataReg : 16'bz;
	
	dps_xintf_test UUT(
		.address(address), 
		.nCS(nCS),
		.data(data),
		.clk(clk),
		.nRD(nRD),
		.nWR(nWR), 
		.dsp_reset(dsp_reset)
//		.dsp_interrupt, 
//		.dsp_done, // Interfacing with dsp
//		.pulse_out, // Used to control driver, differential signal
//		.control, // Used to trigger oscilloscope at maximum frequency
//		.dsp_direction, // Direction signal from dsp
//		.direction, // Control direction of servo motor, LVDS
//		.ch_A, 
//		.ch_B, 
//		.encoder_require // Get encoder data
	);

//	dps_xintf_test UUT(
//		.address(address), 
//		.nCS(nCS),
//		.data(data),
//		.clk(clk),
//		.nRD(nRD),
//		.nWR(nWR), 
//		.dsp_reset(dsp_reset));
		
	reg start = 1'b0;
	reg [31:0] counter = 'd0;
	reg [2:0] state = 'd0;
	reg [2:0] nextState = 'd0;
	reg [4:0] internalCounter = 'd0;
	reg [4:0] nextInternalCounter = 'd0;
		
	initial begin
		address = 7'b0;
		clk = 1'b0;
		nRD = 1'b1;
		nWR = 1'b1;
		nCS = 1'b1;
		
		#100;		
		start = 1'b1;
		address = 'h3FF0;
		forever begin
			#50 clk = ~clk;
		end
	end
	
	initial begin
		@(posedge clk);
		repeat(`NUM*9) begin
			@(posedge clk);
			state = nextState;
			internalCounter = nextInternalCounter;
			writeOperation();
		end
		$display("Write operation done");
		address = 'b0;
		state = 'b0;
		nextState = 'b0;
		nextInternalCounter = 'b0;
		internalCounter = 'b0;
		repeat(`NUM*9) begin
			@(posedge clk);
			state = nextState;
			internalCounter = nextInternalCounter;
			readOperation();
		end
		$display("Read operation done");
	end
	
	task writeOperation;
	begin
		nextInternalCounter = internalCounter + 'd1;
		case(state)
			'd0: begin
				nRD = 1'b1;
				nWR = 1'b1;
				nCS = 1'b0;
				if (internalCounter == 2)
					nextState = 'd1;
			end
			'd1: begin
				nWR = 1'b0;
				nRD = 1'b1;
				nCS = 1'b0;
				dataReg = address - 'h3FFA + 1'd1;
				if (internalCounter == 7)
					nextState = 'd2;
			end
			'd2: begin
				nWR = 1'b1;	
				nRD = 1'b1;
				nCS = 1'b0;
				if (internalCounter == 9)
					nextState = 'd3;
			end
			'd3: begin
				nCS = 1'b1;
				nWR = 1'b1;
				nRD = 1'b1;
				nextState = 'd0;
				nextInternalCounter = 0;
				address = address + 'd1;
			end
		endcase
	end
	endtask
	
	task readOperation;
	begin
		nextInternalCounter = internalCounter + 'd1;
		case(state)
			'd0: begin
				nRD = 1'b1;
				nWR = 1'b1;
				nCS = 1'b0;
				if (internalCounter == 2)
					nextState = 'd1;
			end
			'd1: begin
				nRD = 1'b0;
				nWR = 1'b1;
				nCS = 1'b0;
				//dataReg = address + 1'd1;
				if (internalCounter == 7)
					nextState = 'd2;
			end
			'd2: begin
				nRD = 1'b1;
				nWR = 1'b1;
				nCS = 1'b0;
				if (internalCounter == 9)
					nextState = 'd3;
			end
			'd3: begin
				nCS = 1'b1;
				nRD = 1'b1;
				nWR = 1'b1;
				nextState = 'd0;
				nextInternalCounter = 0;
				address = address + 'd1;
			end
		endcase
	end
	endtask	
endmodule