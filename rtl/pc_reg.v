module pc_reg (
    input clk,
    input rst_n,
    output reg[31:0] pc_o
);
    always @(posedge clk ) begin
        if(!rst_n)
            pc_o <= 32'b0;
        else
            pc_o <= pc_o + 32'd4;
    end

endmodule //pc_reg