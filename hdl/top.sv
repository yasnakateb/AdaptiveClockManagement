`timescale 1ns / 1ps

module top #(
        parameter DATA_WIDTH = 8
    )(
        input  logic clk,
        input  logic rst_n
    );

    logic [DATA_WIDTH-1:0] l_Rand_Data;
    logic [DATA_WIDTH-1:0] l_Golden_Data;
    logic [DATA_WIDTH-1:0] l_Clk_Div;
    logic [DATA_WIDTH-1:0] l_Clk_Counter;
    logic l_Error_Flag;
    logic l_Done;
    logic l_Clk_Var;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            l_Clk_Counter <= 0;
            l_Clk_Var <= 1;
        end else if (l_Clk_Counter >= l_Clk_Div) begin
            l_Clk_Var <= ~l_Clk_Var;
            l_Clk_Counter <= 0;
        end else begin
            l_Clk_Counter <= l_Clk_Counter + 1;
        end
    end

    random_clk_data_gen Random_Clk_Data_Gen_Inst (
        .clk(l_Clk_Var),
        .rst_n(rst_n),
        .o_Output_Data(l_Rand_Data)
    );

    output_gen Output_Gen_Inst (
        .clk(clk),
        .rst_n(rst_n),
        .o_Output_Data(l_Golden_Data)
    );

    comparator Comparator_Inst (
        .i_Data_1(l_Rand_Data),
        .i_Data_2(l_Golden_Data),
        .o_Error_Flag(l_Error_Flag)
    );

    clock_manager Clock_Manager_Inst (
        .clk(clk),
        .rst_n(rst_n),
        .i_Error_Flag(l_Error_Flag),
        .o_Clk_Div(l_Clk_Div),
        .o_Done(l_Done)
    );

endmodule