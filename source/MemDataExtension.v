//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/27 17:01:10
// Design Name: MemDataExt
// Module Name: MemDataExtension
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: extend the data read from DM by the signal which sign the instructions
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MemDataExtension(
    input [31:0] ReadMemData,
    input [3:0] ReadMemExtSignal,
    output reg[31:0] MemDataExt
    );
    
    always @(*) begin
      case (ReadMemExtSignal)
        `U_DWORD: MemDataExt = ReadMemData;
        `U_WORD_LOW: MemDataExt = {16'b0,ReadMemData[15:0]};
        `U_WORD_HIGH: MemDataExt = {16'b0,ReadMemData[31:16]};
        `U_BYTE_LOWEST: MemDataExt = {24'b0,ReadMemData[7:0]};
        `U_BYTE_LOW: MemDataExt = {24'b0,ReadMemData[15:8]};
        `U_BYTE_HIGH: MemDataExt = {24'b0,ReadMemData[23:16]};
        `U_BYTE_HIGHEST: MemDataExt = {24'b0,ReadMemData[31:24]};
        `S_WORD_LOW: MemDataExt = {{16{ReadMemData[15]}},ReadMemData[15:0]};
        `S_WORD_HIGH: MemDataExt = {{16{ReadMemData[31]}},ReadMemData[31:16]};
        `S_BYTE_LOWEST: MemDataExt = {{24{ReadMemData[7]}},ReadMemData[7:0]};
        `S_BYTE_LOW: MemDataExt = {{24{ReadMemData[15]}},ReadMemData[15:8]};
        `S_BYTE_HIGH: MemDataExt = {{24{ReadMemData[23]}},ReadMemData[23:16]};
        `S_BYTE_HIGHEST: MemDataExt = {{24{ReadMemData[31]}},ReadMemData[31:24]};
        default: ;
      endcase  
    end
    
endmodule
