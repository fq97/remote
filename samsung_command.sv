`timescale 1ns/1ns

module samsung_command (	input logic clk,
									input logic reset,
									input logic [3:0] KEY,
									output logic [31:0] command);
									
	//assume is initialized to 0
	logic pressed3;
	logic [22:0] counter3;

	
	//key3 is power
	always_ff @(posedge clk)
	begin
		//reset
		if (reset)
			begin
			pressed3 <= 0;
			counter3 <= 22'd0;
			command <= 32'd0;
		end
		
		//power key command and debouncing
		if (~KEY[3])
			begin
			if (~pressed3)
				begin
				//send command, set pressed to 1
				command <= 32'he0e040bf;								//-------------------------command goes here--------------------------//
				pressed3 <= 1;
			end
			else
				begin
				//already pressed: reset counter (bounce)
				counter3 <= 22'd0;
				command <= 32'd0;
			end
		end

		else
			begin
			if (counter3 == 22'd2_000_000)
				//key up, counter reached: released
				begin
				pressed3 <= 0;
				counter3 <= 22'd0;
			end
			else
				begin
				if (pressed3)
					begin
					//key up, pressed: count
					counter3 <= counter3 + 1;
				end
			end
		end
	end		//end always @ff
endmodule


module command_testbench ();
	//signals
	logic clk, reset;
	logic [3:0] KEY;
	logic [31:0] command = 0;
	
	
	//instance of command module
	samsung_command dut(.*);
	
	
	//clock
	always
	begin
		clk <= 1;	#10;
		clk <= 0;	#10;
	end
	
	
	//initial: key
	initial
	begin
		//initial and reset
		KEY <= 4'hf;
		reset <= 1;		#10;
		reset <= 0;		#10;
		
		
		KEY[3] <= 0;	#10;
		KEY[3] <= 1;	#1000000;
		KEY[3] <= 0;	#10;
		KEY[3] <= 1;	#1000000;
		KEY[3] <= 0;	#10;
		KEY[3] <= 1;	#1000000;
	end
endmodule
