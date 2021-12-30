//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/27 17:26:46
// Design Name: CU
// Module Name: ControlUnit
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: instruction decode module.Generate all the control signal here within the decoded instructions
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit(                                   //Instruction's opcode segment                                
    input [5:0] Opcode,                               //Instruction's function segment                              
    input [5:0] Func,                                 //(bltz,bltzal...)instructions distinguished by this segment  
    input [4:0] Branch,                               //whether branch                                              
    input [1:0]AluZeroSignal,                         //write register or not                                       
    output reg RegWrite,                              // write memory or not                                        
    output reg [1:0] MemWrite,                        //extend sign or not                                          
    output reg SignExt,                               //bltzal,bgez,bgezal rt!=0 but should compare with zero       
    output reg RegimmSignal,                          //ALU OP                                                      
    output reg [4:0] AluOpcode,                       //next instruction address op                                 
    output reg [2:0] NextPCSignal,                    //Mux2 signal to select what data transimit to ALUSrcA        
    output reg AluSrcASignal,                         //Mux2 signal to select what data transimit to ALUSrcB        
    output reg AluSrcBSignal,                         //Mux4 signal to select what data write to register           
    output reg [1:0] WriteRegDataSignal,              //Mux4 signal to select what register write to                
    output reg [1:0] WriteRegSignal,                  // read Memory or not (lw,lh,lhu,lb,lbu)                      
    output reg [2:0] MemRead                          // read Memory or not (lw,lh,lhu,lb,lbu)                      
    );
    
    reg [20:0] ControlSignal;
    reg JumpSignal;
    always @(*) begin 
        case (Opcode)
          `SPECIAL: begin
            RegimmSignal=1'b0;
            case (Func)
                `ADD_FUNC: ControlSignal =   `ADD_CONTROL ;
                `ADDU_FUNC: ControlSignal =  `ADDU_CONTROL;
                `AND_FUNC: ControlSignal =   `AND_CONTROL ;
                `SUB_FUNC: ControlSignal =   `SUB_CONTROL ;
                `SUBU_FUNC: ControlSignal =  `SUBU_CONTROL;
                `OR_FUNC: ControlSignal =    `OR_CONTROL;
                `SLT_FUNC: ControlSignal =   `SLT_CONTROL ;
                `SLTU_FUNC: ControlSignal =  `SLTU_CONTROL;
                `JR_FUNC: begin ControlSignal =    `JR_CONTROL ; JumpSignal = 1'b1; end
                `JALR_FUNC: begin ControlSignal =  `JALR_CONTROL; JumpSignal = 1'b1; end
                `NOR_FUNC: ControlSignal =   `NOR_CONTROL ;
                `SLL_FUNC: ControlSignal =   `SLL_CONTROL ;
                `SRL_FUNC: ControlSignal =   `SRL_CONTROL ;
                `SRA_FUNC: ControlSignal =   `SRA_CONTROL ;
                `SRAV_FUNC: ControlSignal =  `SRAV_CONTROL;
                `SRLV_FUNC: ControlSignal =  `SRLV_CONTROL;
                `XOR_FUNC: ControlSignal =   `XOR_CONTROL ;
                `SLLV_FUNC: ControlSignal =  `SLLV_CONTROL;
                default: ;
            endcase
          end
          `ADDI_OP:  begin  ControlSignal = `ADDI_CONTROL;RegimmSignal=1'b0; end
          `ORI_OP :  begin  ControlSignal = `ORI_CONTROL ; RegimmSignal=1'b0; end
          `LW_OP  :  begin  ControlSignal = `LW_CONTROL  ;      RegimmSignal=1'b0; end
          `ADDIU_OP: begin   ControlSignal = `ADDIU_CONTROL;    RegimmSignal=1'b0; end
          `SW_OP  :  begin  ControlSignal = `SW_CONTROL  ;      RegimmSignal=1'b0; end
          `BEQ_OP :  begin  ControlSignal = `BEQ_CONTROL ; if(AluZeroSignal == 2'b00) JumpSignal = 1'b1; else JumpSignal = 1'b0;end
          `BGTZ_OP:  begin  ControlSignal = `BGTZ_CONTROL; if(AluZeroSignal == 2'b01) JumpSignal = 1'b1;else JumpSignal = 1'b0; end
          `BLEZ_OP:  begin  ControlSignal = `BLEZ_CONTROL; if(AluZeroSignal != 2'b01) JumpSignal = 1'b1; else JumpSignal = 1'b0;end
          `BNE_OP :  begin  ControlSignal = `BNE_CONTROL ; if(AluZeroSignal != 2'b00) JumpSignal = 1'b1;  else JumpSignal = 1'b0; end
          `SLTI_OP: begin   ControlSignal = `SLTI_CONTROL;   RegimmSignal=1'b0; end
          `LUI_OP : begin   ControlSignal = `LUI_CONTROL ;   RegimmSignal=1'b0; end
          `ANDI_OP: begin   ControlSignal = `ANDI_CONTROL;   RegimmSignal=1'b0; end
          `LB_OP  : begin   ControlSignal = `LB_CONTROL  ;   RegimmSignal=1'b0; end
          `LBU_OP : begin   ControlSignal = `LBU_CONTROL ;   RegimmSignal=1'b0; end
          `LH_OP  : begin   ControlSignal = `LH_CONTROL  ;   RegimmSignal=1'b0; end
          `LHU_OP : begin   ControlSignal = `LHU_CONTROL ;   RegimmSignal=1'b0; end
          `SB_OP  : begin   ControlSignal = `SB_CONTROL  ;   RegimmSignal=1'b0; end
          `SH_OP  : begin   ControlSignal = `SH_CONTROL  ;   RegimmSignal=1'b0; end
          `J_OP   :  begin  ControlSignal = `J_CONTROL; JumpSignal = 1'b1; end  
          `JAL_OP :  begin  ControlSignal = `JAL_CONTROL ;  JumpSignal = 1'b1; end
          `REGMIN : begin
            case (Branch)
                `BLTZ  : begin ControlSignal = `BLTZ_CONTROL  ;RegimmSignal=1'b1; if(AluZeroSignal == 2'b10) JumpSignal = 1'b1; else JumpSignal = 1'b0; end
                `BLTZAL: begin ControlSignal = `BLTZAL_CONTROL;RegimmSignal=1'b1; if(AluZeroSignal == 2'b10) JumpSignal = 1'b1; else JumpSignal = 1'b0; end
                `BGEZ  : begin ControlSignal = `BGEZ_CONTROL  ;RegimmSignal=1'b1; if(AluZeroSignal != 2'b10) JumpSignal = 1'b1; else JumpSignal = 1'b0; end
                `BGEZAL: begin ControlSignal = `BGEZAL_CONTROL;RegimmSignal=1'b1; if(AluZeroSignal != 2'b10) JumpSignal = 1'b1; else JumpSignal = 1'b0; end
              default: ;
            endcase
          end
          default: ;
        endcase
    end
    
    always @(*) begin
        RegWrite = ControlSignal[20];
        MemWrite = ControlSignal[19:18];
        SignExt = ControlSignal[17];
        AluOpcode = ControlSignal[16:12];
        if(ControlSignal[11:9] == 3'b001) begin
            if(JumpSignal != 1'b1) begin
                NextPCSignal <= 3'b000;
            end else begin
                NextPCSignal = ControlSignal[11:9];
            end
        end else begin
            NextPCSignal = ControlSignal[11:9];
        end
        AluSrcASignal = ControlSignal[8];
        AluSrcBSignal = ControlSignal[7];
        WriteRegDataSignal = ControlSignal[6:5];
        WriteRegSignal = ControlSignal[4:3];
        MemRead = ControlSignal[2:0];
    end
    
endmodule
