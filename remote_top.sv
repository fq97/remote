`timescale 1ns/1ns

module remote_top (	input logic CLOCK_50,
							input logic reset,
							input logic [3:0] KEY,
							output logic IR_LED);
							
	
	
	logic clk_38, ir_mod;
	logic [31:0] command;
	
	//modules
	clk_38k divider (	.clk_50(CLOCK_50), 
							.reset(reset), 
							.clk_38(clk_38));
	
	samsung_command key_to_cmd (	.clk(CLOCK_50), 
											.reset(reset), 
											.KEY(KEY), 
											.command(command));
	
	samsung_protocol prot (	.clk(CLOCK_50), 
									.reset(reset), 
									.command_in(command), 
									.ir_mod(ir_mod));
	
	ir_drive ir_drv (	.clk(clk_38), 
							.mod(ir_mod), 
							.ir_val(IR_LED));
endmodule


module remote_test ();
	logic CLOCK_50, IR_LED, reset;
	logic [3:0] KEY;
	
	//connect
	remote_top dut(.*);
	
	//clock
	always
	begin
		CLOCK_50 <= 1;	#10;
		CLOCK_50 <= 0;	#10;
	end


	initial
	begin
		//reset??
		KEY <= 4'hf;
		reset <= 1;	#10;
		reset <= 0;	#10;
		
		//key press
		KEY[3] <= 0;	#10;
		KEY[3] <= 1;
	end
	

endmodule
