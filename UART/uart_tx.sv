`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2023 09:55:08 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx #(
    parameter WORD_SIZE = 8,
    parameter PARITY    = 0,
    parameter STOP_SIZE = 1
)(
    input   logic                   Clk_Tx,
    input   logic                   Tx_Start,
    input   logic [WORD_SIZE-1:0]   Tx_Data,
    output  logic                   Tx_Serial,
    output  logic                   Tx_Done,
    output  logic                   Tx_Busy
);

//////////////////////////////////////////////////////////////////////////////////
////////////////////////////         Parameters         //////////////////////////
////////////////////////////////////////////////////////////////////////////////// 

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

//Input register
logic [WORD_SIZE-1:0] tx_data_r;

//Tx logic nets
logic [3:0] bit_cnt_r;
logic       stop_cnt_r;
logic       parity_r;

///////////////////////////////////////////////////////////////////////////////////
////////////////////////////        Module Logic       ////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

always_ff @(posedge Clk_Tx) begin
    casez(state_r)
        S_WAIT: begin
            Tx_Serial   <= 1'b1;
            Tx_Done     <= '0;
            Tx_Busy     <= '0;
            bit_cnt_r   <= '0;
            stop_cnt_r  <= '0;
            parity_r    <= '0;
            if (Tx_Start) begin
                tx_data_r   <= Tx_Data;
                parity_r    <= ^Tx_Data;
                state_r     <= S_START;
            end else begin
                state_r     <= S_WAIT;
            end
        end
        S_START: begin
            Tx_Serial   <= '0;
            Tx_Busy     <= 1'b1;
            Tx_Done     <= '0;
            state_r     <= S_DATA;
        end
        S_DATA: begin
            Tx_Serial <= tx_data_r[bit_cnt_r];
            if (bit_cnt_r == (WORD_SIZE-1)) begin
                bit_cnt_r <= '0;
                if (PARITY == 1) begin
                    state_r <= S_PARITY;
                end else begin
                    state_r <= S_STOP;
                end
            end else begin
                bit_cnt_r <= bit_cnt_r + 1'b1;
            end
        end
        S_PARITY: begin
            Tx_Serial <= parity_r;
            state_r <= S_STOP;
        end
        S_STOP: begin
            Tx_Serial <= 1'b1;
            if (stop_cnt_r == (STOP_SIZE-1)) begin
                Tx_Done <= 1'b1;
                if (~Tx_Start) begin
                    state_r <= S_WAIT;
                end else begin
                    tx_data_r   <= Tx_Data;
                    parity_r    <= ^Tx_Data;
                    bit_cnt_r   <= '0;
                    stop_cnt_r  <= '0;
                    state_r     <= S_START;
                end
            end else begin
                stop_cnt_r <= stop_cnt_r + 1'b1;
            end
        end
        default: begin
            state_r <= S_WAIT;
            Tx_Done     <= '0;
            Tx_Busy     <= '0;
            Tx_Serial   <= 1'b1;
        end
    endcase
end

endmodule

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////    Instantiation Template    //////////////////////////
///////////////////////////////////////////////////////////////////////////////////
/*
uart_tx #(
    .WORD_SIZE(),
    .PARITY(),
    .STOP_SIZE()
)
uart_tx (
    .Clk_Tx(),
    .Tx_Start(),
    .Tx_Data(),
    .Tx_Serial(),
    .Tx_Done(),
    .Tx_Busy()
);
*/