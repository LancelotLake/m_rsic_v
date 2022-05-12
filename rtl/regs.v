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
    input [31:0] reg_wdata_i,
    input [4:0]  reg_waddr_i,
    input wire   reg_wen
    // to ex
);
    // regs
    reg[31:0] regs[0:31];
    integer i;
    // read from id
    always @(*) begin
        if(!rst_n) begin
            reg1_rdata_o = 32'b0;
            reg2_rdata_o = 32'b0;
        end  else begin

            if(reg1_raddr_i == 32'b0)
                reg1_rdata_o = 32'b0;
            else if(reg_wen && reg1_raddr_i == reg_waddr_i)
                reg1_rdata_o = reg_wdata_i;
            else
                reg1_rdata_o = regs[reg1_raddr_i];
                
            if(reg2_raddr_i == 32'b0)
                reg2_rdata_o = 32'b0;
            else if(reg_wen && reg2_raddr_i == reg_waddr_i)
                reg2_rdata_o = reg_wdata_i;
            else
                reg2_rdata_o = regs[reg2_raddr_i];
        end
    end

    // write from ex
    always @(posedge clk) begin
        if(!rst_n) begin
            for(i=0;i<32;i=i+1) begin
                regs[i] <= 32'b0;
            end
        end else begin
            if(reg_wen && reg_waddr_i != 5'b0) 
                regs[reg_waddr_i] <= reg_wdata_i;

        end
    end
endmodule //regs