`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: debounce_top
*
* Author: Johnson, Ryan
* Class: ECEN 220, Section 2, Winter 2019
* Date: 26 March 2019
*
* Description: Records the number of times btnc is pushed, debouncing
*              the btnc signal and diplaying on the seven segment display.
*
****************************************************************************/

module debounce_top(
    input clk,
    input btnc,
    input btnd,
    output [7:0] anode,
    output [7:0] segment
    );
    
    logic btn1 = 0, btn2 = 0;
    logic dbBtn;
    logic btnEdge, btnEdgeB;
    logic [15:0] counter = 0;
    logic [15:0] counterB = 0;
    
    //synchronizer
    always_ff @(posedge clk)
    begin
        btn2 <= btn1;
        btn1 <= btnc;
    end

    //debouncer
    debounce db1 (clk, btn2, dbBtn);
    
    //one shot detector
    typedef enum logic[1:0] {s0, s1} StateType;
        StateType ns;
        StateType cs = s0;
        
    always_comb
    begin
        btnEdge = 0;
        case (cs)
            s0: if(dbBtn) begin
                    ns = s1;
                    btnEdge = 1;
                end
                else ns = s0;
            s1: if(dbBtn) ns = s1;
                else ns = s0;
        endcase
    end
    
    always_ff @(posedge clk)
        cs <= ns;
    
    //counter
    always_ff @(posedge clk)
        if (btnd) counter <= 0;
        else if(btnEdge) counter <= counter + 1;
        
    //UNDEBOUNCED onse shot detector
    
    StateType nsB;
    StateType csB = s0;
            
    always_comb
    begin
        btnEdgeB = 0;
        case (csB)
            s0: if(btnc) begin
                    nsB = s1;
                    btnEdgeB = 1;
                end
                else nsB = s0;
            s1: if(btnc) nsB = s1;
                else nsB = s0;
        endcase
    end
    
    always_ff @(posedge clk)
        csB <= nsB;  
        
    //UNDEBOUNCED counter
    always_ff @(posedge clk)
        if (btnd) counterB <= 0;
        else if(btnEdgeB) counterB <= counterB + 1;
        
    //Seven Segment Controller
    logic [31:0] dataIn;
    assign dataIn[31:16] = counterB[15:0];
    assign dataIn[15:0] = counter[15:0];
    logic [7:0] digitPoint = 8'b00000000;
    logic [7:0] digitDisplay = 8'b11111111;
    SevenSegmentControl ssc1 (clk, dataIn, digitDisplay, digitPoint, anode, segment);
      
    
endmodule
