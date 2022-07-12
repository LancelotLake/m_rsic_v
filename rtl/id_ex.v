module id_ex (
    input clk,
    input rst_n,
    // from id
    input [31:0]   inst_i,
    input [31:0]   inst_addr_i,
    input [31:0]   rs1_data_i,
    input [31:0]   rs2_data_i,
    input [4:0]    wd_addr_i,
    input wire     rd_wen_i,
    // from ctrl
    input wire     hold_flag_i,
    // to ex
    output reg [31:0]   inst_addr_o,
    output reg [31:0]   inst_o,
    output reg [31:0]   rs1_data_o,
    output reg [31:0]   rs2_data_o,
    output reg [4:0]    rd_addr_o,
    output reg          rd_wen_o
    
);
  always @(posedge clk) begin
      if(!rst_n || hold_flag_i) begin
            inst_addr_o     <= 32'b0;
            inst_o          <= `INST_NOP;
            rs1_data_o      <= 32'b0;
            rs2_data_o      <= 32'b0;
            rd_addr_o       <= 5'b0;
            rd_wen_o        <= 1'b0;
      end else begin
            inst_addr_o     <= inst_addr_i;
            inst_o          <= inst_i;
            rs1_data_o      <= rs1_data_i;
            rs2_data_o      <= rs2_data_i;
            rd_addr_o       <= wd_addr_i;
            rd_wen_o        <= rd_wen_i;          
      end  
  end
endmodule //id_ex