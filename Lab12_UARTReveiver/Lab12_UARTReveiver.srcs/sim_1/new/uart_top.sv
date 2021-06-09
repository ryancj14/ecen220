`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2019 02:01:44 PM
// Design Name: 
// Module Name: uart_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
endmodule
