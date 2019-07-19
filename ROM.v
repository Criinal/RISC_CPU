 module ROM (
	addr,
	rd,
	ena,
	data
);
            
input[12:0] addr;
input rd,ena;
output[7:0] data;
wire[7:0] data;
reg[7:0] memory [10'h1ff:10'h000]; 

assign data=(ena&&rd)?memory[addr]:8'bzzzzzzzz;
/*
initial begin
//0:skz
	memory[0] = 8'h00;	
	memory[1] = 8'h20;
//2:add mem[100]
//add 3
	memory[2] = 8'h64;
	memory[3] = 8'ha0;
//4:add mem[101]
//add 14
	memory[4] = 8'h65;
	memory[5] = 8'ha0;
//6:add mem[102]
//add 39
//accum: 14+39=4d
	memory[6] = 8'h66;
	memory[7] = 8'h40;
//8:sto ram[200(16)]
	memory[8] = 8'h00;
	memory[9] = 8'hc2;
//10:jmp 14
//jmp to 14
	memory[10] = 8'h0e;
	memory[11] = 8'he0;
//12:and mem[100]
//and 3
	memory[12] = 8'h64;
	memory[13] = 8'h60;
//14:and mem[103]
//xor 28
//accum = 28 ^ 4d = 65
	memory[14] = 8'h67;
	memory[15] = 8'h80;
//:16:and mem[101]
//and 14
//accum = 65 & 14 = 04
	memory[16] = 8'h65;
	memory[17] = 8'h60;

	
	memory[100] = 8'h03;
	memory[101] = 8'h14;
	memory[102] = 8'h39;
	memory[103] = 8'h28;
end
*/
/*
HLT = 3'b000,
	SKZ = 3'b001, 2
	ADD = 3'b010, 4
	AND = 3'b011, 6
	XOR = 3'b100, 8
	LDA = 3'b101, a
	STO = 3'b110, c
	JMP = 3'b111  e
*/

initial begin

//0:lda rom[259];
memory[0] = 8'h03;
memory[1] = 8'ha1;
//2:sto ram[512]
memory[2] = 8'h00;
memory[3] = 8'hc2;

//4:lda rom[257]
memory[4] = 8'h01;
memory[5] = 8'ha1;
//6:sto ram[513] x
memory[6] = 8'h01;
memory[7] = 8'hc2;

//8:lda rom[258]
memory[8] = 8'h02;
memory[9] = 8'ha1;
//10:sto ram[514] y
memory[10] = 8'h02;
memory[11] = 8'hc2;

//function
//12:lda x
memory[12] = 8'h01;
memory[13] = 8'ha2;

//14:add y
memory[14] = 8'h02;
memory[15] = 8'h42;

//16:sto z
memory[16] = 8'h03;
memory[17] = 8'hc2;

//18:lda y
memory[18] = 8'h02;
memory[19] = 8'ha2;

//20:sto x
memory[20] = 8'h01;
memory[21] = 8'hc2;

//22:lda z
memory[22] = 8'h03;
memory[23] = 8'ha2;

//24:sto y
memory[24] = 8'h02;
memory[25] = 8'hc2;

//26:lda cnt
memory[26] = 8'h00;
memory[27] = 8'ha2;

//28:add -1
memory[28] = 8'h00;
memory[29] = 8'h41;

//30:sto cnt
memory[30] = 8'h00;
memory[31] = 8'hc2;

//32:SKZ
memory[32] = 8'hFF;
memory[33] = 8'h22;

//34:jmp 12 
memory[34] = 8'h0c;
memory[35] = 8'he0;

//36：
memory[36] = 8'h00;
memory[37] = 8'ha1;


//-1 100
memory[256] = 8'hFF;
//0 101
memory[257] = 8'h00;
//1 102
memory[258] = 8'h01;
//12 103
memory[259] = 8'h0c;

end
endmodule  