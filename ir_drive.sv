`timescale 1ns/1ns

module ir_drive (	input logic clk,
						input logic mod,
						output logic ir_val);

	always_comb
		begin
		ir_val = clk & mod;
	end
endmodule


module ir_test();
	logic clk, mod, ir_val;
	ir_drive dut(.*);
	
	always
	begin
		clk = 1;	#10;
		clk = 0;	#10;
	end
	
	
	initial
	begin
		mod = 1;	#100;
		mod = 0;	#100;
	end
endmodule
