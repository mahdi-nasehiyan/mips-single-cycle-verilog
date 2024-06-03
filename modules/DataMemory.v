/*
128*32 Data memory
Word adressed!
addr is 7 bits, covering 128 words.
*/
module DataMemory (addr, write_data, read_data, clk, reset, MemRead, MemWrite, display);
	input [6:0] addr;
	input [31:0] write_data;
	input display;
	output [31:0] read_data;
	input clk, reset, MemRead, MemWrite;
	reg [31:0] DMemory [127:0];
	reg signed [15:0] signed_value;
	integer k;
	assign read_data = (MemRead) ? DMemory[addr] : 32'bx;

	always @(posedge clk or posedge reset or posedge display)
	begin
		if (display == 1'b1)
			begin
				// display...
				$display("*___Data Memory Dump___*");
				$display("Address\tValue(Binary)\t\t\t\tValue(Decimal)");
				for (k=0; k<128; k=k+1) begin
					signed_value = DMemory[k];
					$display("%0d\t%b\t%0d", k, DMemory[k], signed_value);
				end
			end
		if (reset == 1'b1)
			begin
				for (k=0; k<128; k=k+1) begin
					DMemory[k] = 32'b0;
				end
				DMemory[0] = 5;
				DMemory[1] = 1;
				DMemory[2] = 3;
				DMemory[3] = 2;
				DMemory[4] = 8;
				DMemory[5] = 12;
				DMemory[6] = 4;
				DMemory[7] = 19;
				DMemory[8] = 6;
				DMemory[9] = 3;

			end
		else
			if (MemWrite) DMemory[addr] = write_data;
	end
endmodule
