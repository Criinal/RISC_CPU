//state 1:high 1:low
//data
//instr{opercode(3), ir_addr(13)}

module IR(
	clk,
	rst,
	ena,
	data,
	instr
);

input clk, rst, ena;
input [7:0]data;
output reg[15:0]instr;

reg state;

always@(posedge clk or negedge rst) begin
	if(!rst) {instr, state} <= 17'b0;
	else begin
		if(ena)begin
			casex (state)
				1'b0: begin
					instr[7:0] <= data;
					state <= 1;
				end
				1'b1: begin
					instr[15:8] <= data;
					state <= 0;
				end
				default: begin
					instr <= 16'hxxxx;
					state <= 1'bx;
				end
			endcase
		end
	end
end

endmodule