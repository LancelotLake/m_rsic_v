module ctrl (
    // from ex
    input wire[31:0]    jump_addr_i,
    input wire          jump_ena_i,
    input wire          hold_flag_i,
    // to if_id, id_ex
    output wire[31:0]    jump_addr_o,
    output wire          jump_ena_o,
    output wire          hold_flag_o
);
    assign jump_addr_o = jump_addr_i;
    assign jump_ena_o = jump_ena_i;
    assign hold_flag_o = hold_flag_i | jump_ena_i;

endmodule //ctrl