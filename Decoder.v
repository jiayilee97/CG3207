`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: Decoder
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: Decoder Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

module Decoder(
    input [3:0] Rd,
    input [1:0] Op,
    input [5:0] Funct,
    output PCS,
    output RegW,
    output MemW,
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output NoWrite,
    output reg [3:0] ALUControl,
    output reg [1:0] FlagW,
    // added by JY
    output reg start,
    output reg [1:0] MCycleOP,
    output reg isMCycle
    );
    
    wire ALUOp ;
    reg [9:0] controls ;
    //<extra signals, if any>
    reg isNegOffset ;
    
   /* controls = [branch
            , memtoreg
            , memw
            , alusrc
            , immsrc[0]
            , immsrc[1]
            , regW
            , regSrc[0]
            , regSrc[1]
            , ALUOP]
   */ 
    
    always @ (Op,Funct,Rd)
    begin
        controls = 10'b0000000000;
        ALUControl <= 4'b0000;
        FlagW <= 2'b00;
        isNegOffset <= 1'b0;
        isMCycle <=0;
        start=0;
        
//        // MUL
//        if ((Op == 2'b00) && (Funct[5:1] == 5'b00000)) begin
//            controls <= 10'b0000001000;
//            isMCycle <= 1;
//            MCycleOP <= 2'b01;   
//            start <= 1;
//        // DIV
//        end else if ((Op == 2'b00) && (Funct[5:1] == 5'b00001)) begin
//            controls <= 10'b0000001000;
//            isMCycle <= 1;
//            MCycleOP <= 2'b11;
//            start <= 1;
        // DP Reg
        if ((Op == 2'b00) && (Funct[5] == 0)) begin
            controls = 10'b0000XX1001;
        // DP Imm
        end else if ((Op == 2'b00) && (Funct[5] == 1)) begin
            controls = 10'b0001001X01;
        // STR
        end else if ((Op == 2'b01) && (Funct[0] == 0)) begin
            controls = 10'b0X11010100;
            if (Funct[3] == 0) begin
                isNegOffset = 1;
            end else if (Funct[3] == 1) begin
                isNegOffset = 0;
            end
        // LDR
        end else if ((Op == 2'b01) && (Funct[0] == 1)) begin
            
            controls = 10'b0101011X00;
            if (Funct[3] == 0) begin
                isNegOffset = 1;
            end else if (Funct[3] == 1) begin
                isNegOffset = 0;
            end
        // B
        end else if (Op == 2'b10) begin
            controls = 10'b1001100X10;
        end
        
        //case 1 (Not DP)
        if (controls[0]==0) begin
            // ALUControl <= 2'b00;
            FlagW <= 2'b00;
            if (isNegOffset == 1) begin
                ALUControl <= 4'b0001;
            end else if (isNegOffset == 0) begin
                ALUControl <= 4'b0000;
            end
        // EOR
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b0001)) begin
            ALUControl <= 4'b0100;
            FlagW <= 2'b00;
        // RSB
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b0011)) begin
            ALUControl <= 4'b0101;
            FlagW <= 2'b00;        
        // ADC
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b0101)) begin
            ALUControl <= 4'b0110;
            FlagW <= 2'b00;
        // SBC
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b0110)) begin
            ALUControl <= 4'b0111;
            FlagW <= 2'b00;
        // RSC
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b0111)) begin
            ALUControl <= 4'b1000;
            FlagW <= 2'b00;
        // TST
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b1000)) begin
            ALUControl <= 4'b1001;
            FlagW <= 2'b11;
        // TEQ
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b1001)) begin
            ALUControl <= 4'b1010;
            FlagW <= 2'b11;
        // MOV
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b1101)) begin
            ALUControl <= 4'b1011;
            FlagW <= 2'b00;
        // BIC
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b1110)) begin
            ALUControl <= 4'b1100;
            FlagW <= 2'b00;
        // MVN
        end else if ((Op == 2'b00) && (Funct[4:1] == 4'b1111)) begin
            ALUControl <= 4'b1101;
            FlagW <= 2'b00;
        //case 2 (ADD)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b0100) && (Funct[0] == 0)) begin
            ALUControl <= 4'b0000;
            FlagW <= 2'b00; 
        //case 3 (ADDS)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b0100) && (Funct[0] == 1)) begin
            ALUControl <= 4'b0000;
            FlagW <= 2'b11;
        //case 4 (SUB)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b0010) && (Funct[0] == 0)) begin
            ALUControl <= 4'b0001;
            FlagW <= 2'b00;
        //case 5 (SUBS)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b0010) && (Funct[0] == 1)) begin
            ALUControl <= 4'b0001;
            FlagW <= 2'b11;
        //case 6 (AND)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b0000) && (Funct[0] == 0)) begin
            ALUControl <= 4'b0010;
            FlagW <= 2'b00; 
        //case 7 (ANDS)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b0000) && (Funct[0] == 1)) begin
            ALUControl <= 4'b0010;
            FlagW <= 2'b10;
        //case 8 (ORR)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b1100) && (Funct[0] == 0)) begin
            ALUControl <= 4'b0011;
            FlagW <= 2'b00;
        //case 9 (ORRS)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b1100) && (Funct[0] == 1)) begin
            ALUControl <= 4'b0011;
            FlagW <= 2'b10;   
        
        //case 10 (CMP)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b1010) && (Funct[0] == 1)) begin
            ALUControl <= 4'b0001;
            FlagW <= 2'b11;
            
        //case 11 (CMN) (may need fixing)
        end else if ((controls[0] == 1) && (Funct[4:1] == 4'b1011) && (Funct[0] == 1)) begin
            ALUControl <= 4'b0000;
            FlagW <= 2'b11;
            
        end         
 
 
    end

   /* controls = [branch
            , memtoreg
            , memw
            , alusrc
            , immsrc[0]
            , immsrc[1]
            , regW
            , regSrc[0]
            , regSrc[1]
            , ALUOP]
   */ 
/*    output PCS,
    output RegW,
    output MemW,
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output NoWrite,
*/    
    assign PCS = (controls[9]==1) ? 1 : ((Rd==15 & RegW) | controls[9]); 
    assign MemtoReg = controls[8];
    assign MemW = controls[7];
    assign ALUSrc = controls[6];
    assign ImmSrc = controls[5:4];
    assign RegW = controls[3];
    assign RegSrc = controls[2:1];
    assign NoWrite = ( 
    Funct[4:1] == 4'b1011 | 
    Funct[4:1] == 4'b1010 | 
    Funct[4:1] == 4'b1000 | 
    Funct[4:1] == 4'b1001) ? 1 : 0;
    
    
endmodule





