module rom (
    input [31:0] inst_addr_i,
    output [31:0] inst_o
);
    reg[31:0] rom_mem[0:4095];
    
    assign inst_o = rom_mem[inst_addr_i>>2];

endmodule //rom