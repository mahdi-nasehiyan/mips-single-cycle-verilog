module RegisterFile (read_addr_1, read_addr_2, write_addr, read_data_1, read_data_2, write_data, RegWrite, clk, reset, display);
	input [4:0] read_addr_1, read_addr_2, write_addr;
	input [31:0] write_data;
	input clk, reset, RegWrite, display;
	output [31:0] read_data_1, read_data_2;
	reg signed [15:0] signed_value;
	reg [31:0] Regfile [31:0];
	integer k;

	assign read_data_1 = Regfile[read_addr_1];
	assign read_data_2 = Regfile[read_addr_2];

	always @(posedge clk or posedge reset)
	begin
		if (display == 1'b1) begin
			// display...
			$display("*___Register File Dump___*");
			$display("Address\tValue(Binary)\t\t\t\tValue(Decimal)");
			for (k=0; k<32; k=k+1) begin
				signed_value = Regfile[k];
				$display("%0d\t%b\t%0d", k, Regfile[k], signed_value);
			end
		end
		if (reset==1'b1)
		begin
			for (k=0; k<32; k=k+1)
			begin
				Regfile[k] = 32'b0;
			end
		end
		// Write
		else if (RegWrite == 1'b1) Regfile[write_addr] = write_data;
	end
endmodule
