`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_dataflow.v
//
//  Author: Mike Wirthlin
//  
//  Description: Provides a basic testbench for the dataflow lab. This testbench
//  will simulate pressing a variety combination of buttons and change the switches
//  to see if the circuit behaves as specified.
//
//  Version 1.0
//
//  Change Log:
//   
//////////////////////////////////////////////////////////////////////////////////

module tb_dataflow();

	reg [15:0] sw;
	wire [15:0] led;
	wire [7:0] segment;
	wire [7:0] anode;
	
	reg btnl, btnr, btnc, btnu, btnd;

    integer i,errors;
    integer c_errors;
    
	
	/* returns the expected segment data based on the input */
	function [6:0] expected_segment;
	   input [3:0] data_in;
	   reg [6:0] val;
	begin
	   case(data_in)
		0: val = 7'b1000000;
		1: val = 7'b1111001;
		2: val = 7'b0100100;
		3: val = 7'b0110000;
		4: val = 7'b0011001;
		5: val = 7'b0010010;
		6: val = 7'b0000010;
		7: val = 7'b1111000;
		8: val = 7'b0000000;
		9: val = 7'b0010000;
		10: val = 7'b0001000;
		11: val = 7'b0000011;
		12: val = 7'b1000110;
		13: val = 7'b0100001;
		14: val = 7'b0000110;
		15: val = 7'b0001110;
	   endcase;
	   expected_segment = val;
	end
	endfunction
	
	/* returns the expected led data based on the input */
	function [15:0] expected_led;
	   input [3:0] data_in;
	   reg [15:0] val;
	begin
	   case(data_in)
		0: val = 16'h0001;
		1: val = 16'h0002;
		2: val = 16'h0004;
		3: val = 16'h0008;
		4: val = 16'h0010;
		5: val = 16'h0020;
		6: val = 16'h0040;
		7: val = 16'h0080;
		8: val = 16'h0100;
		9: val = 16'h0200;
		10: val = 16'h0400;
		11: val = 16'h0800;
		12: val = 16'h1000;
		13: val = 16'h2000;
		14: val = 16'h4000;
		15: val = 16'h8000;
	   endcase;
	   expected_led = val;
	end
	endfunction

	/* returns the expected led data based on the input */
	function check_led_segment;
	   input [3:0] data_to_display;
	   input [3:0] data_in;
	   reg [15:0] val;
	begin
	   case(data_in)
		0: val = 16'h0001;
		1: val = 16'h0002;
		2: val = 16'h0004;
		3: val = 16'h0008;
		4: val = 16'h0010;
		5: val = 16'h0020;
		6: val = 16'h0040;
		7: val = 16'h0080;
		8: val = 16'h0100;
		9: val = 16'h0200;
		10: val = 16'h0400;
		11: val = 16'h0800;
		12: val = 16'h1000;
		13: val = 16'h2000;
		14: val = 16'h4000;
		15: val = 16'h8000;
	   endcase;
	   check_led_segment = val;
	end
	endfunction

	/* returns the expected led data based on the input */
	function check_outputs;
		input [15:0] sw;
		input btnc;
		input btnu;
		input btnl;
		input btnr;
		input btnd;
		input [6:0] segment;
		input [7:0] anode;
		integer errors;
		reg [3:0] exp_data;
		reg [6:0] exp_seg;
		//reg [7:0] exp_anode;
		reg [15:0] exp_led;
	begin
		errors = 0;
		
		// Determine expected values
		if (btnd == 1'b1) begin
			exp_data = sw[3:0] + sw[7:4];
		end else if (btnu == 1'b1) begin
			exp_data = sw[3:0] - sw[7:4];
		end else if (btnr == 1'b1) begin
			exp_data = 8'b1000;
		end else if (btnc == 1'b0 && btnl == 1'b0) begin
			exp_data = sw[3:0];
		end else if (btnc == 1'b1 && btnl == 1'b0) begin
			exp_data = sw[7:4];
		end else if (btnc == 1'b0 && btnl == 1'b1) begin
			exp_data = sw[11:8];
		end else if (btnc == 1'b1 && btnl == 1'b1) begin
			exp_data = sw[15:12];
		end

		exp_seg = expected_segment(exp_data);
		exp_led = expected_led(exp_data);
			
		if (exp_seg != segment) begin
			errors = errors + 1;
			$display("Error: segment values=%b but expected value = %b at time %t", segment,exp_seg, $time); 
		end
		if (exp_led != led) begin
			errors = errors + 1;
			$display("Error: led=%b but expected value = %b at time %t", led,exp_led, $time); 
		end
		if (anode != 8'b11111110) begin
            errors = errors + 1;
			$display("Error: anode=%b but the expected value = %b at time %t", anode, 8'b11111110, $time); 
		end
    /*
        if (errors > 0)
            $display("%d errors",errors);
    */
		check_outputs = errors;
	end
	endfunction

	// Instance the Dataflow module
	Dataflow dut(.sw(sw), .btnc(btnc), .btnu(btnu), .btnl(btnl), .btnr(btnr), .btnd(btnd), .led(led),
					.segment(segment), .anode(anode));

	initial begin

		errors = 0;
		// Initialize button values to 0 (none pressed)
		#20
		//$display("*** Starting simulation with no buttons pressed time %t ***", $time);
		#20
		btnc = 1'b0;
		btnl = 1'b0;
		btnr = 1'b0;
		btnu = 1'b0;
		btnd = 1'b0;
		sw = 0;
		#30
	
		$display("*** Starting simulation with no buttons pressed at time %t ***", $time);
		btnc = 1'b0;
		btnl = 1'b0;
		// Test all 16 cases of sw[3:0] (no buttons being pressed)
		for(i=0; i < 16; i=i+1) begin
			sw[3:0] = i;
			sw[7:4] = i+1;
			sw[11:8] = i+2;
			sw[15:12] = i+3;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);               
			errors = errors + c_errors;
//            if (c_errors > 0)
//                $display("%d errors",c_errors);
//            if (errors > 0)
//                    $display("%d total errors",errors);
 			#20;
		end

		$display("*** Starting simulation with btnc pressed at time %t ***", $time);
		btnc = 1'b1;
		btnl = 1'b0;
		// Test all 16 cases of sw[7:4] (btnc pressed)
		for(i=0; i < 16; i=i+1) begin
			sw[3:0] = i+1;
			sw[7:4] = i;
			sw[11:8] = i+2;
			sw[15:12] = i+3;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);
            errors = errors + c_errors;
 			#20;
		end

		$display("*** Starting simulation with btnl pressed at time %t ***", $time);
		btnc = 1'b0;
		btnl = 1'b1;
		// Test all 16 cases of sw[11:8] (btnl pressed)
		for(i=0; i < 16; i=i+1) begin
			sw[3:0] = i+1;
			sw[7:4] = i+2;
			sw[11:8] = i;
			sw[15:12] = i+3;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);
            errors = errors + c_errors;
 			#20;
		end

		$display("*** Starting simulation with btnc and btnl pressed at time %t ***", $time);
		btnc = 1'b1;
		btnl = 1'b1;
		// Test all 16 cases of sw[15:12] (btnl and btnc pressed)
		for(i=0; i < 16; i=i+1) begin
			sw[3:0] = i+1;
			sw[7:4] = i+2;
			sw[11:8] = i+3;
			sw[15:12] = i;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);
            errors = errors + c_errors;
 			#20;
		end

		$display("*** Starting simulation with btnr pressed at time %t ***", $time);
		btnc = 1'b0;
		btnl = 1'b0;
		btnr = 1'b1;
		btnu = 1'b0;
		btnd = 1'b0;
		// Test all 16 cases of sw[15:12] (btnl and btnc pressed)
		for(i=0; i < 16; i=i+1) begin
			sw[3:0] = i+1;
			sw[7:4] = i+2;
			sw[11:8] = i+3;
			sw[15:12] = i;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);
            errors = errors + c_errors;
 			#20;
		end

		$display("*** Starting simulation with btnu pressed at time %t ***", $time);
		btnc = 1'b0;
		btnl = 1'b0;
		btnr = 1'b0;
		btnu = 1'b1;
		btnd = 1'b0;
		// Test all 16 cases of sw[15:12] (btnl and btnc pressed)
		sw[15:8] = 0;
		for(i=0; i < 256; i=i+1) begin
			sw[7:0] = i;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);
            errors = errors + c_errors;
 			#20;
		end

		$display("*** Starting simulation with btnd pressed at time %t ***", $time);
		btnc = 1'b0;
		btnl = 1'b0;
		btnr = 1'b0;
		btnu = 1'b0;
		btnd = 1'b1;
		// Test all 16 cases of sw[15:12] (btnl and btnc pressed)
		sw[15:8] = 0;
		for(i=0; i < 256; i=i+1) begin
			sw[7:0] = i;
 			#20
 			c_errors = check_outputs(sw, btnc, btnu, btnl, btnr, btnd, segment, anode);
            errors = errors + c_errors;
 			#20;
		end
		
		#20
		$display("*** Simulation done with %3d errors at time %t ***", errors, $time);
		$finish;

	end  // end initial begin

	
endmodule