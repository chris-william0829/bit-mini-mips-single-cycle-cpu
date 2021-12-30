//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/25 20:38:15
// Design Name: PC
// Module Name: PC
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: instruction's address
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clock,
    input reset,
    input [31:0] NextPC,
    output reg[31:0] PC
    );
    
    always @ (posedge clock,posedge reset)
        if(reset)
            PC <= 32'h00400000;
        else
            PC <= NextPC;
    
endmodule
