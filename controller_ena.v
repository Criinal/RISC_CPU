 module controller_ena(
		clk,
      rst,
      fetch,
      ena_controller
 );

input clk,rst,fetch;
output reg ena_controller;

 always@(posedge clk or negedge rst)
	begin
		//if(!rst)
			ena_controller<=1;
	end  

endmodule