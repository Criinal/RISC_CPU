//`timescale 1ns/1ps
//jmp： 加载ir_addr到pc_addr
module counter(
	pc_addr,
	ir_addr,
	load,
	clk,
	rst,
	inc_pc
);

input clk, rst, inc_pc, load;
output reg[12:0] pc_addr;
input [12:0] ir_addr;

always@(posedge clk or negedge rst)begin
	if(!rst) pc_addr = 13'h0;
	else if(inc_pc) pc_addr <= pc_addr+1;
	else if(load) pc_addr <= ir_addr;
end

endmodule