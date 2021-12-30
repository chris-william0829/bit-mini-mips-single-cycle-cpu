//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/26 18:29:48
// Design Name: DM
// Module Name: DataMemory
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: Data Memory. store the data within the store(SW,SH,SB) Instructions and transmit data to CPU within the load(LW,LH,LB,LHU,LBU) instructions
//                           it also can be initialized by read the external file in module sopc
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMemory(
    input clock,
    input [8:2] MemDataAddr,        //address of data to store or read
    input [1:0] MemWrite,           //signal of whether to store the data
    input [31:0] WriteMemData,      //data to write in Memory
    input [2:0] WriteMemDataLength, //sign the datalength(word,half word,byte)
    output[31:0] ReadMemData        //data reading from Data Memory
    );
    
    reg[31:0] DataMem[127:0];
    always @(posedge clock) begin
        if(MemWrite != `NOW) begin
              case (WriteMemDataLength)
                  `DWORD: DataMem[MemDataAddr] = WriteMemData;
                  `WORD_LOW: DataMem[MemDataAddr] = {16'b0,WriteMemData[15:0]};     
                  `WORD_HIGH: DataMem[MemDataAddr] = {WriteMemData[15:0],16'b0};    
                  `BYTE_LOWEST: DataMem[MemDataAddr] = {24'b0,WriteMemData[7:0]};   
                  `BYTE_LOW: DataMem[MemDataAddr] ={16'b0, WriteMemData[7:0],8'b0}; 
                  `BYTE_HIGH: DataMem[MemDataAddr] ={8'b0, WriteMemData[7:0],16'b0};
                  `BYTE_HIGHEST: DataMem[MemDataAddr] = {WriteMemData[7:0],24'b0};  
                    default: DataMem[MemDataAddr] = `ZeroWord;
              endcase
              $display("dmem[0x%8X] = 0x%8X,", MemDataAddr << 2, WriteMemData); 
          end
      end
      assign ReadMemData = DataMem[MemDataAddr];
endmodule
