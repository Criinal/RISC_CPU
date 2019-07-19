module controller(
	clk,
	rst,
	inc_pc,
	load_acc,
	load_pc,
	rd,
	wr,
	load_ir,
	datactr_ena,
	HALT,
	zero,
	opcode
);

input clk,rst,zero;
input [2:0] opcode;
output reg inc_pc,load_acc,load_pc,rd,wr;
output reg load_ir,datactr_ena,HALT;
reg [2:0]state;

parameter 
	HLT = 3'b000,
	SKZ = 3'b001,
	ADD = 3'b010,
	AND = 3'b011,
	XOR = 3'b100,
	LDA = 3'b101,
	STO = 3'b110,
	JMP = 3'b111
;

initial state <= 0;

always @(posedge clk or negedge rst)begin
	if(!rst)begin
		state <= 3'b000;
		{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} <=8'h00;
	end
	else
		controller_cycle;
end

//一指令周期
task controller_cycle; begin
	case (state)
	
//0
//inc_pc,rd,load_ir置于高位，其余置于低位。
//程序计数器加一，将rom中的数据读出到总线上，
//指令寄存器将寄存来自总线上的高8位指令。
	3'b000:begin
		{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
			<=8'b10010100; 
		state <= 3'b001;
	end
	
//1
//同0，读入八位的指令
//inc_pc,rd,load_ir置于高位，其余置于低位。
//程序计数器加一，将rom中的数据读出到总线上，
//指令寄存器将寄存来自总线上的低8位指令。
	3'b001:begin
		{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
			<=8'b1001_0100;
		state <= 3'b010;
	end
	
//2
//空操作，用于缓冲
	3'b010:begin
		{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
			<=8'b0000_0000;
		state <= 3'b011;
	end
	
//3 HALT则halt位置1，
	3'b011:begin
		if(opcode == HLT)
			{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0000_0010;
		else
			{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0000_0000;
		state <= 3'b100;
	end

//4
//operator rd=1
//JMP load_pc=1
//STO datactr_ena=1
	3'b100:begin
	
		case (opcode)
			AND:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0001_0000;
			ADD:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0001_0000;
			XOR:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0001_0000;
			LDA:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0001_0000;
			JMP:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0010_0000;
			STO:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0000_0001;
		default: {inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0000_0000;
		endcase
		
		state <= 3'b101;
	end

//5	
//operator: rd=1 load_acc=1
//skz: if zero inc_pc=1
//jmp: load_pc=1
//sto: wr=1, datactr_ena=1
	3'b101:begin
		case (opcode)
			AND:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0101_0000;
			ADD:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0101_0000;
			XOR:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0101_0000;
			LDA:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
				<=8'b0101_0000;
			SKZ:if(zero)
					{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b1000_0000;
				else 
					{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0000_0000;
			JMP:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
					<=8'b0010_0000;
			STO:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena}
					<=8'b0000_1001;
			default: {inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0000_0000;
		endcase
		state <= 3'b110;
	end
	
//6
//控制总线上的输出数据
//sto wr=1,datactr_ena=1
//operator rd=1
	3'b110:begin
		case(opcode)
			STO:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0000_1001;
			ADD:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0101_0000;
			AND:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0101_0000;
			XOR:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0101_0000;
			LDA:{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0101_0000;
			default: {inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
						<=8'b0000_0000;
		endcase
		state <= 3'b111;
	end
	
//7	
//skz && zero inc_pc=1
	3'b111:begin
		if(opcode == SKZ && zero)
			{inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
					<=8'b1000_0000;
		else {inc_pc,load_acc,load_pc,rd, wr,load_ir,HALT,datactr_ena} 
					<=8'b0000_0000;
		state <= 3'b000;
	end
	endcase
end
endtask


endmodule