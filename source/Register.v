//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/26 17:12:20
// Design Name: RF
// Module Name: Register
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description:32 general register files of mips.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Register(
    input clock,
    input reset,
    input RegWrite,
    input[4:0] ReadRegAddr1,
    input[4:0] ReadRegAddr2,
    input[4:0] WriteRegAddr,
    input[31:0] WriteRegData,
    input AluOverflowSignal,
    output reg[31:0] ReadRegData1,
    output reg[31:0] ReadRegData2
    );
    
    reg [31:0] Registers[31:0];
    //initialize
    integer i;
    always @(posedge clock,posedge reset) begin
      if(reset) begin
            for(i=0;i<32;i=i+1)
                Registers[i] <= `ZeroWord;
        end
        //write
        else
            if(RegWrite) begin
                Registers[WriteRegAddr] <= WriteRegData;
                $display("r[%2d] = 0x%8X,", WriteRegAddr, WriteRegData);
            end else ;
            end
    //read
    always @(*) begin
        if(ReadRegAddr1 == 5'h0) begin
            ReadRegData1 <= `ZeroWord;
        end else begin
            ReadRegData1 <= Registers[ReadRegAddr1];
        end
    end
    always @(*) begin
        if(ReadRegAddr2 == 5'h0) begin
            ReadRegData2 <= `ZeroWord;
        end else begin
            ReadRegData2 <= Registers[ReadRegAddr2];
        end
    end
    always @(posedge clock) begin
        $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, Registers[1], Registers[2], Registers[3], Registers[4], Registers[5], Registers[6], Registers[7]);
        $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", Registers[8], Registers[9], Registers[10], Registers[11], Registers[12], Registers[13], Registers[14], Registers[15]);
        $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", Registers[16], Registers[17], Registers[18], Registers[19], Registers[20], Registers[21], Registers[22], Registers[23]);
        $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", Registers[24], Registers[25], Registers[26], Registers[27], Registers[28], Registers[29], Registers[30], Registers[31]);
    end

endmodule
