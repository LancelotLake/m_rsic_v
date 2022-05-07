module regs (
    input clk,
    input rst_n,
    // from id
    input [4:0] reg1_raddr_i,
    input [4:0] reg2_raddr_i,
    // to id
    output reg [31:0] reg1_rdata_o,
    output reg [31:0] reg2_rdata_o,
    // from ex
    // to ex
);
    // regs
    reg[31:0] regs[0:31];
    
    // read from id
    always @(*) begin
        if(!rst_n) begin
            reg1_rdata_o <= 32'b0;
            reg2_rdata_o <= 32'b0;
        end  else begin

            if(reg1_raddr_i == 32'b0)
                reg1_rdata_o <= 32'b0
            else
                reg1_rdata_o <= regs[reg1_raddr_i];
                
            if(reg2_raddr_i == 32'b0)
                reg2_rdata_o <= 32'b0
            else
                reg2_rdata_o <= regs[reg2_raddr_i];
        end
    end

    // write from ex

endmodule //regs