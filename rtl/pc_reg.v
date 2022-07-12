module pc_reg (
    input clk,
    input rst_n,

    input wire[31:0] jump_addr_i,
    input wire       jump_ena_i,
    output reg[31:0] pc_o
);
    always @(posedge clk ) begin
        if(!rst_n)
            pc_o <= 32'b0;
        else if(jump_ena_i)
            pc_o <= jump_addr_i;
        else
            pc_o <= pc_o + 32'd4;
    end

endmodule //pc_reg