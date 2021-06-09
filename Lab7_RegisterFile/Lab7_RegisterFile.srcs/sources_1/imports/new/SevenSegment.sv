`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2019 12:28:05 PM
// Design Name: 
// Module Name: SevenSegment
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


module SevenSegment(
    output [6:0] segment,
    input [3:0] data
    );
    
    assign segment = (data == 4'b0000) ? 7'b1000000 :
                     (data == 4'b0001) ? 7'b1111001 :
                     (data == 4'b0010) ? 7'b0100100 :
                     (data == 4'b0011) ? 7'b0110000 :
                     (data == 4'b0100) ? 7'b0011001 :
                     (data == 4'b0101) ? 7'b0010010 :
                     (data == 4'b0110) ? 7'b0000010 :
                     (data == 4'b0111) ? 7'b1111000 :
                     (data == 4'b1000) ? 7'b0000000 :
                     (data == 4'b1001) ? 7'b0010000 :
                     (data == 4'b1010) ? 7'b0001000 :
                     (data == 4'b1011) ? 7'b0000011 :
                     (data == 4'b1100) ? 7'b1000110 :
                     (data == 4'b1101) ? 7'b0100001 :
                     (data == 4'b1110) ? 7'b0000110 :
                     (data == 4'b1111) ? 7'b0001110 : 7'b0000000;
    
endmodule
