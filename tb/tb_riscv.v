`include "../tb/riscv_soc.v"
module tb_riscv (
    
);
    reg clk;
    reg rst_n;
	wire[31:0] x1  = tb_riscv.m_riscv_soc.top.m_regs.regs[1];
	wire[31:0] x2  = tb_riscv.m_riscv_soc.top.m_regs.regs[2];
    wire[31:0] x3  = tb_riscv.m_riscv_soc.top.m_regs.regs[3];
    wire[31:0] x26 = tb_riscv.m_riscv_soc.top.m_regs.regs[26];
    wire[31:0] x27 = tb_riscv.m_riscv_soc.top.m_regs.regs[27];
	wire[31:0] x29 = tb_riscv.m_riscv_soc.top.m_regs.regs[29];
	wire[31:0] x30 = tb_riscv.m_riscv_soc.top.m_regs.regs[30];

    initial begin
		$dumpfile("rsicv.vcd");              // 指定记录模拟波形的文件
        $dumpvars(0, tb_riscv);          // 指定记录的模块层级
        clk <= 'b0;
        rst_n <= 'b0;

        #30; 
        rst_n <= 'b1;
		#10000 $finish;
    end

    always #10 clk <= ~clk;
    
    //rom 初始值
	initial begin
        // 这里是16进制的读入，需要将readmemb改为readmemh
		// 读取测试文件
		$readmemh("../tb/inst_txt/rv32ui-p-srai.txt", tb_riscv.m_riscv_soc.m_rom.rom_mem);
		// $display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[0]);
		// $display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[1]);
		// $display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[2]);
	end

    
	// always@(posedge clk)begin
	// 	// $display("x27 register value is %d",tb_riscv_add.m_riscv_soc.m_rom.rom_mem[0]);
	// 	$display("x27 register value is %d",tb_riscv_add.m_riscv_soc.top.m_regs.regs[27]);
	// 	$display("x28 register value is %d",tb_riscv_add.m_riscv_soc.top.m_regs.regs[28]);
	// 	$display("x29 register value is %d",tb_riscv_add.m_riscv_soc.top.m_regs.regs[29]);
	// 	$display("---------------------------");
	// 	$display("---------------------------");
	// end
    integer r;
	initial begin
		wait(x26 == 32'b1);
		
		#200;
		if(x27 == 32'b1) begin
			$display("############################");
			$display("########  pass  !!!#########");
			$display("############################");
		end
		else begin
			$display("############################");
			$display("########  fail  !!!#########");
			$display("############################");
			$display("fail testnum = %2d", x3);
			for(r = 1;r < 32; r = r + 1)begin
				$display("x%2d register value is %d",r,tb_riscv.m_riscv_soc.top.m_regs.regs[r]);	
			end	
		end
	end
    
	

    riscv_soc m_riscv_soc(
		.clk   		(clk),
		.rst_n 		(rst_n)
	);
endmodule //tb_rsicv_add