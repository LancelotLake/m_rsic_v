`include "defines.v"
module id (
    // from if_id
    input [31:0]    inst_addr_i,
    input [31:0]    inst_i,
    // to regs
    output reg[4:0]   rs1_addr_o,
    output reg[4:0]   rs2_addr_o,
    // from regs
    input [31:0]    rs1_data_i,
    input [31:0]    rs2_data_i,
    // to id_ex 
    output wire[31:0]   inst_addr_o,
    output wire[31:0]   inst_o,

    output reg[31:0]    op_1_o,
    output reg[31:0]    op_2_o,
    output reg[4:0]     wd_addr_o,
    output reg          reg_wen    
);
    assign inst_addr_o = inst_addr_i;
    assign inst_o = inst_i;
    
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] func7;
    assign {func7, rs2, rs1, func3, rd, opcode} = inst_i;

  always @(*) begin
      case(opcode) 
        // I型命令
         `INST_TYPE_I:begin
             case (func3)
                `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI: begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = 'b0;
                    op_1_o      = rs1_data_i;
                    op_2_o      = {{20{func7[6]}}, func7, rs2};
                    wd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end
                `INST_SLLI, `INST_SRI: begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = 'b0;
                    op_1_o      = rs1_data_i;
                    op_2_o      = {27'b0, rs2};
                    wd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end
                default: begin
                    rs1_addr_o  = 'b0;
                    rs2_addr_o  = 'b0;
                    op_1_o      = 32'b0;
                    op_2_o      = 32'b0;
                    wd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end
             endcase
         end
         // R型命令
         `INST_TYPE_R_M: begin
             case (func3)
                `INST_ADD_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = rs2;
                    op_1_o      = rs1_data_i;
                    op_2_o      = rs2_data_i;
                    wd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end   
                default: begin
                    rs1_addr_o  = 'b0;
                    rs2_addr_o  = 'b0;
                    op_1_o      = 32'b0;
                    op_2_o      = 32'b0;
                    wd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end 
             endcase
         end
         // B型指令
         `INST_TYPE_B: begin
            case(func3)
            // imm[12][10:5] | rs2 | rs1 | 001 | imm[4:1][11] | 1100011
                `INST_BNE, `INST_BEQ, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = rs2;
                    op_1_o      = rs1_data_i;
                    op_2_o      = rs2_data_i;
                    wd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end
                default: begin
                    rs1_addr_o  = 'b0;
                    rs2_addr_o  = 'b0;
                    op_1_o      = 32'b0;
                    op_2_o      = 32'b0;
                    wd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end
            endcase
         end
         `INST_LUI: begin
            rs1_addr_o  = 'b0;
            rs2_addr_o  = 'b0;
            op_1_o      = {inst_i[31:12],12'b0};
            op_2_o      = 32'b0;
            wd_addr_o   = rd;
            reg_wen     = 1'b1;
        end
         `INST_JAL: begin
            rs1_addr_o  = 'b0;
            rs2_addr_o  = 'b0;
            op_1_o      = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            op_2_o      = 32'b0;
            wd_addr_o   = rd;
            reg_wen     = 1'b1;
         end
          `INST_JALR: begin
            rs1_addr_o  = rs1;
            rs2_addr_o  = 'b0;
            op_1_o      = rs1_data_i;
            op_2_o      = {{20{func7[6]}}, func7, rs2};
            wd_addr_o   = rd;
            reg_wen     = 1'b1;
         end
         `INST_AUIPC: begin
            rs1_addr_o  = 'b0;
            rs2_addr_o  = 'b0;
            op_1_o      = {inst_i[31:12],12'b0};
            op_2_o      = 32'b0;
            wd_addr_o   = rd;
            reg_wen     = 1'b1;
         end
        default: begin
            rs1_addr_o  = 'b0;
            rs2_addr_o  = 'b0;
            op_1_o      = 32'b0;
            op_2_o      = 32'b0;
            wd_addr_o   = 5'b0;
            reg_wen     = 1'b0;
        end 
      endcase
  end
endmodule //id