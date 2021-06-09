`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_registerfile.v
//
//  Author: Mike Wirthlin
//  
//  Description: 
//
//  Version 1.0
//
//  Change Log:
//   
//////////////////////////////////////////////////////////////////////////////////

module tb_registerfile();

	reg [9:0] sw;
	wire [7:0] segment;
	wire [7:0] anode;
	reg btnc, btnl, btnr, btnu, btnd;
	reg clk;
	
    integer i,j,errors;
    //integer c_errors;
	reg [4:0] t_data;
	reg [3:0] e_data;
    	
	/* returns the expected segment data based on the input */
	function [4:0] segment_to_data;
	   input [6:0] segment;
	   reg [4:0] val;
	begin
	   case(segment)
		7'b1000000 : val = 5'd0;
		7'b1111001 : val = 5'd1;
		7'b0100100 : val = 5'd2;
		7'b0110000 : val = 5'd3;
		7'b0011001 : val = 5'd4;
		7'b0010010 : val = 5'd5;
		7'b0000010 : val = 5'd6;
		7'b1111000 : val = 5'd7;
		7'b0000000 : val = 5'd8;
		7'b0010000 : val = 5'd9;
		7'b0001000 : val = 5'd10;
		7'b0000011 : val = 5'd11;
		7'b1000110 : val = 5'd12;
		7'b0100001 : val = 5'd13;
		7'b0000110 : val = 5'd14;
		7'b0001110 : val = 5'd15;
		default : val = 5'b10000; // bad segment data
	   endcase;
	   segment_to_data = val;
	end
	endfunction

	// Instance the RegisterFile module
	register_top dut(.clk(clk), .sw(sw), .btnc(btnc), .btnr(btnr), 
					.btnu(btnu), .btnd(btnd), .btnl(btnl), .segment(segment), 
					.anode(anode));

	// Need to create a clock
	initial begin
		#100 // wait 100 ns before starting clock (after inputs have settled)
		clk = 0;
		forever begin
			#5  clk = ~clk;
		end
	end	
	
	initial begin

		#50 // wait 50 ns before setting any of the inputs (before clock starts)
		errors = 0;
		j=0;
		i=0;
		t_data=0;
		btnc = 1'b0;
		btnl = 1'b0;
		btnr = 1'b0;
		btnu = 1'b0;
		btnd = 1'b0;
		sw = 0;

		// Start reading data from the memories (ignore the output)
		repeat (10) @ (negedge clk); 
		$display("*** Starting simulation with no buttons pressed at time %t ***", $time);
		btnc = 1'b0;
		// read the values in all four registers (don't check at this point)
		for(i=0; i < 8; i=i+1) begin
			// change inputs at falling edge of clock
			sw[6:4] = i;
			@ (negedge clk);
			// No checking
		end
		// change inputs on falling edge of clock
		sw[6:4] = 0;
		@ (negedge clk);
		
		repeat (10) @ (negedge clk); 
		$display("*** Writing values into each register at time %t ***", $time);
		// read the values in all four registers (don't check at this point)
		for(i=0; i < 8; i=i+1) begin
			sw[2:0] = i;		// write 1xxx into each register
			sw[3] = 1'b1;		
			sw[6:4] = i;
			btnc = 1'b1;
			@ (posedge clk);
			#2
			// Check to see that the data is correct (it should be displayed on the segments)
			t_data = segment_to_data(segment[6:0]);
			if (t_data == 5'b10000) begin
				errors = errors + 1;
				$display("Error: Invalid segment data %6b at time %t", segment, $time); 
			end
			else if (t_data != i+8) begin
				errors = errors + 1;
				$display("Error: expecting to read %4b from address %3b but received %4b at time %t", i+8,i,t_data, $time); 
			end
			@ (negedge clk);
			btnc = 1'b0;
			@ (negedge clk);
		end
		@ (negedge clk);
		sw = 0;

		
		repeat (10) @ (negedge clk); 		
		$display("*** Reading values from each register using raddr2 (btnr) at time %t ***", $time);
		btnr = 1'b1;
		for(i=0; i < 8; i=i+1) begin
			sw[2:0] = i;
			sw[3] = 0'b1;		
			sw[6:4] = i+1;
			sw[9:7] = i;
			@ (posedge clk);
			#2
			t_data = segment_to_data(segment[6:0]);
			if (t_data == 5'b10000) begin
				errors = errors + 1;
				$display("Error: Invalid segment data %6b at time %t", segment, $time); 
			end
			else if (t_data != i+8) begin
				errors = errors + 1;
				$display("Error: expecting to read %4b from address %3b but received %4b at time %t", i+8,i,t_data, $time); 
			end
			@ (negedge clk);
			btnc = 1'b0;
			@ (negedge clk);
		end
		@ (negedge clk);
		btnr = 1'b0;
		sw = 0;

		repeat (10) @ (negedge clk); 		
		$display("*** Checking addition using btnu at time %t ***", $time);
		btnu = 1'b1;
		for(i=0; i < 8; i=i+1) begin
			for(j=0; j < 8; j=j+1) begin
				sw[6:4] = i;
				sw[9:7] = j;
				@ (posedge clk);
				#2
				t_data = segment_to_data(segment[6:0]);
				e_data = i+j;
				if (t_data == 5'b10000) begin
					errors = errors + 1;
					$display("Error: Invalid segment data %6b at time %t", segment, $time); 
				end
				else if (t_data[3:0] != e_data) begin
					errors = errors + 1;
					$display("Error: expecting to read %4b from address %3b but received %4b at time %t", e_data,i,t_data[3:0], $time); 
				end
				@ (negedge clk);
			end
		end
		@ (negedge clk);
		btnu = 1'b0;
		sw = 0;

		repeat (10) @ (negedge clk); 		
		$display("*** Checking subtraction using btnd at time %t ***", $time);
		btnd = 1'b1;
		for(i=0; i < 8; i=i+1) begin
			for(j=0; j < 8; j=j+1) begin
				sw[6:4] = i;
				sw[9:7] = j;
				@ (posedge clk);
				#2
				t_data = segment_to_data(segment[6:0]);
				e_data = (8+i)-(8+j);
				if (t_data == 5'b10000) begin
					errors = errors + 1;
					$display("Error: Invalid segment data %6b at time %t", segment, $time); 
				end
				else if (t_data[3:0] != e_data) begin
					errors = errors + 1;
					$display("Error: expecting to read %4b from address %3b but received %4b at time %t", e_data,i,t_data[3:0], $time); 
				end
				@ (negedge clk);
			end
		end
		@ (negedge clk);
		// falling edge of clock
		btnd = 1'b0;
		sw = 0;

		repeat (10) @ (negedge clk); 		
		$display("*** Checking AND using btnl at time %t ***", $time);
		btnl = 1'b1;
		for(i=0; i < 8; i=i+1) begin
			for(j=0; j < 8; j=j+1) begin
				sw[6:4] = i;
				sw[9:7] = j;
				@ (posedge clk);
				#2
				t_data = segment_to_data(segment[6:0]);
				e_data = (8+i) & (8+j);
				if (t_data == 5'b10000) begin
					errors = errors + 1;
					$display("Error: Invalid segment data %6b at time %t", segment, $time); 
				end
				else if (t_data[3:0] != e_data) begin
					errors = errors + 1;
					$display("Error: expecting to read %4b from address %3b but received %4b at time %t", e_data,i,t_data[3:0], $time); 
				end
				@ (negedge clk);
			end
		end
		wait(!clk);
		// falling edge of clock
		btnl = 1'b0;
		sw = 0;
		@ (negedge clk);

		
		repeat (10) @ (negedge clk); 		
		$display("*** Simulation done with %3d errors at time %t ***", errors, $time);
		$finish;

	end  // end initial begin

	
endmodule