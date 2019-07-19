//`timescale 1ps/1ps
module RISC_CPU(
	clksource,
	data,
	fetch,
	rst,
	rd,
	wr,
	addr,
	HALT,
	seg,
	number,
	number1,
	number2,
	number3,
	led
);

input clksource, rst;
/*
wire clksource, rst;
RISC_CPU_tb RISC_CPU_tb(
	.clk(clksource),
	.rst(rst)
);
*/
output rd,wr,HALT,fetch;
output[12:0] addr;
inout[7:0]data;
output reg number2,number3;
output reg[3:0]led;
wire con_alu, clk1;
//前三位操作指令，后十三位地址
wire [2:0]opcode;
wire[12:0]ir_addr;

wire[7:0]accum,alu_out;
wire zero;
wire[12:0] pc_addr;
wire load_acc, load_pc, load_ir, datactr_ena, inc_pc;

//将accumulator里的东西输出到数码管

output reg[7:0]seg;
output reg number, number1;
reg clk;
wire rom_, ram_;

reg [7:0] out;

reg [27:0]cnt;
always@(posedge clksource or negedge rst)begin
	number2 = 1;
	number3 = 1;
	led = 4'b1111;
	if(!rst)begin 
		clk <= 0;
		cnt <= 1;
	end
	else if(cnt >= 500000) begin
	//else if(cnt >= 5) begin
		clk <= 1;
		cnt <= 1;
	end
	else begin
		cnt <= cnt + 1;
		clk <= 0;
	end
end

reg [18:0]cnt2;
reg clk2;
always@(posedge clksource or negedge rst)begin
	if(!rst)begin 
		cnt2 <= 1;
		clk2 <= 0;
	end
	else if(cnt2 >= 50_00) begin
	//else if(cnt2 >= 1) begin
		clk2 <= ~clk2;
		cnt2 <= 0;
	end
	else begin
		cnt2 <= cnt2 + 1;
	end
end

reg [7:0]cnt3;
always@(posedge clk or negedge rst)begin
	if(!rst)begin
		cnt3 <= 0;
		out <= 0;
	end
	else if(cnt3 == 8)begin
		out <= accum;
		cnt3 <= cnt3 + 1;
	end
	else if(cnt3 == 95)begin
		cnt3 <= 0;
		out <= out;
	end
	else cnt3 <= cnt3 + 1;
end

always@(posedge clk2 or negedge rst) begin
	if(!rst)begin
		number = 0;
		number1 = 1;
	end
	else begin
	if(number)begin
	case(out[3:0])
		4'h0:seg=8'b11000000;
		4'h1:seg=8'b11111001;
		4'h2:seg=8'b10100100;
		4'h3:seg=8'b10110000;
		4'h4:seg=8'b10011001;
		4'h5:seg=8'b10010010;
		4'h6:seg=8'b10000010;
		4'h7:seg=8'b11111000;
		4'h8:seg=8'b10000000;
		4'h9:seg=8'b10010000;
		4'ha:seg=8'b10001000;
		4'hb:seg=8'b10000011;
		4'hc:seg=8'b11000110;
		4'hd:seg=8'b10100001;
		4'he:seg=8'b10000110;
		default:
		seg=8'b10001110;
	endcase
		number <= ~number;
		number1 <= ~number1;
	end
	else begin
	case(out[7:4])
		4'h0:seg=8'b11000000;
		4'h1:seg=8'b11111001;
		4'h2:seg=8'b10100100;
		4'h3:seg=8'b10110000;
		4'h4:seg=8'b10011001;
		4'h5:seg=8'b10010010;
		4'h6:seg=8'b10000010;
		4'h7:seg=8'b11111000;
		4'h8:seg=8'b10000000;
		4'h9:seg=8'b10010000;
		4'ha:seg=8'b10001000;
		4'hb:seg=8'b10000011;
		4'hc:seg=8'b11000110;
		4'hd:seg=8'b10100001;
		4'he:seg=8'b10000110;
		default:
		seg=8'b10001110;
	endcase
		number <= ~number;
		number1 <= ~number1;
	end
	end
end


RAM RAM_(.data(data),
         .addr(addr),
         .ena(ram_),
         .rd(rd),
         .wr(wr)); 

ROM ROM_(.data(data),
         .addr(addr),
         .ena(rom_),
         .rd(rd));


clk_generator clk_generator_(
	.clk(clk),
	.rst(rst),
	.clk1(clk1),
	.fetch(fetch),
	.con_alu(con_alu)
);

IR IR_(
	.clk(clk),
	.rst(rst),
	.ena(load_ir),
	.data(data),
	.instr({opcode, ir_addr})
);

accumulator accumlator_(
	.clk(clk),
	.rst(rst),
   .ena(load_acc),
   .data(alu_out),
   .accum(accum)
);

ALU ALU_(
	.clk(clk),
	.rst(rst),
	.data(data),
	.accum(accum),
	.opcode(opcode),
	.zero(zero),
	.alu_out(alu_out),
	.con_alu(con_alu)
);

data_ctrl data_ctrl_(
	.in(alu_out),
	.data_ena(datactr_ena),
	.data(data)
);

counter counter_(
	.clk(clk),
	.rst(rst),
	.load(load_pc),
	.ir_addr(ir_addr),
	.pc_addr(pc_addr),
	.inc_pc(inc_pc)
);

addr addr_(
	.addr(addr),
	.fetch(fetch),
	.pc_addr(pc_addr),
	.ir_addr(ir_addr)
);

addr_ctrl addr_ctrl_(
	.addr(addr),
	.rom_(rom_),
	.ram_(ram_)
);


controller controller_(
	.clk(clk),
	.rst(rst),
	.zero(zero),
	.opcode(opcode),
	.load_acc(load_acc),
	.load_pc(load_pc),
	.rd(rd),
	.wr(wr),
	.load_ir(load_ir),
	.HALT(HALT),
	.datactr_ena(datactr_ena),
	.inc_pc(inc_pc)
);



endmodule