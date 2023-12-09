`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2023 07:17:51 PM
// Design Name: 
// Module Name: baud_rate_gen
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


module baud_rate_gen #(
    parameter BAUD_RATE = 9600,
    parameter CLK_FREQ  = 100000000
)(
    input   logic   Clk_Core,
    input   logic   Rst_Core_N,
    output  logic   Clk_Tx,
    output  logic   Clk_Rx
);

//////////////////////////////////////////////////////////////////////////////////
////////////////////////////         Parameters         //////////////////////////
//////////////////////////////////////////////////////////////////////////////////   

localparam TX_TERM_CNT  = CLK_FREQ / (BAUD_RATE * 2);
localparam TX_CNT_WIDTH = $clog2(TX_TERM_CNT);
localparam RX_TERM_CNT  = CLK_FREQ / (16 * BAUD_RATE * 2);
localparam RX_CNT_WIDTH = $clog2(RX_TERM_CNT);

///////////////////////////////////////////////////////////////////////////////////
////////////////////////////       Internal Nets       ////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

logic [TX_CNT_WIDTH-1:0] tx_cnt_r;
logic [RX_CNT_WIDTH-1:0] rx_cnt_r;

///////////////////////////////////////////////////////////////////////////////////
////////////////////////////        Module Logic       ////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

always_ff @(posedge Clk_Core) begin
    if (~Rst_Core_N) begin
        Clk_Tx      <= '0;
        Clk_Rx      <= '0;
        tx_cnt_r    <= '0;
        rx_cnt_r    <= '0;
    end else begin
        if (tx_cnt_r == TX_TERM_CNT) begin
            Clk_Tx   <= ~Clk_Tx;
            tx_cnt_r <= '0;
        end else begin
            tx_cnt_r <= tx_cnt_r + 1'd1;
        end
        if (rx_cnt_r == RX_TERM_CNT) begin
            Clk_Rx   <= ~Clk_Rx;
            rx_cnt_r <= '0;
        end else begin
            rx_cnt_r <= rx_cnt_r + 1'd1;
        end
    end
end

endmodule

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////    Instantiation Template    //////////////////////////
///////////////////////////////////////////////////////////////////////////////////
/*
baud_rate_gen #(
    .BAUD_RATE(),
    .ClK_FREQ()
)
baud_rate_gen (
    .Clk_Core(),
    .Rst_Core_N(),
    .Clk_Tx(),
    .Clk_Rx()
);
*/