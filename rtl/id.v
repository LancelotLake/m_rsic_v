`include "define.v"
module id (
    // from if_id
    input [31:0]    inst_addr_i,
    input [31:0]    inst_i,
    // to regs
    output [31:0]   rs1_addr_o,
    output [31:0]   rs2_addr_o,
    // from regs
    input [31:0]    rs1_data_i,
    input [31:0]    rs2_data_i,
    // to id_ex 
    output [31:0]   inst_addr_o,
    output [31:0]   inst_o,
    output [31:0]   op_1_o,
    output [31:0]   op_2_o,
    output [4:0]    wd_addr_o,
    output reg      reg_wen    
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
                `INST_ADDI: begin
                    op_1_o      = rs1_data_i;
                    op_2_o      = {{20{func7[6]}}, func7, rs2};
                    wd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end
                default: begin
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
                `INST_ADD_SUB: begin
                    op_1_o      = rs1_data_i;
                    op_2_o      = rs2_data_i;
                    wd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end  
                default: begin
                    op_1_o      = 32'b0;
                    op_2_o      = 32'b0;
                    wd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end 
             endcase
         end
        default: begin
            op_1_o      = 32'b0;
            op_2_o      = 32'b0;
            wd_addr_o   = 5'b0;
            reg_wen     = 1'b0;
        end 
      endcase
  end
endmodule //id