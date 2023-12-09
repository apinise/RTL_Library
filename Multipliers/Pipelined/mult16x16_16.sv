module mult16x16_16 (
    input  logic             clk,
    input  logic             reset,
    input  logic [15:0]      a,
    input  logic [15:0]      b,
    input  logic             start,
    output logic [31:0]      result,
    output logic             done
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

localparam MAX_CNT = 4'd15;

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [31:0]  r, next_r;
logic         d, next_d;
logic [2:0]   cnt;

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_ff @(posedge clk) begin
  r   <= (reset) ? 32'h0 : (cnt == 3'd0) ? next_r : r + next_r;
  d   <= (reset) ? 1'd0 : next_d;
  if (d) begin
    cnt <= (reset) ? 3'd0 : cnt;
  end
  else begin
    cnt <= (reset) ? 3'd0 : cnt + 3'd1;
  end
end

always_comb begin
  next_d = (cnt == 3'd7) ? start : 1'd0;
  next_r =((b[cnt] == 1) ? (a << cnt) : 32'd0) + ((b[MAX_CNT-cnt] == 1) ? (a << MAX_CNT-cnt) : 32'd0);
end

assign done = d;
assign result = r;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
mult16x16_16 multiplier (
  .clk(),
  .reset(),
  .a(),
  .b(),
  .start(),
  .result(),
  .done()
);
*/

endmodule
