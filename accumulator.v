module accumulator(
	clk,
	rst,
	accum,
	data,
	ena
);

input clk, rst, ena;
input [7:0]data;
output reg[7:0] accum;

always @(posedge clk or negedge rst) begin
	if(!rst) accum <= 8'h0;
	else begin
	//enable控制
		if(ena) accum <= data;
	end
end
	
endmodule