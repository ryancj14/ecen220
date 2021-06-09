`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2019 12:15:48 PM
// Design Name: 
// Module Name: FullAdd
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


module FullAdd(
    input logic a, b, cin,
    output logic s, co
    );
    
    logic x, y, z;
    
    xor(co, a, b, cin);
    
    and(x, a, b);
    and(y, b, cin);
    and(z, a, cin);
    or(s, x, y, z);
    
endmodule
