//fetch: 指令周期
//ir_addr instr的后13位
//pc_addr 程序计数器
//addr 地址
//选择输出的是pc（rom） 还是ir（ram）
//前四个周期读取指令，选择pc 后四个周期用于处理指令，选择ir

module addr(
	addr,
	fetch,
	pc_addr,
	ir_addr
);

input [12:0] pc_addr, ir_addr;
input fetch;
output [12:0]addr;

assign addr=fetch?pc_addr:ir_addr;

endmodule