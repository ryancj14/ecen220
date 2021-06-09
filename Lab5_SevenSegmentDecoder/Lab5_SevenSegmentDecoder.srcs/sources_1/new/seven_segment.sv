`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: seven_segment
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 12 Feb 2019
*
* Description: This file takes 4 binary inputs and outputs the logic for a seven segment display
*
*
****************************************************************************/

module seven_segment(
    input [3:0] data,
    output [6:0] segment
    );
    
    //implementing not logic;
    logic[3:0] dataN;
    not(dataN[0], data[0]);
    not(dataN[1], data[1]);
    not(dataN[2], data[2]);
    not(dataN[3], data[3]);
    
    //segment CA
    logic s, t, u, v;
    xor(s, data[2], data[0]);
    and(u, s, dataN[3], dataN[1]);
    
    xor(t, data[2], data[1]);
    and(v, t, data[3], data[0]);
    
    or(segment[0], u, v);
    
    //segment CB
    logic w, x, y, z, a, b, c;
    xor(w, data[1], data[0]);
    and(x, w, dataN[3], data[2]);
    
    and(y, data[2], data[1]);
    and(z, data[2], dataN[1], dataN[0]);
    and(a, dataN[2], data[1], data[0]);
    or(b, y, z, a);
    and(c, b, data[3]);
    
    or(segment[1], x, c);
    
    //segments CC through CG
    LUT4 #(16'hd004) seg2(.O(segment[2]), .I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]));
    LUT4 #(16'h8492) seg3(.O(segment[3]), .I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]));
    LUT4 #(16'h02ba) seg4(.O(segment[4]), .I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]));
    LUT4 #(16'h208e) seg5(.O(segment[5]), .I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]));
    LUT4 #(16'h1083) seg6(.O(segment[6]), .I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]));
    
    


    
   
endmodule
