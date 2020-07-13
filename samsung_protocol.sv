`timescale 1ns/1ns

module samsung_protocol (	input logic clk,
									input logic reset,
									input logic [31:0] command_in,
									output logic ir_mod);
									
	typedef enum logic[3:0] {BEGIN, 
									LEADUP, 
									LEADDOWN,
									DATAUP,
									BITLOW,
									NEXTBIT,
									END} protocol_state_t;
	
	parameter leadup 		= 225000;
	parameter leaddown 	= 225000;
	parameter dataup		= 28000;
	parameter data0		= 28000;
	parameter data1		= 84500;
	parameter stop			= 28000;
	
	
	
	protocol_state_t state;
	logic [31:0] cmd;
	logic [31:0] counter;
	logic [31:0] stop_val;
	logic [5:0] num_shifts;
	
	always_ff@(posedge clk)
	begin
		//reset
		if (reset)
			begin
			state <= BEGIN;
			cmd <= 0;
			counter <= 0;
			stop_val <= 0;
			num_shifts <= 0;
			ir_mod <= 0;
		end
		
		case (state)
			//wait for command								begin
			BEGIN: begin
				if (command_in != 0)
					begin
						cmd <= command_in;
						counter <= 0;
						stop_val <= leadup;
						ir_mod <= 1;
						state <= LEADUP;
				end
			end
					
			//leadup												leadup
			LEADUP: begin
				if (counter == stop_val)
					begin
					counter <= 0;
					stop_val <= leaddown;
					ir_mod <= 0;
					state <= LEADDOWN;
				end
				else
					begin
					counter <= counter + 1;
				end
			end
			
			//leader down										leaddown
			LEADDOWN: begin
				if (counter == stop_val)
					begin
					counter <= 0;
					stop_val <= dataup;
					ir_mod <= 1;
					state <= DATAUP;
				end
				else
					begin
					counter <= counter + 1;
				end
			end
			
			//dataup													dataup
			DATAUP: begin
				if (counter == stop_val)
					begin
					//set stop based on cmd value
					if (cmd[31] == 1)
						begin
						stop_val <= data1;
					end
					else
						begin
						stop_val <= data0;
					end
					
					//reset temp
					counter <= 0;
					ir_mod <= 0;
					state <= BITLOW;

				end
				else
					begin
					counter <= counter + 1;
				end
			end
			
			//bitlow: shift right when donw					bitlow
			BITLOW: begin
				if (counter == stop_val)
					begin
					cmd <= cmd << 1;
					num_shifts <= num_shifts + 1;
					state <= NEXTBIT;
				end
				else
					begin
					counter <= counter + 1;
				end
			end
			
			
			//nextbit: either end or continue				nextbit
			NEXTBIT: begin
				if (num_shifts == 32)
					begin
					stop_val <= stop;
					state <= END;
					num_shifts <= 0;
				end
				else
					begin
					stop_val <= dataup;
					state <= DATAUP;
				end
				counter <= 0;
				ir_mod <= 1;
			end
			
			//end: once done, goes back to begin state	end
			END: begin
				if (counter == stop_val)
					begin
					state <= BEGIN;
					counter <= 0;
					ir_mod <= 0;
				end
				else
					begin
					counter <= counter + 1;
				end
			end			
		endcase
	end		//end always_ff
									
endmodule
									
module prot_test();

	logic clk, reset, ir_mod;
	logic [31:0] command_in;
	

	//dut
	samsung_protocol dut(.*);
	
	//clock
	always
	begin
		clk <= 1;	#10;
		clk <= 0;	#10;
	end
	
	
	initial
	begin
		reset <= 1;	#10;
		reset <= 0;	#10;
		command_in <= 32'hf0f0f0f0;	#100
		command_in <= 0;
	end

endmodule
						