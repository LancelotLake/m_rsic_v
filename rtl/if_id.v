`include "defines.v"
module if_id (
    input clk,
    input rst_n,

    input [31:0] inst_i,
    input [31:0] inst_addr_i,
    
    output reg [31:0] inst_o,
    output reg [31:0] inst_addr_o
);
  always @(posedge clk) begin
      if(!rst_n) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= 32'd0;
      end else begin
            inst_o <= inst_i;
            inst_addr_o <= inst_addr_i;
      end
  end

endmodule //if_id