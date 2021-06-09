`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: PWM_top
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 19 Mar 2019
*
* Description: connnects the PWM module to the functionality of the FPGA board controlling the pulse lengths of different colored LEDs to make different shades of color.
*
*
****************************************************************************/


module PWM_top(
    input clk,
    input [11:0] sw,
    output pulse_red,
    output pulse_green,
    output pulse_blue,
    output [7:0] segment,
    output [7:0] anode,
    output [2:0] debug
    );
    
    logic [13:0] gwidth, bwidth, rwidth;
    
    assign gwidth[13] = 0;
    assign bwidth[13] = 0;
    assign rwidth[13] = 0;
    assign gwidth[8:0] = 0;
    assign bwidth[8:0] = 0;
    assign rwidth[8:0] = 0;
    
    assign gwidth[12:9] = sw[7:4];
    assign bwidth[12:9] = sw[3:0];
    assign rwidth[12:9] = sw[11:8];
    
    PWM green(clk, gwidth, pulse_green);
    PWM blue(clk, bwidth, pulse_blue);
    PWM red(clk, rwidth, pulse_red);
    
    logic [31:0] dataIn;
    assign dataIn[31:12] = 0;
    assign dataIn[11:0] = sw[11:0];
    SevenSegmentControl color(clk, dataIn, 8'b00000111, 8'b00000000, anode, segment);
    
    assign debug[0] = pulse_red;
    assign debug[1] = pulse_green;
    assign debug[2] = pulse_blue;
    
endmodule
