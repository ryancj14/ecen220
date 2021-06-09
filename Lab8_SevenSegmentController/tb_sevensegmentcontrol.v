`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_SevenSegmentControl.v
//
//  Author: Mike Wirthlin
//  
//  Description:
//
//  Version: 1.3
//
//////////////////////////////////////////////////////////////////////////////////

module tb_SevenSegmentControl();

	reg clk = 0;
	reg [31:00] segmentData;
	reg [7:0] digitsOn;
	reg [7:0] digitPoint;
	
	wire [7:0] segment;
	wire [7:0] anode;

	time t_time, d_time;
	reg [7:0] anode_o;
	
	integer test,j,i,k;
	localparam ANODE_TIME_MIN = 160000; // 160 us
	localparam ANODE_TIME_MAX = 200000; // 200 us
	
	// Instance seven segment display controller
	SevenSegmentControl SSC(.clk(clk),.dataIn(segmentData), .digitDisplay(digitsOn),
							.digitPoint(digitPoint), .anode(anode), .segment(segment));
	
	// Clock process
	always 
		#5  clk =  ! clk; 

		
	initial begin

        //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
		$timeformat(-9, 0, " ns", 20);
		$display("*** Start of Simulation ***");

        // Initialize top-level signals
		segmentData = 32'h00000000;
		digitsOn = 8'b00000000;
		digitPoint = 8'b00000000;

		test = 1;
		$display("Test #%0d: Disable all digits", test);
		#2000
		test = test + 1;

		$display("Test #%0d: Test for initial anode change", test);
		segmentData = 32'h88888888;
		digitPoint = 8'b11111111;
		digitsOn = 8'b11111111;
		test = test + 1;
		anode_o = anode;
		// Wait for maximum anode time (200 us or 200000 ns)
		#200000
		// Check to see if the anode has changed. If not, then the controller has
		// a problem and the rest of the testbench will hang. Exit the simulation.
		if (anode == anode_o) begin
			$display("** Error: The anode signal has not changed in 200 us. The anode signal should have");
			$display("**        changed by now. Go back and fix the anode logic and rerun the simulation.");
			$finish;
		end
		
		$display("Test #%0d: Test anode assert time", test);
		#200

		// Wait until the anode changes (note that if the controller never changes the 
		// anode then the testbench will hang here).
		@(anode);

		t_time = $time;
		for (j=0; j < 8; j = j + 1) begin
		    // Wait until the anode changes again
    		@(anode);
    		d_time = $time - t_time;
    		if ( (d_time <  ANODE_TIME_MIN) ||
    		     (d_time >  ANODE_TIME_MAX) ) begin
    		  $display("Incorrect anode time of %0t at time",d_time,$time);
    		end;
    		t_time = $time;
		end;
        test = test + 1;

		$display("Test #%0d: Test each digit one at a time (76543210) (digit points on)", test);
		segmentData = 32'h76543210;
		digitPoint = 8'b11111111;
		for (j = 0 ; j < 8; j = j+1) begin
			digitsOn = (1 << j);
			@(negedge anode[j]);				// Wait until anode is activated
			@(posedge anode[j]);
			@(negedge anode[j]);				// activated a second time
		end;
		#200
		test = test + 1;

		$display("Test #%0d: Test each digit one at a time (FEDCBA98) (digit points off)", test);
		segmentData = 32'hFEDCBA98;
		digitPoint = 8'b00000000;
		for (j = 0 ; j < 8; j = j+1) begin
			digitsOn = (1 << j);
			@(negedge anode[j]);				// Wait until anode is activated
			@(posedge anode[j]);
			@(negedge anode[j]);				// activated a second time
		end;
		#200
		test = test + 1;
		
		$display("Test #%0d: Enable all digits and test 76543210 (digit points on)", test);
		digitsOn = 8'b11111111;
		digitPoint = 8'b11111111;
		segmentData = 32'h76543210;
		@(negedge anode[0]);
		@(negedge anode[0]);
		test = test + 1;
		#200
	
		$display("Test #%0d: Enable all digits and test FEDCBA98 (digit points off)", test);
		digitsOn = 8'b11111111;
		digitPoint = 8'b00000000;
		segmentData = 32'hFEDCBA98;
		@(negedge anode[0]);
		@(negedge anode[0]);
		test = test + 1;

		$display("** Simulation Done ** at time %0t", $time);
		$finish;

	end  // end initial begin

	// Always block to verify the correct values of the anode.
    // This will make the following tests:
	//  - Make sure one and only one anode signal is asserted at a time
	//  - Make sure the appropriate anode signal is asserted based on the "digitsOn" signal
	always @(anode or digitsOn)
	begin
		// I need a bit of delay before making the check. The simulator may try
        // to check when one signal has changed but the other has not. This delay
        // will allow the signals to settle down.
        #1
        
		// Make sure there is only at most one anode signal asserted
		k = 0;
		for(i = 0; i < 8; i = i + 1) begin
			if(anode[i] == 1'b0)
				k = k + 1;
		end
		if(k > 1)
			$display("ERROR: More than one anode signal asserted at time %t", $time);
		// Now make sure that the anode signal is not violating the digitsOn
		for(i = 0; i < 8; i = i + 1) begin
			if(anode[i] == 1'b0 && digitsOn[i] == 1'b0)
				$display("ERROR: anode[%1d] is asserted but digitsOn[%1d] is deasserted at time %t", 
					anode[i],digitsOn[i],$time);
		end
		
	end
	
	// Always block to verify the correct values of the segments. This block will compare the
	// segment data with the expected value based on the current anode and the data to display.
	always @(segmentData or anode or segment)
	begin : SEGMENT_BLOCK
		reg [7:0] data_in;
		reg dp_in;
		reg [6:0] segment_const [15:0];
		
		// I need a bit of delay before making the check. The simulator may try
		// to check when one signal has changed but the other has not. This delay
		// will allow the signals to settle down.
		#1
		segment_const[0] = 7'b1000000;
		segment_const[1] = 7'b1111001;
		segment_const[2] = 7'b0100100;
		segment_const[3] = 7'b0110000;
		segment_const[4] = 7'b0011001;
		segment_const[5] = 7'b0010010;
		segment_const[6] = 7'b0000010;
		segment_const[7] = 7'b1111000;
		segment_const[8] = 7'b0000000;
		segment_const[9] = 7'b0010000;
		segment_const[10] = 7'b0001000;
		segment_const[11] = 7'b0000011;
		segment_const[12] = 7'b1000110;
		segment_const[13] = 7'b0100001;
		segment_const[14] = 7'b0000110;
		segment_const[15] = 7'b0001110;
		
		if (anode != 8'b11111111) begin
			case (anode)
				8'b11111110: begin data_in = segmentData[3:0]; dp_in = digitPoint[0]; end
				8'b11111101: begin data_in = segmentData[7:4]; dp_in = digitPoint[1]; end
				8'b11111011: begin data_in = segmentData[11:8]; dp_in = digitPoint[2]; end
				8'b11110111: begin data_in = segmentData[15:12]; dp_in = digitPoint[3]; end
				8'b11101111: begin data_in = segmentData[19:16]; dp_in = digitPoint[4]; end
				8'b11011111: begin data_in = segmentData[23:20]; dp_in = digitPoint[5]; end
				8'b10111111: begin data_in = segmentData[27:24]; dp_in = digitPoint[6]; end
				8'b01111111: begin data_in = segmentData[31:28]; dp_in = digitPoint[7]; end
			endcase

			if (segment_const[data_in] != segment[6:0])
				$display("ERROR: Incorrect segment data. segment[6:0] is %b but should be %b at time %t anode %b",
					segment[6:0],segment_const[data_in],$time,anode);

			if (segment[7] != (~dp_in))
				$display("ERROR: Incorrect digit point segment. segment[7] is %1d should be %1b at time %t",
					segment[7],~dp_in,$time);
		end
	end
	
	/*
	// Always block to check on anode signal timeout. If the controller never changes the 
	// anode then the main testbench always block will hang (this has happened with several
	// students). This always block is intended to timeout and exit the simulation if the
	// controller never changes the anode.
	always @(negedge clk)
	begin
	end
	*/
	
endmodule