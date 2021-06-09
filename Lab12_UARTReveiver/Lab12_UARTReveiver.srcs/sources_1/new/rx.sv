`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: rx
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 9 April 2019
*
* Description: Implements an reciever module
*
****************************************************************************/
module rx(
    input logic clk,
    input logic Reset,
    input logic Sin,
    output logic Receive,
    input logic Received,
    output logic[7:0] Dout,
    output logic parityErr
    );
    
    //timer logic
    logic[12:0] timer = 0;
    logic timerDone, timerHalf, clrTimer;
    
    always_ff @(posedge clk) 
        if (clrTimer) begin
            timer <= 0;
            timerDone <= 0;
            timerHalf <= 0;
        end
        else if (timer == 2604) begin
            timerHalf <= 1;
            timer <= timer + 1;
        end
        else if (timer == 5208) begin
            timerDone <= 1;
            timer <= 0;
        end
        else begin
            timer <= timer + 1;
            timerDone <= 0;
            timerHalf <= 0;
        end
    
    //shift register logic
    logic clrBit, incBit, parityBit; 
    logic shift, bitDone = 0;
    logic[2:0] bitNum = 0;    
    
    typedef enum logic[2:0] {IDLE, START_H, BITS, PAR, STOP, ACK, ERR='X} StateType;
        StateType ns;
        StateType cs = IDLE;
            
        always_comb
        begin
            Receive = 0;
            clrTimer = 0;
            clrBit = 0;
            incBit = 0;
            shift = 0;
            ns = ERR;
                
            if (Reset) 
                ns = IDLE;
            else case (cs)
                IDLE:   begin
                            clrTimer = 1;
                            if (~Sin) ns = START_H;
                            else ns = IDLE;
                        end
                START_H: begin
                            clrBit = 1;
                            if (timerHalf) begin
                                ns = BITS;
                                clrTimer = 1;
                                clrBit = 1;
                            end
                            else ns = START_H;
                        end       
                BITS:   begin
                            if (~timerDone) ns = BITS;
                            else if (timerDone & ~bitDone) begin
                                incBit = 1;
                                shift = 1;
                                ns = BITS;
                            end
                            else begin
                                ns = PAR;
                                shift = 1;
                            end
                        end
                PAR:    begin
                            if (timerDone) begin
                                shift = 1;
                                ns = STOP;
                            end
                            else ns = PAR;
                        end
                STOP:   begin
                            if (timerDone)
                                ns = ACK;
                            else ns = STOP;
                        end
                ACK:    begin
                            Receive = 1;
                            if (Received) ns = IDLE;
                            else ns = ACK;
                        end
            endcase
        end
            
    always_ff @(posedge clk)
        cs <= ns;    
        
    always_ff @(posedge shift) begin
        parityBit <= Sin;
        Dout[7] <= parityBit;
        Dout[6] <= Dout[7];
        Dout[5] <= Dout[6];
        Dout[4] <= Dout[5];
        Dout[3] <= Dout[4];
        Dout[2] <= Dout[3];
        Dout[1] <= Dout[2];
        Dout[0] <= Dout[1];
    end
    
    always_ff @(posedge clk)
        if (clrBit) begin
            bitNum <= 0;
            bitDone <= 0;
        end
        else if (incBit)
            bitNum <= bitNum + 1;
        else if (bitNum == 7)
            bitDone <= 1;
            
     assign parityErr = (~^Dout == parityBit) ? 0 : 1;
    
endmodule
