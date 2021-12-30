//timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Chris
// 
// Create Date: 2021/08/25 20:52:46
// Design Name: CPU
// Module Name: CPU
// Project Name: single cycle mips cpu
// Target Devices: 
// Tool Versions: vivado 2019.2
// Description: all cpu modules' instantiation and data roads
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU(
    input clock,
    input reset,
    input [31:0] instruction,
    input [31:0] ReadMemData,     // data read from data memory
    output [31:0] InstAddress,               // instruction address
    output [31:0] AluResult,       // ALU operated result
    output [1:0]MemWrite,        // write memory or not
    output [31:0] WriteMemData,   // data write to data memory      //SB,SW data from rt
    output [2:0] WriteMemDataLength     //sign (SB,SH,SW)'s data length 
    );
    wire[2:0] MemRead;        // read Memory or not (lw,lh,lhu,lb,lbu)
    wire RegWrite;      //write register or not
    wire SignExt;    //extend sign or not
    wire [2:0] NextPCSignal;       //next instruction address op
    
    wire [1:0] WriteRegDataSignal;         //Mux4 signal to select what data write to register 
    wire [1:0] WriteRegSignal;          //Mux4 signal to select what register write to
    
    wire [31:0] NextInstAddress;        //next instruction address
    wire [4:0] RegDst;                  //(R-type instruction's destination register, rs+rt->rd)
    wire [4:0] RegTarget;               //R-type instruction's source register,I-type instruction's destination register rs+imm->rt
    wire [4:0] RegSource;               //source register
    wire [5:0] Opcode;                  //instruction's opcode
    wire [5:0] Func;                    //instruction's function
    wire [31:0] Shamt;                   //instruction's offest
    wire [15:0] Imm16;                  //16bits immediate number
    wire [31:0] Imm32;                  //imm16 extended 32-bits immediate number
    wire [25:0] JumpAddr;               //J-type instruction's jump address
    
    wire[4:0] WriteRegAddr;             //write to which Registers
    wire[31:0] WriteRegData;            //data write to registers
    
    wire[31:0] RegSourceData;               //register data specified by rs
    
    wire [4:0] AluOpcode;               //ALU OP
    wire[31:0] AluOperandA;                  //operand of ALU A
    wire[31:0] AluOperandB;                 //operand of ALU B
    wire AluSrcASignal;                 //Mux2 signal to select what data transimit to ALUSrcA
    wire AluSrcBSignal;                 //Mux2 signal to select what data transimit to ALUSrcB
    wire [1:0]AluZeroSignal;                 //ALU output Zero signal
    wire AluOverflowSignal;             //ALU output overflow signal
    
    wire[31:0] MemDataExt;                  //(lb,lbu,lh,lhu,lw) instruction's result Extend(ReadMemData) -> MemData
    wire[3:0] ReadMemExtSignal;             //control how to ext MemData
    
    wire RegimmSignal;      //bltzal,bgez,bgezal rt!=0 but should compare with zero
    
    assign RegDst = instruction[15:11];
    assign RegTarget = instruction[20:16];
    assign RegSource = instruction[25:21];
    assign Opcode = instruction[31:26];
    assign Func = instruction[5:0];
    assign Shamt = {27'b0,instruction[10:6]};
    assign Imm16 = instruction[15:0];
    assign JumpAddr = instruction[25:0];
    
    PC PC(
        .clock(clock),.reset(reset),
        .NextPC(NextInstAddress),       //Next Instruction's Address (from NextPC)
        .PC(InstAddress)                //Instruction's Address (transmit to IM)
    );
    NextPC NEXT_PC(
        .PC(InstAddress),               //Instruction's Address (From PC)
        .NextPCSignal(NextPCSignal),    //control which one is next pc
        .JumpAddr(JumpAddr),            //Branch's offset and j/jal's IMM
        .JumpReg(RegSourceData),        //JR / jalr's register data from rs
        .NextPC(NextInstAddress)        //Next Instruction's Address (transmit to PC)
    );
    Register RF(
        .clock(clock),.reset(reset),
        .RegWrite(RegWrite),                //write register or not
        .ReadRegAddr1(RegSource),           //read data1's address: rs      R-type
        .ReadRegAddr2(RegTarget),           //read data2's address: rt      R-type SB,SW
        .WriteRegAddr(WriteRegAddr),        //write to which Registers
        .WriteRegData(WriteRegData),        //data write to registers
        .AluOverflowSignal(AluOverflowSignal),      //alu result overflow signal        ADD,SUB
        .ReadRegData1(RegSourceData),               //Read Data1 rf[rs]
        .ReadRegData2(WriteMemData)                 //Read Data2  rd[rt]        SB,SW write to memory
    );
    
    //MUX2 #(32) ALU_A(.DataIn0(),.DataIn1(),.Signal(),.DataOut());
    MUX2 #(32) SRC_A(
        .DataIn0(RegSourceData),    //rs
        .DataIn1(Shamt),            //shamt,sll,srl
        .Signal(AluSrcASignal),
        .DataOut(AluOperandA)
    );
    MUX2 #(32) SRC_B(
        .DataIn0(WriteMemData),     //rt
        .DataIn1(Imm32),            //immediate number
        .Signal(AluSrcBSignal),
        .DataOut(AluOperandB)
    );
    ALU ALU(
        .AluOperandA(AluOperandA),
        .AluOperandB(AluOperandB),
        .AluOpcode(AluOpcode),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .AluResult(AluResult),
        .AluZeroSignal(AluZeroSignal),
        .AluOverflowSignal(AluOverflowSignal),
        .WriteMemDataLength(WriteMemDataLength),
        .ReadMemExtSignal(ReadMemExtSignal),
        .RegimmSignal(RegimmSignal)
    );
    
    MUX4 #(5) WR_REG_ADDR(      //mux that write to which register
        .DataIn0(RegDst),       //rd    R-type
        .DataIn1(RegTarget),    //rt    I-type
        .DataIn2(5'b11111),     //no.31 register is usually the J-Type's return Address
        .Signal(WriteRegSignal),
        .DataOut(WriteRegAddr)
    );
    
    MUX4 #(32) WR_REG_DATA(         //mux that write which data to register
        .DataIn0(AluResult),        //R-type's result store in the rd
        .DataIn1(MemDataExt),      //load instruction's data store in the rt
        .DataIn2(InstAddress + 4),  //jalr,jal,bltzal,bgezal
        .Signal(WriteRegDataSignal),
        .DataOut(WriteRegData)
    );
    
    SignExtension IMM_EXT(Imm16,SignExt,Imm32);
    MemDataExtension MEM_EXT(ReadMemData,ReadMemExtSignal,MemDataExt);
    
    ControlUnit CU(
        Opcode,                 //Instruction's opcode segment
        Func,                   //Instruction's function segment
        RegTarget,              //(bltz,bltzal...)instructions distinguished by this segment 
        AluZeroSignal,          //whether branch
        RegWrite,               //write register or not
        MemWrite,               // write memory or not
        SignExt,                //extend sign or not
        RegimmSignal,           //bltzal,bgez,bgezal rt!=0 but should compare with zero
        AluOpcode,              //ALU OP
        NextPCSignal,           //next instruction address op
        AluSrcASignal,          //Mux2 signal to select what data transimit to ALUSrcA
        AluSrcBSignal,          //Mux2 signal to select what data transimit to ALUSrcB
        WriteRegDataSignal,     //Mux4 signal to select what data write to register 
        WriteRegSignal,         //Mux4 signal to select what register write to
        MemRead                 // read Memory or not (lw,lh,lhu,lb,lbu)
    );
    
endmodule
