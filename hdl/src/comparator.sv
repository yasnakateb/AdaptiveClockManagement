`timescale 1ns / 1ps

module comparator #(
    parameter DATA_WIDTH = 8
    )(
    input logic [DATA_WIDTH-1:0] i_Data_1,
    input logic [DATA_WIDTH-1:0] i_Data_2,
    output logic o_Error_Flag
    );

    always_comb begin
        o_Error_Flag = (i_Data_1 != i_Data_2);
    end

endmodule