//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/26 19:14:56
// Design Name: ALU
// Module Name: ALU
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: alu of the cpu
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input signed [31:0] AluOperandA,        //operand A: from the srcA mux
    input signed [31:0] AluOperandB,        
    input [4:0] AluOpcode,                  //opcode from the control unit,instruction decode
    input [2:0]MemRead,                     //signal
    input [1:0]MemWrite,                    //signal
    input RegimmSignal,                     //signal of OperandB, because the (blez,blezal...) instructions operand is zero,but i didn't consider this at the beginning,so i add this signal here,you can modify it in the mux srcB module
    output reg signed [31:0] AluResult,     //result
    output reg [1:0] AluZeroSignal,         //branch instruction judgement
    output reg AluOverflowSignal,           //overflow signal, it only sign the result overflow but do nothing
    output reg[2:0] WriteMemDataLength,     //sign the datalength(word,half word,byte)
    output reg[3:0] ReadMemExtSignal        //sign the data read from DM how to extend (zero/sign)
    );
    
   wire signed[31:0] OperandB;
    assign OperandB = (RegimmSignal == 1'b1) ? `ZeroWord : AluOperandB;
   always @(*) begin
        case (AluOpcode)
           `ALU_NOP: AluResult = AluOperandA;
           `ALU_ADD: AluResult = AluOperandA + AluOperandB;
           `ALU_SUB: AluResult = AluOperandA - AluOperandB;
           `ALU_ADDU: AluResult = AluOperandA + AluOperandB;
           `ALU_SUBU: AluResult = AluOperandA - OperandB;
           `ALU_AND: AluResult = AluOperandA & AluOperandB;
           `ALU_OR: AluResult = AluOperandA | AluOperandB;
           `ALU_SLT: AluResult = (AluOperandA < AluOperandB) ? 32'd1 : 32'd0;
           `ALU_SLTU: AluResult = ({1'b0, AluOperandA} < {1'b0, AluOperandB}) ? 32'd1 : 32'd0;
           `ALU_NOR: AluResult = ~(AluOperandA | AluOperandB);
           `ALU_SLL: AluResult = AluOperandB << AluOperandA;
           `ALU_SRL: AluResult = AluOperandB >> AluOperandA;
           `ALU_SRA: AluResult = AluOperandB >>> AluOperandA;
           `ALU_SLLV: AluResult = AluOperandB << (AluOperandA[4:0]);
           `ALU_SRLV: AluResult = AluOperandB >> (AluOperandA[4:0]);
           `ALU_LUI: AluResult = AluOperandB << 16;
           `ALU_XOR: AluResult = AluOperandB ^ AluOperandA;
           `ALU_SRAV: AluResult = AluOperandB >>> (AluOperandA[4:0]);
           default: AluResult = AluOperandA;
        endcase
    end
    always @(*) begin
        if(AluResult == 0) begin
            AluZeroSignal <= 2'b00;
        end else if(AluResult > 0) begin
            AluZeroSignal <= 2'b01;
        end else if(AluResult < 0) begin
            AluZeroSignal <= 2'b10;
        end else ;
    end
    
    //still have some bug
    always @(*) begin
        if((AluOpcode == `ALU_ADD) || (AluOpcode == `ALU_SUB)) begin
            if(((AluOperandA[31] == 1'b1) && (AluOperandB[31] == 1'b1) &&(AluResult[31] == 1'b0))||((AluOperandA[31] == 1'b0) && (AluOperandB[31] == 1'b0) &&(AluResult[31] == 1'b1))) begin
                AluOverflowSignal <= 1'b1;
            end else begin
                AluOverflowSignal <= 1'b0;
            end
        end else begin
            AluOverflowSignal <= 1'b0;
        end
    end
    
    always @(*) begin
        if(MemRead == `LW) begin
            ReadMemExtSignal = `U_DWORD;
        end else if(MemRead == `LH) begin
            if(AluResult[1]) begin
                ReadMemExtSignal = `S_WORD_HIGH;
            end else begin
                ReadMemExtSignal = `S_WORD_LOW;
            end
        end else if(MemRead == `LHU) begin
            if(AluResult[1]) begin
                ReadMemExtSignal = `U_WORD_HIGH;
            end else begin
                ReadMemExtSignal = `U_WORD_LOW;
            end
        end else if(MemRead == `LB) begin
            case(AluResult[1:0])
                2'b00: ReadMemExtSignal = `S_BYTE_LOWEST;
                2'b01: ReadMemExtSignal = `S_BYTE_LOW;
                2'b10: ReadMemExtSignal = `S_BYTE_HIGH;
                2'b11: ReadMemExtSignal = `S_BYTE_HIGHEST;
            endcase
        end else if(MemRead == `LBU) begin
            case(AluResult[1:0])
                2'b00: ReadMemExtSignal = `U_BYTE_LOWEST;
                2'b01: ReadMemExtSignal = `U_BYTE_LOW;
                2'b10: ReadMemExtSignal = `U_BYTE_HIGH;
                2'b11: ReadMemExtSignal = `U_BYTE_HIGHEST;
            endcase
        end else ;
    end
    
    always @(*) begin
        case (MemWrite)
          `SW: WriteMemDataLength = `DWORD;
          `SH: begin
            if(AluResult[1]) begin
              WriteMemDataLength = `WORD_HIGH;
            end else begin
              WriteMemDataLength = `WORD_LOW;
            end
          end
          `SB: begin
            case (AluResult[1:0])
              2'b00: WriteMemDataLength = `BYTE_LOWEST;
              2'b01: WriteMemDataLength = `BYTE_LOW;
              2'b10: WriteMemDataLength = `BYTE_HIGH;
              2'b11: WriteMemDataLength = `BYTE_HIGHEST; 
              default: ;
            endcase
          end 
          default: ;
        endcase
    end
    
endmodule
