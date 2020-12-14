`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:15 03/25/2020 
// Design Name: 
// Module Name:    quaDecodeV2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module quad(clk, quadA, quadB, count, rst, o_velocity);
input clk, quadA, quadB, rst;
output [31:0] count;
output [31:0] o_velocity;

reg quadA_delayed, quadB_delayed;
reg [31:0] r_Counter = 'd0;
reg [31:0] r_correct_velocity = 'd0;

always @(posedge clk) quadA_delayed <= quadA;
always @(posedge clk) quadB_delayed <= quadB;

wire count_enable = quadA ^ quadA_delayed ^ quadB ^ quadB_delayed;
wire count_direction = quadA ^ quadB_delayed;

reg [31:0] count_prev = 'd0;
reg [31:0] r_velocity = 'd0;

reg [31:0] count = 'd0; // count for speed calculating
reg [31:0] count2 = 'd0; // count pulse



always @(posedge clk, posedge rst)
begin
  if (rst)
  begin
   r_Counter <= 0;
	count<=0;
	//count_prev <= 0;
  end
  else 
	  begin 
		r_Counter <= r_Counter + 1;
		if(count_enable)
		  begin
			if(count_direction) 
			begin 
				count <= count + 1; 
			end 
			else begin 
				count <= count - 1;
			end
		end
	end
end

always@(posedge rst)
begin
	r_velocity <= count; // Update velocity whenever there is rst signal
end

always@(posedge clk)
begin
	if (count_enable)
		r_correct_velocity <= (count_direction) ? r_velocity : (~r_velocity + 1'd1); // forward and backward direction
end

assign o_velocity = r_correct_velocity;

endmodule
