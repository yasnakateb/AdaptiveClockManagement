`timescale 1ns / 1ps

module output_gen #(
    parameter DATA_WIDTH = 8,
    parameter VALIDATION_COUNT = 3
    )(
    input logic clk,
    input logic rst_n,
    output logic [DATA_WIDTH-1:0] o_Output_Data
    );

    logic [DATA_WIDTH-1:0] golden_counter;
    logic [VALIDATION_COUNT-1:0] local_counter;  

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            golden_counter <= 0;
            local_counter <= 0;
        end 
        
        else begin
            if (local_counter == VALIDATION_COUNT) begin
                golden_counter <= golden_counter + 1;
                local_counter <= 0;
                if(golden_counter == 4)
                    golden_counter <= 0;
            end else begin
                local_counter <= local_counter + 1;
            end 
        end
    end

    assign o_Output_Data = golden_counter;

endmodule
