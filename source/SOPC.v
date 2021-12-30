//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/26 16:48:59
// Design Name: SOPC
// Module Name: SOPC
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: System level programmable chip (harvard architecture)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SOPC(
    input clock,
    input rstn
    );
    
    wire[31:0] Instruction;     //IM transmit to CPU
    wire[31:0] PC;              //CPU transmit to IM
    wire[1:0] MemWrite;        // write memory or not
    wire[31:0]MemDataAddr;      //Address write to DataMem
    wire[31:0] WriteMemData;     //Data write to DaraMem
    wire[31:0] ReadMemData;     // data read from data memory
    wire[2:0] WriteMemDataLength;       //sign (SB,SH,SW)'s data length 
    wire rst = ~rstn;
    
    //IM
    InstructionMemory IM(PC[8:2],Instruction);
    //CPU
    CPU SINGLE_CYCLE_CPU(
        .clock(clock),.reset(rst),
        .instruction(Instruction),      //IM transmit to CPU
        .ReadMemData(ReadMemData),      //data read from data memory   load instructions
        .InstAddress(PC),               //instruction's Address
        .AluResult(MemDataAddr),        //load instructions Mem Address = alu result
        .MemWrite(MemWrite),            //signal write memory or not
        .WriteMemData(WriteMemData),    //Data write to DaraMem     SB,SW
        .WriteMemDataLength(WriteMemDataLength)     //signal (SB,SH,SW)'s data length 
    );
    //DM
    DataMemory DM(clock,MemDataAddr[8:2],MemWrite,WriteMemData,WriteMemDataLength,ReadMemData);
    
endmodule
