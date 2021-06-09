`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: rx
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 9 April 2019
*
* Description: Implements an reciever module
*
****************************************************************************/

module uart_top(
    input clk,
    input [7:0] sw,
    input btnc,
    input btnd,
    input rx_in,
    output tx_out,
    output [7:0] segment,
    output [7:0] anode,
    output rx_error,
    output tx_debug,
    output rx_debug
    );
        
    logic send, reset;
    logic sout, sent;
    tx tx1(clk, reset, send, sw, sent, sout);
    assign tx_out = sout;
    assign tx_debug = sout;
    
    debounce db1(clk, btnc, send);
    debounce db2(clk, btnd, reset);
    
    logic rxHandshake, receive;
    assign rxHandshake = receive;
    logic [7:0] Dout;
    rx rx1(clk, reset, rx_in, receive, rxHandshake, Dout, rx_error);
    
    
    logic [31:0] dataIn = {8'b00000000, Dout[7:0], 8'b00000000, sw[7:0]};
    logic [7:0] digitDisplay = 8'b00110011;
    logic [7:0] digitPoint = 0;
    SevenSegmentControl ssc1(clk, dataIn, digitDisplay, digitPoint, anode, segment);
    
endmodule
