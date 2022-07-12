`include "pc_reg.v"
`include "ifeach.v"
`include "if_id.v"
`include "id.v"
`include "id_ex.v"
`include "ex.v"
`include "regs.v"
`include "ctrl.v"

module riscv_top (
    input           clk,
    input           rst_n,
    // from rom
    input [31:0]    inst_i,
    // to rom
    output[31:0]    inst_addr_o
);
    // pc to if
    wire [31:0]     pc_io;
    // if to if_id
    wire [31:0]     if_inst_addr;
    wire [31:0]     if_inst;
    // if_id to id
    wire [31:0]     if_id_inst_addr;
    wire [31:0]     if_id_inst;
    // id to regs
    wire [4:0]      id_rs1_addr;
    wire [4:0]      id_rs2_addr;
    // regs to id
    wire [31:0]     regs_rs1_data;
    wire [31:0]     regs_rs2_data;
    // id to id_ex
    wire [31:0]     id_inst_addr;
    wire [31:0]     id_inst;
    wire [31:0]     id_op_1;
    wire [31:0]     id_op_2;
    wire [4:0]      id_wd_addr;
    wire            id_reg_wen;  
    // id_ex to ex
    wire [31:0]     id_ex_inst_addr;
    wire [31:0]     id_ex_inst;
    wire [31:0]     id_ex_rs1_data;
    wire [31:0]     id_ex_rs2_data;
    wire [4:0]      id_ex_rd_addr;
    wire            id_ex_rd_wen;    
    // ex to regs
    wire [4:0]      ex_rd_addr;
    wire [31:0]     ex_rd_data;
    wire            ex_rd_wen;
    // ex to ctrl
    wire [31:0]     ex_jump_addr;
    wire            ex_jump_ena;
    wire            ex_hold_flag;
    // ctrl to if_id, id_ex, pc
    wire [31:0]     ctrl_jump_addr;
    wire            ctrl_jump_ena;
    wire            ctrl_hold_flag;
    // pc_reg
    pc_reg m_pc_reg(
        .clk            (clk),
        .rst_n          (rst_n),
        .jump_addr_i    (ctrl_jump_addr),
        .jump_ena_i     (ctrl_jump_ena),        
        .pc_o           (pc_io)
    );
    // if
    ifeach m_ifeach(
        .pc_addr_i      (pc_io),
        .rom_inst_i     (inst_i),
        .if_rom_addr_o  (inst_addr_o),
        .inst_addr_o    (if_inst_addr),
        .inst_o         (if_inst)
    );
    // if_id
    if_id m_if_id(
        .clk            (clk),
        .rst_n          (rst_n),

        .hold_flag_i    (ctrl_hold_flag),
        .inst_i         (if_inst),
        .inst_addr_i    (if_inst_addr),

        .inst_o         (if_id_inst),
        .inst_addr_o    (if_id_inst_addr)
    );
    // id
    id m_id (
        .inst_addr_i    (if_id_inst_addr),
        .inst_i         (if_id_inst),

        .rs1_addr_o     (id_rs1_addr),
        .rs2_addr_o     (id_rs2_addr),

        .rs1_data_i     (regs_rs1_data),
        .rs2_data_i     (regs_rs2_data),

        .inst_addr_o    (id_inst_addr),
        .inst_o         (id_inst),
        .op_1_o         (id_op_1),
        .op_2_o         (id_op_2),
        .wd_addr_o      (id_wd_addr),
        .reg_wen        (id_reg_wen) 
    );    
    // regs
    regs m_regs(
        .clk            (clk),
        .rst_n          (rst_n),

        .reg1_raddr_i   (id_rs1_addr),
        .reg2_raddr_i   (id_rs2_addr),

        .reg1_rdata_o   (regs_rs1_data),
        .reg2_rdata_o   (regs_rs2_data),

        .reg_wdata_i    (ex_rd_data),
        .reg_waddr_i    (ex_rd_addr),
        .reg_wen        (ex_rd_wen)
    );
    // id_ex
    id_ex m_id_ex(
        .clk            (clk),
        .rst_n          (rst_n),

        .hold_flag_i    (ctrl_hold_flag),
        .inst_i         (id_inst),
        .inst_addr_i    (id_inst_addr),
        .rs1_data_i     (id_op_1),
        .rs2_data_i     (id_op_2),
        .wd_addr_i      (id_wd_addr),
        .rd_wen_i       (id_reg_wen),

        .inst_addr_o    (id_ex_inst_addr),
        .inst_o         (id_ex_inst),
        .rs1_data_o     (id_ex_rs1_data),
        .rs2_data_o     (id_ex_rs2_data),
        .rd_addr_o      (id_ex_rd_addr),
        .rd_wen_o       (id_ex_rd_wen)
 
    );
    // ex
    ex m_ex(
        .inst_i         (id_ex_inst),
        .inst_addr_i    (id_ex_inst_addr),
        .rs1_data_i     (id_ex_rs1_data),
        .rs2_data_i     (id_ex_rs2_data),
        .rd_addr_i      (id_ex_rd_addr),
        .rd_wen_i       (id_ex_rd_wen),
        
        .rd_addr_o      (ex_rd_addr),
        .rd_data_o      (ex_rd_data),
        .rd_wen_o       (ex_rd_wen),
        
        .jump_addr_o    (ex_jump_addr),
        .jump_ena_o     (ex_jump_ena),
        .hold_flag_o    (ex_hold_flag)
    );
    // ctrl
    ctrl m_ctrl(
        .jump_addr_i    (ex_jump_addr),
        .jump_ena_i     (ex_jump_ena),
        .hold_flag_i    (ex_hold_flag),
        .jump_addr_o    (ctrl_jump_addr),
        .jump_ena_o     (ctrl_jump_ena),
        .hold_flag_o    (ctrl_hold_flag)
    );


endmodule //riscv_top