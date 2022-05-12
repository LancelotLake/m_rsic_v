`include "../tb/riscv_soc.v"
module tb_riscv_add (
    
);
    reg clk;
    reg rst_n;

    initial begin
		$dumpfile("rsicv_add.vcd");              // 指定记录模拟波形的文件
        $dumpvars(0, tb_riscv_add);          // 指定记录的模块层级
        clk <= 'b0;
        rst_n <= 'b0;

        #30; 
        rst_n <= 'b1;
		#200 $finish;
    end

    always #10 clk <= ~clk;

    //rom 初始值
	initial begin
		$readmemb("../tb/inst_data_ADD.txt", tb_riscv_add.m_riscv_soc.m_rom.rom_mem);
		$display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[0]);
		$display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[1]);
		$display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[2]);
	end

    
	always@(posedge clk)begin
		// $display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[0]);
		$display("x27 register value is %d",tb_riscv_add.m_riscv_soc.top.m_regs.regs[27]);
		$display("x28 register value is %d",tb_riscv_add.m_riscv_soc.top.m_regs.regs[28]);
		$display("x29 register value is %d",tb_riscv_add.m_riscv_soc.top.m_regs.regs[29]);
		$display("---------------------------");
		$display("---------------------------");
	end
		
	

    riscv_soc m_riscv_soc(
		.clk   		(clk),
		.rst_n 		(rst_n)
	);
endmodule //tb_rsicv_add