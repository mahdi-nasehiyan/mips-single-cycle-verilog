module Core;
	reg clk;
	reg reset;
	reg clkread;
	reg data_memory_display=0;
	integer count;
	wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, alu_zero;
	wire [2:0] ALUOp;
	wire [31:0] pc_plus_four;
	wire [31:0] pc_in, pc_out;
	wire [31:0] instruction;
	wire [31:0] reg_read_data_1, reg_read_data_2, reg_write_data;
	wire [4:0] reg_write_addr;
	wire [31:0] sign_extended;
	wire [31:0] alu_in_b, alu_out;
	wire [31:0] mem_read_data;
	wire [3:0] alu_op_final;
	wire [31:0] jump_address;
	wire [31:0] branch_shifted, branch_address, branch_mux_out;
	PC pc (
		.clk(clk),
		.reset(reset),
		.PC_in(pc_in),
		.PC_out(pc_out)
		);
	AddOnlyALU #(32) pc_adder (
		.inA(pc_out),
		.inB(32'b0100),
		.add_out(pc_plus_four)
		);
	InstructionMemory inst_memory (
		.read_addr(pc_out[8:0]),
		.instruction(instruction),
		.reset(reset)
		);
	ControlUnit control (
		.OpCode(instruction[31:26]),
		.RegDst(RegDst),
		.Jump(Jump),
		.Branch(Branch),
		.MemRead(MemRead),
		.MemtoReg(MemtoReg),
		.ALUOp(ALUOp),
		.MemWrite(MemWrite),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite)
		);
	// 5 bit mux for reg write address
	NBitMux #(5) RegDst_mux (
		.in0(instruction[20:16]),
		.in1(instruction[15:11]),
		.mux_out(reg_write_addr),
		.control(RegDst)
		);
	RegisterFile reg_file (
		.read_addr_1(instruction[25:21]),
		.read_addr_2(instruction[20:16]),
		.read_data_1(reg_read_data_1),
		.read_data_2(reg_read_data_2),
		.write_addr(reg_write_addr),
		.write_data(reg_write_data),
		.RegWrite(RegWrite),
		.clk(clk),
		.reset(reset),
		.display(data_memory_display)
		);
	SignExtender sign_ext (
		.sign_in(instruction[15:0]),
		.sign_out(sign_extended)
		);
	// 32 bit mux for alu input b
	NBitMux #(32) ALUSrc_mux (
		.in0(reg_read_data_2),
		.in1(sign_extended),
		.mux_out(alu_in_b),
		.control(ALUSrc)
		);
	ALUControl alu_control (
		.ALUOp(ALUOp),
		.funct(instruction[5:0]),
		.out_to_ALU(alu_op_final)
		);
	ALU alu (
		.inA(reg_read_data_1),
		.inB(alu_in_b),
		.alu_out(alu_out),
		.zero(alu_zero),
		.control(alu_op_final)
		);
	// 32 bit mux for mem to reg
	NBitMux #(32) MemtoReg_mux(
		.in0(alu_out),
		.in1(mem_read_data),
		.mux_out(reg_write_data),
		.control(MemtoReg)
		);
	DataMemory data_memory (
		.addr(alu_out[6:0]),
		.write_data(reg_read_data_2),
		.read_data(mem_read_data),
		.clk(clk),
		.reset(reset),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.display(data_memory_display)
		);
	Jump2Shift jump2shift (
		.shift_in(instruction[25:0]),
		.shift_out(jump_address[27:0])
		);
	assign jump_address[31:28] = pc_plus_four[31:28];
	Branch2Shift branch2shift (
		.shift_in(sign_extended),
		.shift_out(branch_shifted)
		);
	AddOnlyALU #(32) branch_adder (
		.inA(pc_plus_four),
		.inB(branch_shifted),
		.add_out(branch_address)
		);
	NBitMux #(32) branch_pc_mux (
		.in0(pc_plus_four),
		.in1(branch_address),
		.control((Branch)&(alu_zero)),
		.mux_out(branch_mux_out)
		);
	NBitMux #(32) jump_mux (
		.in0(branch_mux_out),
		.in1(jump_address),
		.control(Jump),
		.mux_out(pc_in)
		);
	initial begin
		// Initialize Inputs
		count = 0;
		clk = 0;
		reset = 1;
		clkread = 0;
		data_memory_display = 0;
		#1
		reset=0;
		#200
		data_memory_display = 1;
		#1
		$finish;
	end

	always begin #1 clk=~clk; end
	always begin #1 clkread = ~clkread; end

	always @(posedge clkread)
	begin
		$display ("Time: %0d", count);
		$display ("PC: %0d", pc_out);
		$display ("Instruction: %b", instruction);
		count = count + 1;
	end
endmodule
