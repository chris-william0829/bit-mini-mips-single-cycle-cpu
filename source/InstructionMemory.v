//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     BIT
// Engineer:    Chris
// 
// Create Date: 2021/08/26 16:41:59
// Design Name: IM
// Module Name: InstructionMemory
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: read Instructions from external file and transmit to IF module within the corresponding PC
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory(
    input [8:2] InstAddr,               //PC, shift right 2 bits because one 32-bits instruction is 4bytes
    output [31:0] Instruction           //Instruction
    );
    
    reg [31:0] InstMem[127:0];          //Instruction Memory,2^7 = 128
    
    assign Instruction = InstMem[InstAddr];
    
endmodule
