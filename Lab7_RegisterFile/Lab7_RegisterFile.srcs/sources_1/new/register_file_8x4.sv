`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: register4
*
* Author: Johnson, Ryan
* Class: ECEN 220, Section 002, Winter 2019
* Date: 5 March 2019
*
* Description: Contains 8 4-bit registers, writes into them using the waddr given, and reads out two of them using the 
    raddr1 and raddr2 given.
*
****************************************************************************/


module register_file_8x4(
    input clk,
    input [3:0] datain,
    input we,
    input [2:0] waddr,
    input [2:0] raddr1,
    input [2:0] raddr2,
    output [3:0] dataout1,
    output [3:0] dataout2
    );
    
    logic[7:0] write;
    assign write = (8'b00000001 << waddr);
    
    logic[3:0] q0, q1, q2, q3, q4, q5, q6, q7;
    register4 r0 (clk, we & write[0], datain, q0);
    register4 r1 (clk, we & write[1], datain, q1);
    register4 r2 (clk, we & write[2], datain, q2);
    register4 r3 (clk, we & write[3], datain, q3);
    register4 r4 (clk, we & write[4], datain, q4);
    register4 r5 (clk, we & write[5], datain, q5);
    register4 r6 (clk, we & write[6], datain, q6);
    register4 r7 (clk, we & write[7], datain, q7);
    
    assign dataout1 = (raddr1 == 3'b000) ? q0 :
                      (raddr1 == 3'b001) ? q1 :
                      (raddr1 == 3'b010) ? q2 :
                      (raddr1 == 3'b011) ? q3 :
                      (raddr1 == 3'b100) ? q4 :
                      (raddr1 == 3'b101) ? q5 :
                      (raddr1 == 3'b110) ? q6 : q7;
    
    assign dataout2 = (raddr2 == 3'b000) ? q0 :
                      (raddr2 == 3'b001) ? q1 :
                      (raddr2 == 3'b010) ? q2 :
                      (raddr2 == 3'b011) ? q3 :
                      (raddr2 == 3'b100) ? q4 :
                      (raddr2 == 3'b101) ? q5 :
                      (raddr2 == 3'b110) ? q6 : q7;
    
endmodule
