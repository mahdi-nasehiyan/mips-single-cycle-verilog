/*
128*32 Instruction Memory
Byte addressed
*/
module InstructionMemory (read_addr, instruction, reset);
	input reset;
	input [8:0] read_addr; // 128*4 bytes decimal range
	output [31:0] instruction;
	reg [31:0] Imemory [127:0];
	integer k;

	// shift right by 2 - byte addressing to word addressing converstion
	wire [6:0] shifted_read_addr;
	assign shifted_read_addr = read_addr[8:2];
	assign instruction = Imemory[shifted_read_addr];

	always @(posedge reset)
	begin
		/*
		assuming we have an array with size 10 in the memory with base address 0
		addi $t0, $zero, a_big_number; $t0 will hold the minimum
		addi $t1, $zero, 0; $t1 will hold the maximum
		addi $t2, $zero, 0; $t2 will act as the array pointer
		lw $t3, 0($t2); load an item from array
		slt $t4, $t3, $t0; if item is less than minimum
		beq $t4, $zero, +1; if not, bypass next instruction
		add $t0, $zero, $t3; move item to $t0 as the new minimum
		slt $t4, $t1, $t3; if maximum is less than item
		beq $t4, $zero, +1; if not, bypass next instruction
		add $t1, $zero, $t3; move item to $t1 as the new maximum

		addi $t2, $t2, 1; $t2++
		slti $t4, $t2, 10;
		bne $t4, $zero, -10;
		sw $t0, 0($t2); store minimum
		sw $t1, 1($t2); store maximum
		*/
		Imemory[0] = {6'b001000, 5'b00000, 5'b01000, 16'b0111111111111111}; // addi $t0, $zero, a_big_number
		Imemory[1] = {6'b001000, 5'b00000, 5'b01001, 16'b0000000000000000}; // addi $t1, $zero, 0
		Imemory[2] = {6'b001000, 5'b00000, 5'b01010, 16'b0000000000000000}; // addi $t2, $zero, 0
		Imemory[3] = {6'b100011, 5'b01010, 5'b01011, 16'b0000000000000000}; // lw $t3, 0($t2)
		Imemory[4] = {6'b000000, 5'b01011, 5'b01000, 5'b01100, 5'b00000, 6'b101010}; // slt $t4, $t3, $t0
		Imemory[5] = {6'b000100, 5'b01100, 5'b00000, 16'b0000000000000001}; // beq $t4, $zero, +1
		Imemory[6] = {6'b000000, 5'b00000, 5'b01011, 5'b01000, 5'b00000, 6'b100000}; // add $t0, $zero, $t3
		Imemory[7] = {6'b000000, 5'b01001, 5'b01011, 5'b01100, 5'b00000, 6'b101010}; // slt $t4, $t1, $t3
		Imemory[8] = {6'b000100, 5'b01100, 5'b00000, 16'b0000000000000001}; // beq $t4, $zero, +1
		Imemory[9] = {6'b000000, 5'b00000, 5'b01011, 5'b01001, 5'b00000, 6'b100000}; // add $t1, $zero, $t3
		Imemory[10] = {6'b001000, 5'b01010, 5'b01010, 16'b0000000000000001}; // addi $t2, $t2, 1
		Imemory[11] = {6'b001010, 5'b01010, 5'b01100, 16'b0000000000001010}; // slti $t4, $t2, 10
		Imemory[12] = {6'b000101, 5'b01100, 5'b00000, 16'b1111111111110110}; // bne $t4, $zero, -10
		Imemory[13] = {6'b101011, 5'b01010, 5'b01000, 16'b0000000000000000}; // sw $t0, 0($t2)
		Imemory[14] = {6'b101011, 5'b01010, 5'b01001, 16'b0000000000000001}; // sw $t1, 1($t2)
	end
endmodule
