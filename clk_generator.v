//clk1 = ~clk
//fetch 1:pc_addr 0:ir_addr
//con_alu run on special time
module clk_generator(
	clk,
	rst,
	clk1,
	fetch,
	con_alu
);

input clk, rst;
output reg fetch, con_alu;
output clk1;
wire clk1;
reg [2:0]count;

assign clk1=~clk;

always@(posedge clk or negedge rst) begin
	if(!rst) count <= 2'b0;
	else if(count == 7)
		count <= 0;
	else count <= count + 1;
end

//count == 0-3 fetch = 1
//count == 4-7 fetch = 0
//前四个周期读取指令，选择pc 后四个周期用于处理指令，选择ir
//count == 5 con_alu = 1
always@(posedge clk or negedge rst)begin
	if(!rst)begin
		fetch <= 0;
		con_alu <= 0;
	end
	//{fetch, con_alu} <= 2'b0;
	else begin
		if(count == 5)con_alu <= 1;
		else con_alu <= 0;
		case (count)
			0:fetch = 1;
			1:fetch = 1;
			2:fetch = 1;
			3:fetch = 1;
			default fetch = 0;
		endcase
	end
end

endmodule
