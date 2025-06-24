`timescale 1ns / 1ps

module tb_top;

    logic clk;
    logic rst_n;

    top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;
    end

    initial begin
        $display("Time\t\t\t\tclk_div\tRand_Data\tGolden_Data\tError_Flag\tDone");
        $monitor("%0t\t\t\t\t%0d\t\t%0d\t\t%0d\t\t%b\t\t%b",
            $time,
            dut.l_Clk_Div,
            dut.l_Rand_Data,
            dut.l_Golden_Data,
            dut.l_Error_Flag,
            dut.l_Done
        );
    end

    initial begin
        #10000;
        $display("Simulation finished.");
        $finish;
    end

endmodule