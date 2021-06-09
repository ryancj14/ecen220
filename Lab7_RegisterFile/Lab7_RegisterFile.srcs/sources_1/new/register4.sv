`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: register4
*
* Author: Johnson, Ryan
* Class: ECEN 220, Section 002, Winter 2019
* Date: 5 March 2019
*
* Description: 4-bit register that holds 4 bits
*
****************************************************************************/

module register4(
    input clk,
    input we,
    input [3:0] datain,
    output [3:0] dataout
    );
    
    FDCE ff3 (.Q(dataout[3]), .C(clk), .CE(we), .CLR(1'b0), .D(datain[3]));
    FDCE ff2 (.Q(dataout[2]), .C(clk), .CE(we), .CLR(1'b0), .D(datain[2]));
    FDCE ff1 (.Q(dataout[1]), .C(clk), .CE(we), .CLR(1'b0), .D(datain[1]));
    FDCE ff0 (.Q(dataout[0]), .C(clk), .CE(we), .CLR(1'b0), .D(datain[0]));
                
endmodule
