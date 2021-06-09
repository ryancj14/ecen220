`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: debounce
*
* Author: Johnson, Ryan
* Class: ECEN 220, Section 2, Winter 2019
* Date: 26 March 2019
*
* Description: debounces a noisy signal 
*
*
****************************************************************************/

module debounce(
    input clk,
    input noisy,
    output logic debounced
    );
    
    typedef enum logic[1:0] {s0, s1, s2, s3} StateType;
    StateType ns;
    StateType cs = s0;
    
    logic [18:0] timer = 0;
    logic clrTimer;
    logic synchNoisy;
    logic timerDone;
    
    always_ff @(posedge clk)
        synchNoisy <= noisy;
    
    always_ff @(posedge clk)
        if (clrTimer) timer <= 0;
        else timer <= timer + 1;
    
    assign timerDone = (timer==19'h7A120) ? 1 : 0;
    
    always_comb
    begin
        ns = cs;
        clrTimer = 0;
        debounced = 0;
        case (cs)
            s0: begin
                    if(noisy) ns = s1;
                    else ns = s0;
                    clrTimer = 1;
                end
            s1: if(~noisy) ns = s0;
                else if(timerDone) ns = s2;
                else ns = s1;
            s2: begin
                    if(~noisy) ns = s3;
                    else ns = s2;
                    clrTimer = 1;
                    debounced = 1;
                end
            s3: begin
                    if(noisy) ns = s2;
                    else if(timerDone) ns = s0;
                    else ns = s3;
                    debounced = 1;
                end
            default: ns = s0;
        endcase
    end
    
    always_ff @(posedge clk)
        cs <= ns;
    
endmodule
