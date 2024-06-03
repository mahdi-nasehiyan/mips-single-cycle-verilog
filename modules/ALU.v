module ALU (inA, inB, alu_out, zero, control);
	input [31:0] inA, inB;
	output [31:0] alu_out;
	output zero;
	reg zero;
	reg [31:0] alu_out;
	input [3:0] control;
	always @ (control or inA or inB)
	begin
		case (control)
		4'b0000:begin zero<=0; alu_out<=inA&inB; end // AND
		4'b0001:begin zero<=0; alu_out<=inA|inB; end // OR
		4'b0010:begin zero<=0; alu_out<=inA+inB; end // ADD
		4'b0110:begin if(inA==inB) zero<=1; else zero<=0; alu_out<=inA-inB; end // SUB
		4'b0111:begin zero<=0; if(inA-inB>=32'h8000_0000) alu_out<=32'b1; else alu_out<=32'b0; end // SLT
		4'b1000:begin if(inA!=inB) zero<=1; else zero<=0; alu_out<=inA-inB; end // NOTEQ
		default: begin zero<=0; alu_out<=inA; end
		endcase
	end
endmodule

module AddOnlyALU (inA, inB, add_out);
	parameter N = 32;
	input [N-1:0] inA, inB;
	output [N-1:0] add_out;
	assign add_out=inA+inB;
endmodule
