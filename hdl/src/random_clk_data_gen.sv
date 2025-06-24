`timescale 1ns / 1ps

module random_clk_data_gen #(
    parameter DATA_WIDTH = 8,
    parameter VALIDATION_COUNT = 3
    )(
    input  logic             clk,
    input  logic             rst_n,
    output logic [DATA_WIDTH-1:0] o_Output_Data
    );

    logic [DATA_WIDTH-1:0] l_Golden_Counter;
    logic [VALIDATION_COUNT-1:0] l_Local_Counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            l_Golden_Counter <= 0;
            l_Local_Counter <= 0;
        end 
        
        else begin
            if (l_Local_Counter == VALIDATION_COUNT) begin
                l_Golden_Counter <= l_Golden_Counter + 1;
                l_Local_Counter <= 0;
                if(l_Golden_Counter == VALIDATION_COUNT + 1)
                    l_Golden_Counter <= 0;
            end else begin
                l_Local_Counter <= l_Local_Counter + 1;
            end
        end
    end

    assign o_Output_Data = l_Golden_Counter;

endmodule