`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: seven_segment_top
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 12 Feb 2019
*
* Description: This file takes 4 binary inputs and pressed button inputs and outputs the logic for a seven segment display
*
****************************************************************************/

module seven_segment_top(
    input [3:0] sw,
    input btnc,
    input btnl,
    input btnr,
    output [7:0] segment,
    output [7:0] anode
    );
    
    logic [6:0] chosenSeg;
    logic [6:0] seg;
    logic [6:0] mySeg;
    assign mySeg = 7'b0010100;
    logic sel, selN;
    and(sel, btnr);
    not(selN, sel);
    
    seven_segment p1(sw, seg[6:0]);
    
    logic [6:0] mid1, mid2;
    
    and(mid1[0], seg[0], selN);
    and(mid1[1], seg[1], selN);
    and(mid1[2], seg[2], selN);
    and(mid1[3], seg[3], selN);
    and(mid1[4], seg[4], selN);
    and(mid1[5], seg[5], selN);
    and(mid1[6], seg[6], selN);
    
    and(mid2[0], mySeg[0], sel);
    and(mid2[1], mySeg[1], sel);
    and(mid2[2], mySeg[2], sel);
    and(mid2[3], mySeg[3], sel);
    and(mid2[4], mySeg[4], sel);
    and(mid2[5], mySeg[5], sel);
    and(mid2[6], mySeg[6], sel);
    
    or(chosenSeg[0], mid1[0], mid2[0]);
    or(chosenSeg[1], mid1[1], mid2[1]);
    or(chosenSeg[2], mid1[2], mid2[2]);
    or(chosenSeg[3], mid1[3], mid2[3]);
    or(chosenSeg[4], mid1[4], mid2[4]);
    or(chosenSeg[5], mid1[5], mid2[5]);
    or(chosenSeg[6], mid1[6], mid2[6]);
    
    and(segment[0], chosenSeg[0]);
    and(segment[1], chosenSeg[1]);
    and(segment[2], chosenSeg[2]);
    and(segment[3], chosenSeg[3]);
    and(segment[4], chosenSeg[4]);
    and(segment[5], chosenSeg[5]);
    or(segment[6], chosenSeg[6], btnl);
    
    not(segment[7], btnc);
    
    assign anode = 8'b11111110;
     
endmodule

    