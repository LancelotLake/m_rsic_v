`include "defines.v"
module ex (
    // from id_ex
    input [31:0]        inst_i,
    input [31:0]        inst_addr_i,
    input [31:0]  rs1_data_i,
    input [31:0]  rs2_data_i,
    input [4:0]         rd_addr_i,
    input wire          rd_wen_i,
    // to regs
    output reg[4:0]     rd_addr_o,
    output reg[31:0]    rd_data_o,
    output reg          rd_wen_o,
    //to ctrl
    output reg[31:0]    jump_addr_o,
    output reg          jump_ena_o,
    output reg          hold_flag_o
);
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] func7;

    wire op1_i_equal_op2_i;
    wire op1_i_less_than_op2_i_signed;
    wire op1_i_less_than_op2_i_unsigned;
    wire[31:0] jump_imm;

    assign {func7, rs2, rs1, func3, rd, opcode}   = inst_i;
    assign op1_i_equal_op2_i                      = (rs1_data_i == rs2_data_i);
    assign op1_i_less_than_op2_i_signed           = ($signed(rs1_data_i) < $signed(rs2_data_i));
    assign op1_i_less_than_op2_i_unsigned         = (rs1_data_i < rs2_data_i);
    assign jump_imm                               = {{20{func7[6]}}, rd[0], func7[5:0], rd[4:1], 1'b0};

  always @(*) begin
      case(opcode)
        `INST_TYPE_I: begin
            jump_addr_o = 32'b0;
            jump_ena_o  = 1'b0;
            hold_flag_o = 1'b0;
            case (func3)
                `INST_ADDI: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = rs1_data_i + rs2_data_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_SLTI: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = {31'b0, op1_i_less_than_op2_i_signed};
                    rd_wen_o = rd_wen_i;
                end
                `INST_SLTIU: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = {31'b0, op1_i_less_than_op2_i_unsigned};
                    rd_wen_o = rd_wen_i;
                end
                `INST_XORI: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = rs1_data_i ^ rs2_data_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_ORI: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = rs1_data_i | rs2_data_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_ANDI: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = rs1_data_i & rs2_data_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_SLLI: begin
                    rd_addr_o = rd_addr_i;
                    rd_data_o = rs1_data_i << rs2_data_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_SRI: begin
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                    if(func7[5] == 1'b1) begin
                        // 输入默认是unsigned，这里如果不转为signed，>>>将无法识别符号位，按照无符号数处理
                        rd_data_o = $signed(rs1_data_i)>>>rs2_data_i;
                    end else begin
                        rd_data_o = rs1_data_i>>rs2_data_i;
                    end
                end
                default: begin
                    rd_addr_o = 'b0;
                    rd_data_o = 'b0;
                    rd_wen_o = 'b0;
                end
            endcase
        end
        `INST_TYPE_R_M: begin
            jump_addr_o = 32'b0;
            jump_ena_o  = 1'b0;
            hold_flag_o = 1'b0;
            case (func3)
                `INST_ADD_SUB: begin
                    if(func7 == 7'b000_0000) begin
                        rd_data_o = rs1_data_i + rs2_data_i;
                        rd_addr_o = rd_addr_i;
                        rd_wen_o = rd_wen_i;
                    end
                    else if(func7 == 7'b010_0000) begin
                        rd_data_o = rs2_data_i - rs1_data_i;
                        rd_addr_o = rd_addr_i;
                        rd_wen_o = rd_wen_i;
                    end
                end 
                `INST_SLL: begin
                    rd_data_o = rs1_data_i << rs2_data_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_SLT: begin
                    rd_data_o = op1_i_less_than_op2_i_signed;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_SLTU: begin
                    rd_data_o = op1_i_less_than_op2_i_unsigned;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_XOR: begin
                    rd_data_o = rs2_data_i ^ rs1_data_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_SR: begin
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                    if(func7 == 7'b010_0000) begin
                        rd_data_o = $signed(rs1_data_i) >>> rs2_data_i;
                    end else begin
                        rd_data_o = rs1_data_i >> rs2_data_i;
                    end
                end
                `INST_OR: begin
                    rd_data_o = rs2_data_i | rs1_data_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                end
                `INST_AND: begin
                    rd_data_o = rs2_data_i & rs1_data_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = rd_wen_i;
                end
                default: begin
                    rd_addr_o = 'b0;
                    rd_data_o = 'b0;
                    rd_wen_o = 'b0;
                end
            endcase
        end 
        `INST_TYPE_B: begin
            rd_addr_o = 'b0;
            rd_data_o = 'b0;
            rd_wen_o = 'b0;
            case(func3) 
                `INST_BNE: begin
                    jump_addr_o = (inst_addr_i + jump_imm) & {32{~op1_i_equal_op2_i}};
                    jump_ena_o  = ~op1_i_equal_op2_i;
                    hold_flag_o = 1'b0;
                end
                `INST_BEQ: begin
                    jump_addr_o = (inst_addr_i + jump_imm) & {32{op1_i_equal_op2_i}};
                    jump_ena_o  = op1_i_equal_op2_i;
                    hold_flag_o = 1'b0;
                end
                default: begin
                    jump_addr_o = 32'b0;
                    jump_ena_o  = 1'b0;
                    hold_flag_o = 1'b0;
                end
            endcase
        end
        `INST_LUI: begin
            jump_addr_o = 32'b0;
            jump_ena_o  = 1'b0;
            hold_flag_o = 1'b0;

            rd_addr_o = rd_addr_i;
            rd_data_o = rs1_data_i;
            rd_wen_o = rd_wen_i;
        end
        `INST_JAL: begin
            jump_addr_o = rs1_data_i + inst_addr_i;
            jump_ena_o  = 1'b1;
            hold_flag_o = 1'b0;

            rd_addr_o = rd_addr_i;
            rd_data_o = inst_addr_i+32'h4;
            rd_wen_o = rd_wen_i;
        end
        default: begin
            jump_addr_o = 32'b0;
            jump_ena_o  = 1'b0;
            hold_flag_o = 1'b0;

            rd_addr_o = 'b0;
            rd_data_o = 'b0;
            rd_wen_o = 'b0;
        end
      endcase
  end
endmodule //ex