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
module quad(clk, quadA, quadB, count, rst);
input clk, quadA, quadB, rst;
output reg [31:0] count;

reg quadA_delayed, quadB_delayed;

always @(posedge clk) quadA_delayed <= quadA;
always @(posedge clk) quadB_delayed <= quadB;

wire count_enable = quadA ^ quadA_delayed ^ quadB ^ quadB_delayed;
wire count_direction = quadA ^ quadB_delayed;


always @(posedge clk, posedge rst)
begin
  if (rst)
  begin
	count<=0;
	//count_prev <= 0;
  end
  else 
	  begin 
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

endmodule
