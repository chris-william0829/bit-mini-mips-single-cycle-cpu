//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/27 16:01:14
// Design Name: SignExt
// Module Name: SignExtension
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: extend the 16bits immediate number in the instruction to 32bits
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SignExtension(
    input[15:0] Imm16,
    input SignExtSignal,
    output[31:0] Imm32
    );
    //sign or zero
    assign Imm32 = (SignExtSignal) ? {{16{ Imm16[15] }},Imm16} : {16'd0,Imm16};
    
endmodule
