`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: tx
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 2 April 2019
*
* Description: Implements an asynchronous transmitter module
*
****************************************************************************/

module tx_top(
    input clk,
    input [7:0] sw,
    input btnc,
    input btnd,
    output tx_out,
    output [7:0] segment,
    output [7:0] anode,
    output tx_debug
    );
    
    logic send, reset;
    logic sent, sout;
    tx tx1(clk, reset, send, sw, sent, sout);
    
    assign tx_debug = sout;
    assign tx_out = sout;
    
    logic [31:0] dataIn = {24'b000000000000000000000000, sw[7:0]};
    logic [7:0] digitDisplay = 8'b00000011;
    logic [7:0] digitPoint = 0;
    SevenSegmentControl ssc1(clk, dataIn, digitDisplay, digitPoint, anode, segment);
    
    debounce db1(clk, btnc, send);
    debounce db2(clk, btnd, reset);
    
endmodule
