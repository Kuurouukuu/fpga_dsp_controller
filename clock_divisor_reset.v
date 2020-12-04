module clock_divisor_reset(clk_in ,divisor, rst, clk_out);

	input clk_in, rst;
	input [31:0] divisor;
	output clk_out;
	
	reg [31:0] counter = 'b0;
	reg clk_strobe = 1'b0;
	
always @(posedge clk_in)
begin
	if (rst)
	begin
		counter <= 0;
		clk_strobe <= 0;
	end else	begin
		if (counter < divisor)
			counter <= counter + 1'b1;
		else if (counter == divisor) begin
			counter <= 0;
			clk_strobe <= ~clk_strobe;
			end
		end
end
assign clk_out = clk_strobe;

endmodule