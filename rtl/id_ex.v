module id_ex (
    input clk,
    input rst_n,
    // from id
    input [31:0]   inst_i,
    input [31:0]   inst_addr_i,
    input [31:0]   rs1_data_i,
    input [31:0]   rs2_data_i,
    input [4:0]    wd_addr_i,
    input reg      reg_wen,

    // to ex
    output [31:0]   inst_addr_o,
    output [31:0]   inst_o,
    output [31:0]   rs1_data_o,
    output [31:0]   rs2_data_o,
    output [4:0]    rd_addr_o,
    output reg      rd_w_en
);
  always @(posedge clk) begin
      if(!rst_n) begin
            inst_addr_o     <= 32'b0;
            inst_o          <= 32'b0;
            rs1_data_o      <= 32'b0;
            rs2_data_o      <= 32'b0;
            rd_addr_o       <= 5'b0;
            rd_w_en         <= 1'b0;
      end else begin
            inst_addr_o     <= inst_addr_i;
            inst_o          <= inst_i;
            rs1_data_o      <= rs1_data_i;
            rs2_data_o      <= rs2_data_i;
            rd_addr_o       <= wd_addr_i;
            rd_w_en         <= reg_wen;          
      end  
  end
endmodule //id_ex