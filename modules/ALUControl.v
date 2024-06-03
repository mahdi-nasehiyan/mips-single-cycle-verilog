/*
ALUControl
Accept 3 bits as ALUOp; The suggested design used 2 bits; i changed it.
*/
module ALUControl (ALUOp, funct, out_to_ALU);
	input [2:0] ALUOp;
	input [5:0] funct;
	output [3:0] out_to_ALU;

	// high when ALUOp 110
	assign out_to_ALU[3] = ((ALUOp[2])&(ALUOp[1])&(~ALUOp[0]));
	// high when (ALUOp is 100 or 001) or (ALUOp is 010 and (funct is 100010 or 101010))
	assign out_to_ALU[2] = ((ALUOp[2])&(~ALUOp[1])&(~ALUOp[0]))
	| ((~ALUOp[2])&(~ALUOp[1])&(ALUOp[0]))
	| ( ((~ALUOp[2])&(ALUOp[1])&(~ALUOp[0])) & ( ((funct[5])&(~funct[4])&(~funct[3])&(~funct[2])&(funct[1])&(~funct[0])) | ((funct[5])&(~funct[4])&(funct[3])&(~funct[2])&(funct[1])&(~funct[0])) ) );
	// high when (ALUOp is 100 or 001 or 000) or (ALUOp is 010 and (funct is 100010 or 101010 or 100000))
	assign out_to_ALU[1] = ((ALUOp[2])&(~ALUOp[1])&(~ALUOp[0]))
	| ((~ALUOp[2])&(~ALUOp[1])&(ALUOp[0]))
	| ((~ALUOp[2])&(~ALUOp[1])&(~ALUOp[0]))
	| ( ((~ALUOp[2])&(ALUOp[1])&(~ALUOp[0])) & ( ((funct[5])&(~funct[4])&(~funct[3])&(~funct[2])&(funct[1])&(~funct[0])) | ((funct[5])&(~funct[4])&(funct[3])&(~funct[2])&(funct[1])&(~funct[0])) | ((funct[5])&(~funct[4])&(~funct[3])&(~funct[2])&(~funct[1])&(~funct[0])) ) );
	// high when (ALUOp is 100 or 101) or (ALUOp is 010 and (funct is 101010 or 100101))
	assign out_to_ALU[0] = ((ALUOp[2])&(~ALUOp[1])&(~ALUOp[0]))
	| ((ALUOp[2])&(~ALUOp[1])&(ALUOp[0]))
	| ( ((~ALUOp[2])&(ALUOp[1])&(~ALUOp[0])) & ( ((funct[5])&(~funct[4])&(~funct[3])&(funct[2])&(~funct[1])&(funct[0])) | ((funct[5])&(~funct[4])&(funct[3])&(~funct[2])&(funct[1])&(~funct[0])) ) );
endmodule
