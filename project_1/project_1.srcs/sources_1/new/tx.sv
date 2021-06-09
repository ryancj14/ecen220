`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: tx
*
* Author: Ryan Johnson
* Class: ECEN 220, Section 2, Winter 2019
* Date: 2 April 2019
*
* Description: Implements an asynchronous transmitter module
*
****************************************************************************/

module tx(
    input clk,
    input Reset,
    input Send,
    input [7:0] Din,
    output logic Sent,
    output logic Sout
    );
    
    logic[2:0] bitNum = 0;
    logic[12:0] timer = 0;
    logic clrTimer, clrBit, incBit, startBit, dataBit, parityBit, timerDone, bitDone = 0;
    
    typedef enum logic[2:0] {IDLE, START, BITS, PAR, STOP, ACK, ERR='X} StateType;
        StateType ns;
        StateType cs = IDLE;
    
    always_comb
    begin
        Sent = 0;
        clrTimer = 0;
        clrBit = 0;
        incBit = 0;
        startBit = 0;
        dataBit = 0;
        parityBit = 0;
        ns = ERR;
        
        if (Reset) 
            ns = IDLE;
        else case (cs)
            IDLE:   begin
                        clrTimer = 1;
                        if (Send) ns = START;
                        else ns = IDLE;
                    end
            START:  begin
                        startBit = 1;
                        if (timerDone)
                        begin  
                            clrBit = 1;
                            ns = BITS;
                        end
                        else ns = START;
                    end
            BITS:   begin
                        dataBit = 1;
                        if (timerDone & bitDone) ns = PAR;
                        else if (timerDone) begin
                            incBit = 1;
                            ns = BITS;
                        end
                    end
            PAR:    begin
                        parityBit = 1;
                        if (timerDone) ns = STOP;
                        else ns = PAR;
                    end
            STOP:   begin
                        if (timerDone) ns = ACK;
                        else ns = STOP;
                    end
            ACK:    begin
                        Sent = 1;
                        if (Send) ns = ACK;
                        else ns = IDLE;
                    end
        endcase
    end
    
    always_ff @(posedge clk)
        cs <= ns;
        
    always_ff @(posedge clk) 
        if (clrTimer) begin
                timer <= 0;
                timerDone <= 0;
            end
        else if (timer == 5208) begin
                timerDone <= 1;
                timer <= 0;
            end
        else begin
                timer <= timer + 1;
                timerDone <= 0;
            end
            
    always_ff @(posedge clk)
        if (clrBit) begin
                bitNum <= 0;
                bitDone <= 0;
            end
        else if (incBit & bitNum == 8) begin
                bitNum <= 0;
                bitDone <= 1;
            end
        else if (incBit)
            bitNum <= bitNum + 1;
                
    always_ff @(posedge clk)
        if (startBit)
            Sout <= 0;
        else if (dataBit)
            Sout <= Din[bitNum];
        else if (parityBit)
            Sout <= ~^Din;
        else
            Sout <= 1;
    
endmodule
