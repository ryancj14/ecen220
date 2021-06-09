`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: Dataflow
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 1, Winter 2019
* Date: 26 Feb 2019
*
* Description: Displays values on the seven segment dislay and led lights using dataflow and inputs from the buttons and switches.
*
*
****************************************************************************/


module Dataflow(
    input [15:0] sw,
    input btnc,
    input btnu,
    input btnr,
    input btnl,
    input btnd,
    output [15:0] led,
    output [7:0] segment,
    output [7:0] anode
    );
    
    logic [3:0] data;
    
    assign data = (btnd) ? sw[3:0] + sw[7:4] :
                  (btnu) ? sw[3:0] - sw[7:4] :
                  (btnr) ? 4'b1000 :
                  (~btnl & ~btnc) ? sw[3:0] :
                  (~btnl & btnc) ? sw[7:4] :
                  (btnl & ~btnc) ? sw[11:8] : sw[15:12];
    
    SevenSegment p1(segment[6:0], data[3:0]);
    
    assign segment[7] = 1'b1;
    
    assign anode = 8'b11111110;
    
    assign led = (data == 4'b0000) ? 16'b0000000000000001 :
                 (data == 4'b0001) ? 16'b0000000000000010 :
                 (data == 4'b0010) ? 16'b0000000000000100 :
                 (data == 4'b0011) ? 16'b0000000000001000 :
                 (data == 4'b0100) ? 16'b0000000000010000 :
                 (data == 4'b0101) ? 16'b0000000000100000 :
                 (data == 4'b0110) ? 16'b0000000001000000 :
                 (data == 4'b0111) ? 16'b0000000010000000 :
                 (data == 4'b1000) ? 16'b0000000100000000 :
                 (data == 4'b1001) ? 16'b0000001000000000 :
                 (data == 4'b1010) ? 16'b0000010000000000 :
                 (data == 4'b1011) ? 16'b0000100000000000 :
                 (data == 4'b1100) ? 16'b0001000000000000 :
                 (data == 4'b1101) ? 16'b0010000000000000 :
                 (data == 4'b1110) ? 16'b0100000000000000 : 16'b1000000000000000;
    
endmodule
