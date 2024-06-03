module PC (clk, reset, PC_in, PC_out);
	input clk, reset;
	input [31:0] PC_in;
	output [31:0] PC_out;
	reg [31:0] PC_out;
	always @ (posedge clk or posedge reset)
	begin
		if(reset==1'b1)
			PC_out<=0;
		else
			PC_out<=PC_in;
	end
endmodule
