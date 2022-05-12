`include "../rtl/riscv_top.v"
`include "../rtl/rom.v"

module riscv_soc (
    input wire clk,
    input wire rst_n
);
    // rsic to rom
    wire [31:0] inst_addr;
    // rom to rsic
    wire [31:0] inst;
    // rsicv
    riscv_top top(
        .clk            (clk),
        .rst_n          (rst_n),
        .inst_i         (inst),
        .inst_addr_o    (inst_addr)
    );
    // rom
    rom m_rom(
        .inst_addr_i    (inst_addr),
        .inst_o         (inst)
    );
endmodule //riscv_soc