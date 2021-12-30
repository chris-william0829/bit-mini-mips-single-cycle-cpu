//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/27 20:29:08
// Design Name: 
// Module Name: sopc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: test bench
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sopc_tb(

    );
    
    reg clk,rstn;
    SOPC SOPC(clk,rstn);
   
    initial begin
     $readmemh( "C:/CPU/singel-cycle-mips-cpu/test/1.dat" , SOPC.IM.InstMem); // load instructions into instruction memory
      $monitor("PC = 0x%8X, instr = 0x%8X", SOPC.PC, SOPC.Instruction); 
 
      clk = 1;
      rstn = 1;
      #5 ;
      rstn = 0;
      #20 ;
      rstn = 1;
       end
   
    always
    #(50) clk = ~clk;
	   

endmodule
