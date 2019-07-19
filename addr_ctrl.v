//3FFH-0200H RAM
//1FFH-0000H ROM

module addr_ctrl(
	addr,
	rom_,
	ram_
);

input [12:0]addr;
output reg rom_, ram_;

always@(addr) begin
	begin
		case(addr[9])
			10'b1: {rom_, ram_} <= 2'b01;
			10'b0: {rom_, ram_} <= 2'b10;
		default: {rom_, ram_} <= 2'b00;
		endcase
	end
end

endmodule