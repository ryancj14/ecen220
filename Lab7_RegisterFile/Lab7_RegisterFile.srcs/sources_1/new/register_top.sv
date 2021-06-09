`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: register_top
*
* Author: Johnson, Ryan
* Class: ECEN 220, Section 002, Winter 2019
* Date: 5 March 2019
*
* Description: Connects to FPGA board to implement register_file_8x4
*
****************************************************************************/


module register_top(
    input clk,
    input [10:0] sw,
    input btnc,
    input btnr,
    input btnd,
    input btnu,
    input btnl,
    output [7:0] segment,
    output [7:0] anode
    );
    
    logic [3:0] dataout1, dataout2, toDisplay;
    register_file_8x4 my_rf (clk, sw[3:0], btnc, sw[6:4], sw[6:4], sw[9:7], dataout1, dataout2);
    
    assign toDisplay = (btnr) ? dataout2 :
                       (btnu) ? dataout1 + dataout2 :
                       (btnd) ? dataout1 - dataout2 :
                       (btnl) ? dataout1 & dataout2 : dataout1;
                       
    SevenSegment display (segment[6:0], toDisplay);
    assign segment[7] = 1'b1;
    assign anode = 8'b11111110;
    
endmodule
