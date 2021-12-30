`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/26 16:02:39
// Design Name: 
// Module Name: ControlSignalDefine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define ZeroWord 32'h00000000
//NextPCSignal
`define PC_PLUS4    3'b000
`define PC_BRANCH   3'b001
`define PC_IMM      3'b010
`define PC_REG      3'b011
`define PC_HALT     3'b100

//MemDataLength
`define DWORD   3'b001
`define WORD_LOW    3'b010
`define WORD_HIGH   3'b011
`define BYTE_LOWEST 3'b100
`define BYTE_LOW    3'b101
`define BYTE_HIGH   3'b110
`define BYTE_HIGHEST    3'b111

//AluOpcode
`define ALU_NOP   5'b00000 
`define ALU_ADDU   5'b00001
`define ALU_SUBU   5'b00010 
`define ALU_AND   5'b00011
`define ALU_OR    5'b00100
`define ALU_SLT   5'b00101
`define ALU_SLTU  5'b00110
`define ALU_NOR   5'b00111
`define ALU_SLL   5'b01000
`define ALU_SRL   5'b01001
`define ALU_SRA   5'b01010
`define ALU_SLLV  5'b01011
`define ALU_SRLV  5'b01100
`define ALU_LUI   5'b01101
`define ALU_XOR   5'b01111
`define ALU_SRAV  5'b10000
`define ALU_SUB 5'b10001
`define ALU_ADD 5'b10010


//MemRead
`define NOR 3'b000
`define LW 3'b011
`define LB 3'b101
`define LBU 3'b001
`define LH 3'b110
`define LHU 3'b010

//MemWrite
`define NOW 2'b00
`define SW 2'b11
`define SH 2'b10
`define SB 2'b01

//ReadMemExtSignal
`define U_DWORD   4'b0001
`define U_WORD_LOW    4'b0010
`define U_WORD_HIGH   4'b0011
`define U_BYTE_LOWEST 4'b0100
`define U_BYTE_LOW    4'b0101
`define U_BYTE_HIGH   4'b0110
`define U_BYTE_HIGHEST    4'b0111
`define S_WORD_LOW    4'b1000
`define S_WORD_HIGH   4'b1001
`define S_BYTE_LOWEST 4'b1010
`define S_BYTE_LOW    4'b1011
`define S_BYTE_HIGH   4'b1100
`define S_BYTE_HIGHEST    4'b1101

`define ADD_CONTROL      21'b100010010000000000000									
`define ADDU_CONTROL     21'b100000001000000000000									
`define AND_CONTROL      21'b100000011000000000000									
`define SUB_CONTROL      21'b100010001000000000000									
`define SUBU_CONTROL     21'b100000010000000000000									
`define OR_CONTROL       21'b100000100000000000000									
`define SLT_CONTROL      21'b100000101000000000000									
`define SLTU_CONTROL     21'b100100110000000000000									
`define JR_CONTROL       21'b000000000011000000000									
`define JALR_CONTROL     21'b100000000011001000000									
`define NOR_CONTROL      21'b100000111000000000000									
`define SLL_CONTROL      21'b100001000000100000000																	
`define SRL_CONTROL      21'b100001001000100000000									
`define SRA_CONTROL      21'b100001010000100000000									
`define SRAV_CONTROL     21'b100010000000000000000									
`define SRLV_CONTROL     21'b100001100000000000000									
`define XOR_CONTROL      21'b100001111000000000000									
`define SLLV_CONTROL     21'b100001011000000000000									
`define ADDI_CONTROL     21'b100110010000010001000									
`define ORI_CONTROL      21'b100000100000010001000									
`define LW_CONTROL       21'b100100001000010101011									
`define SW_CONTROL       21'b011100001000010000000									
`define BEQ_CONTROL      21'b000000010001000000000									
`define BGTZ_CONTROL     21'b000000010001000000000									
`define BLEZ_CONTROL     21'b000000010001000000000									
`define BNE_CONTROL      21'b000000010001000000000																											
`define SLTI_CONTROL     21'b100100101000010001000									
`define LUI_CONTROL      21'b100001101000010001000									
`define ANDI_CONTROL     21'b100000011000010001000									
`define LB_CONTROL       21'b100100001000010101101									
`define LBU_CONTROL      21'b100100001000010101001									
`define LH_CONTROL       21'b100100001000010101110									
`define LHU_CONTROL      21'b100100001000010101010									
`define SB_CONTROL       21'b001100001000010000000									
`define SH_CONTROL       21'b010100001000010000000									
`define J_CONTROL        21'b000000000010000000000									
`define JAL_CONTROL      21'b100000000010001010000									
`define BLTZ_CONTROL     21'b000000010001000000000									
`define BLTZAL_CONTROL   21'b100000010001001010000									
`define BGEZ_CONTROL     21'b000000010001000000000									
`define BGEZAL_CONTROL   21'b100000010001001010000
`define ADDIU_CONTROL    21'b100100001000010001000									

`define ADDI_OP  6'b001000
`define ORI_OP   6'b001101
`define LW_OP    6'b100011
`define SW_OP    6'b101011
`define BEQ_OP   6'b000100
`define BGTZ_OP  6'b000111
`define BLEZ_OP  6'b000110
`define BNE_OP   6'b000101
`define SLTI_OP  6'b001010
`define LUI_OP   6'b001111
`define ANDI_OP  6'b001100
`define LB_OP    6'b100000
`define LBU_OP   6'b100100
`define LH_OP    6'b100001
`define LHU_OP   6'b100101
`define SB_OP    6'b101000
`define SH_OP    6'b101001
`define J_OP     6'b000010
`define JAL_OP   6'b000011
`define SPECIAL  6'b000000
`define REGMIN   6'b000001
`define ADDIU_OP 6'b001001


`define ADD_FUNC 6'b100000
`define ADDU_FUNC 6'b100001
`define AND_FUNC 6'b100100
`define SUB_FUNC 6'b100010
`define SUBU_FUNC 6'b100011
`define OR_FUNC 6'b100101
`define SLT_FUNC 6'b101010
`define SLTU_FUNC 6'b101011
`define JR_FUNC 6'b001000
`define JALR_FUNC 6'b001001
`define NOR_FUNC 6'b100111
`define SLL_FUNC 6'b000000
`define SRL_FUNC 6'b000010
`define SRA_FUNC 6'b000011
`define SRAV_FUNC 6'b000111
`define SRLV_FUNC 6'b000110
`define XOR_FUNC 6'b100110
`define SLLV_FUNC 6'b000100

`define BLTZ     5'b00000
`define BLTZAL   5'b10000
`define BGEZ     5'b00001
`define BGEZAL   5'b10001
