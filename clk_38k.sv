`timescale 1ns/1ns

//actually 37.9khz, 1/3 duty cycle
module clk_38k (	input logic clk_50,
						input logic reset,
						output logic clk_38);
						
	logic [11:0] counter;
	
	
	
	always_ff @(posedge clk_50)
	begin
		//reset
		if (reset == 1'b1)
		begin
			counter <= 0;
			clk_38 <= 1;
		end
		
		//high
		else if (counter == 12'd440)
			begin
			clk_38 <= 0;
			counter <= counter + 1;
		end
		
		//low
		else if (counter == 12'd1319)
			begin
			clk_38 <= 1;
			counter <= 0;
		end
		
		//inc counter
		else
			begin
			counter <= counter + 1;
		end
	end
						
endmodule



module clk_testbench ();
	//clock signals
	logic clk, reset, clk_38;
	
	//instance of clk_38k
	clk_38k dut(.clk_50(clk), .reset(reset), .clk_38(clk_38));
	
	
	//clock
	always
	begin
		clk <= 1;	#10;
		clk <= 0;	#10;
	end
	
	
	//initial: reset
	initial
	begin
		reset <= 1;	#10;
		reset <= 0;	#10;
	end



endmodule
