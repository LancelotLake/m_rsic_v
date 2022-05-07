module rom (
    input [31:0] inst_addr_i,
    output reg [31:0] inst_o
);
    reg[31:0] rom_mem[0:11];

    assign inst_o = rom_mem[inst_addr_i>>2];

endmodule //rom