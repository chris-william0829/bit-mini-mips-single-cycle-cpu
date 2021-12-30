//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/27 14:20:28
// Design Name: MUX4
// Module Name: MUX4
// Project Name: Single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: select data by the signal
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//because we only select from 3 data,so i delete one input
module MUX4 #(parameter bits = 4)(
    input [bits-1:0] DataIn0,
    input [bits-1:0] DataIn1,
    input [bits-1:0] DataIn2,
    input [1:0] Signal,
    output reg[bits-1:0] DataOut
    );
    
    always @(*) begin
        case (Signal)
            2'b00: DataOut <= DataIn0;
            2'b01: DataOut <= DataIn1;
            2'b10: DataOut <= DataIn2;
            default: ;
        endcase
    end
    
endmodule
