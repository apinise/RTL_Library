`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2023 09:40:05 AM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx #(
    parameter WORD_SIZE = 8,
    parameter PARITY    = 0,
    parameter STOP_SIZE = 1
)(
    input   logic                   Clk_Rx,
    input   logic                   Rx_Start,
    input   logic                   Rx_Serial,
    output  logic [WORD_SIZE-1:0]   Rx_Data,
    output  logic                   Rx_Done,
    output  logic                   Rx_Busy,
    output  logic                   Rx_Error
);

//////////////////////////////////////////////////////////////////////////////////
////////////////////////////         Parameters         //////////////////////////
////////////////////////////////////////////////////////////////////////////////// 

localparam OVERSAMPLE_COUNT = 16;

///////////////////////////////////////////////////////////////////////////////////
////////////////////////////       Internal Nets       ////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

//FSM Nets
typedef enum logic [2:0] {
    S_WAIT,
    S_START,
    S_DATA,
    S_PARITY,
    S_STOP
} state_type;
state_type state_r;

//Tx logic nets
logic [3:0] bit_cnt_r;
logic       stop_cnt_r;
logic       parity_r;

logic [3:0] rx_clk_cnt_r;
logic [1:0] rx_serial_r = '0;

logic [WORD_SIZE-1:0] rx_data_r;

///////////////////////////////////////////////////////////////////////////////////
////////////////////////////        Module Logic       ////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

always_ff @(posedge Clk_Rx) begin
    rx_serial_r <= {rx_serial_r[0], Rx_Serial};
    casez(state_r)
        S_WAIT: begin
            Rx_Done     <= '0;
            Rx_Error    <= '0;
            bit_cnt_r   <= '0;
            stop_cnt_r  <= '0;
            parity_r    <= '0;
            if (Rx_Start && rx_serial_r[0] == 1'b0) begin
                Rx_Busy <= 1'b1;
                rx_clk_cnt_r <= 4'd1;
                state_r <= S_START;
            end else begin
                Rx_Busy <= '0;
                state_r <= S_WAIT;
            end
        end
        S_START: begin
            if (rx_clk_cnt_r == 4'd7) begin
                if (rx_serial_r == 2'b00) begin
                    rx_clk_cnt_r <= '0;
                    state_r <= S_DATA;
                end else begin
                    Rx_Error <= 1'b1;
                    state_r <= S_WAIT;
                end
            end else begin
                rx_clk_cnt_r <= rx_clk_cnt_r + 4'd1;
                state_r <= S_START;
            end
        end
        S_DATA: begin
            if (rx_clk_cnt_r == (OVERSAMPLE_COUNT-1)) begin
                rx_data_r <= {rx_serial_r[0], rx_data_r[WORD_SIZE-1:1]};
                bit_cnt_r <= bit_cnt_r + 4'd1;
                rx_clk_cnt_r <= '0;
                if (bit_cnt_r == (WORD_SIZE-1)) begin
                    if (PARITY == 1) begin
                        state_r <= S_PARITY;
                        parity_r <= ^(rx_data_r);
                    end else begin
                        state_r <= S_STOP;
                    end
                end else begin
                    state_r <= S_DATA;
                end
            end else begin
                rx_clk_cnt_r <= rx_clk_cnt_r + 4'd1;
                state_r <= S_DATA;
            end
        end
        S_PARITY: begin
            if (rx_clk_cnt_r == (OVERSAMPLE_COUNT-1)) begin
                rx_clk_cnt_r <= '0;
                if (rx_serial_r[0] == parity_r) begin
                    state_r <= S_STOP; 
                end else begin
                    Rx_Error <= 1'b1;
                    state_r <= S_WAIT;
                end
            end else begin
                rx_clk_cnt_r <= rx_clk_cnt_r + 4'd1;
                state_r <= S_PARITY;                
            end
        end
        S_STOP: begin
            if (rx_clk_cnt_r == (OVERSAMPLE_COUNT-1)) begin
                if (rx_serial_r[0] == 1'd1) begin
                    if (stop_cnt_r == (STOP_SIZE-1)) begin
                        Rx_Done <= 1'd1;
                        Rx_Data <= rx_data_r;
                        rx_clk_cnt_r <= '0;
                        state_r <= S_WAIT;
                    end else begin
                        stop_cnt_r <= stop_cnt_r + 1'd1;
                        state_r <= S_STOP;
                    end
                end else begin
                    Rx_Error <= 1'b1;
                    state_r <= S_WAIT;
                end
            end else begin
                rx_clk_cnt_r <= rx_clk_cnt_r + 4'd1;
                state_r <= S_STOP;
            end
        end
        default: begin
            Rx_Done     <= '0;
            Rx_Error    <= '0;
            bit_cnt_r   <= '0;
            stop_cnt_r  <= '0;
            parity_r    <= '0;
            Rx_Busy <= 1'b1;
            state_r <= S_WAIT;
        end    
    endcase
end

endmodule

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////    Instantiation Template    //////////////////////////
///////////////////////////////////////////////////////////////////////////////////
/*
uart_rx #(
    .WORD_SIZE(),
    .PARITY(),
    .STOP_SIZE()
)
uart_rx (
    .Clk_Rx(),
    .Rx_Start(),
    .Rx_Serial(),
    .Rx_Data(),
    .Rx_Done(),
    .Rx_Busy(),
    .Rx_Error()
);
*/