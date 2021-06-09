`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: PWM
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 19 Mar 2019
*
* Description: PWM module controls the pulse, taking the clk and width as inputs
*
*
****************************************************************************/


module PWM(
    input clk,
    input [13:0] width,
    output logic pulse
    );
    
    logic[13:0] counter = 0;
    
    always_ff @(posedge clk)
       counter <= counter + 1;
       
    logic d;
    assign d = (width > counter) ? 1'b1 : 1'b0;
    
    always_ff @(posedge clk)
        pulse <= d;
    
endmodule
