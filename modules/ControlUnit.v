/*
ControlUnit
*/
module ControlUnit (OpCode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input [5:0] OpCode;
	output RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	output [2:0] ALUOp; // expanded to 3 bits for support of more instructions with the same architecture ("slti, andi, bne, etc...")

	// RegDst is high only on R-type instructions OpCode(s) : {000000, }
	assign RegDst = (~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(~OpCode[1])&(~OpCode[0]);

	// Jump is high only on Jump instruction OpCode(s) : {000010, }
	assign Jump = (~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(OpCode[1])&(~OpCode[0]);

	// Branch is high on beq and bne instructions OpCode(s) : {000100, 000101, }
	assign Branch = ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]));

	// MemRead is high only on lw instruction OpCode(s) : {100011, }
	assign MemRead = (OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(OpCode[1])&(OpCode[0]);

	// MemtoReg is high only on lw instruction OpCode(s) : {100011, }
	assign MemtoReg = (OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(OpCode[1])&(OpCode[0]);

	// MemWrite is high only on sw instruction OpCode(s) : {101011, }
	assign MemWrite = (OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(OpCode[1])&(OpCode[0]);

	// ALUSrc is high on lw, sw, addi, andi, slti, ori instructions OpCode(s) : {100011, 101011, 001000, 001100, 001010, 001101}
	assign ALUSrc = ((OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(OpCode[1])&(OpCode[0]))
	| ((OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(OpCode[1])&(OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]));

	// RegWrite is high on R-type, lw, addi, andi, slti, ori OpCode(s) : {000000, 100011, 001000, 001100, 001010, 001101}
	assign RegWrite = ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(OpCode[1])&(OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]));

	// ALUOp[2] is high on slti, ori, bne instructions OpCode(s) : {001010, 001101, 000101}
	assign ALUOp[2] = ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(~OpCode[2])&(OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]));

	// ALUOp[1] is high on R-type, andi, bne instructions OpCode(s) : {000000, 001100, 000101}
	assign ALUOp[1] = ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(~OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]));

	// ALUOp[0] is high on beq, andi, ori instructions OpCode(s) : {000100, 001100, 001101}
	assign ALUOp[0] = ((~OpCode[5])&(~OpCode[4])&(~OpCode[3])&(OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(~OpCode[0]))
	| ((~OpCode[5])&(~OpCode[4])&(OpCode[3])&(OpCode[2])&(~OpCode[1])&(OpCode[0]));
endmodule
