`timescale 1ns / 1ps

module clock_manager #(
    parameter DATA_WIDTH = 8,
    parameter INITIAL_CLK_DIV = 128,
    parameter MAX_CLK_DIV = 254,
    parameter MIN_CLK_DIV = 1,
    parameter VALIDATION_COUNT = 3
    )(
        input  logic clk,         
        input  logic rst_n,
        input  logic i_Error_Flag,
        output logic [DATA_WIDTH-1:0] o_Clk_Div,
        output logic o_Done
    );

    typedef enum logic [1:0] {
        IDLE,
        SEARCH,
        VALIDATE,
        FINISH
    } state_t;

    state_t s_State;
    state_t s_Next_State;

    logic [DATA_WIDTH-1:0] l_Low;
    logic [DATA_WIDTH-1:0] l_High; 
    logic [DATA_WIDTH-1:0] l_Mid;
    logic [VALIDATION_COUNT-1:0] l_Validate_Count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_State <= IDLE;
            l_Low <= MIN_CLK_DIV;
            l_High <= MAX_CLK_DIV;
            l_Mid <= INITIAL_CLK_DIV;
            o_Clk_Div <= INITIAL_CLK_DIV;
            o_Done <= 0;
            l_Validate_Count <= 0;
        end 
        
        else begin
            s_State <= s_Next_State;

            case (s_State)
                SEARCH: begin
                    l_Mid <= (l_Low + l_High) >> 1;     
                    o_Clk_Div <= l_Mid;
                end

                VALIDATE: begin
                    if (!i_Error_Flag) begin
                        l_Validate_Count <= l_Validate_Count + 1;
                        if (l_Validate_Count >= 1)
                            l_High <= o_Clk_Div - 1;
                    end else begin
                        l_Validate_Count <= 0;
                        l_Low <= o_Clk_Div + 1;
                    end
                end

                FINISH: begin
                    o_Done <= 1;
                end

                default: begin
                    
                end
            endcase
        end
    end

    always_comb begin
        s_Next_State = s_State;

        case (s_State)
            IDLE:     
                s_Next_State = i_Error_Flag ? SEARCH : IDLE;

            SEARCH:   
                s_Next_State = VALIDATE;

            VALIDATE: begin
                if (l_Validate_Count >= VALIDATION_COUNT || l_Low > l_High)
                    s_Next_State = FINISH;
                else if (i_Error_Flag)
                    s_Next_State = SEARCH;
                else
                    s_Next_State = VALIDATE;
            end

            FINISH:   
                s_Next_State = FINISH;
        endcase
    end

endmodule