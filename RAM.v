module RAM(
	data,
	addr,
	ena,
	rd,
	wr
);

inout [7:0] data;
input [12:0] addr;
input ena;
input rd, wr;
//13 * 8
reg [7:0] mem[10'h3ff:10'h200];

assign data = (rd && ena)? mem[addr]:8'hzz;

always@(posedge wr)begin
	mem[addr] <= data;
end

endmodule