module mult16x16_1 (
  input  logic             clk,
  input  logic             reset,
  input  logic [15:0]      a,
  input  logic [15:0]      b,
  input  logic             start,
  output logic [31:0]      result,
  output logic             done
);

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [31:0]        r;
logic [15:0][31:0]  next_r;
logic [31:0]        next_r2;
logic               d;
logic               next_d;

genvar i;
integer j;

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

generate
  for (i=0; i < 16; i++) begin
    assign next_r[i] = (b[i] == 1) ? (a << i) : 32'd0;
  end
endgenerate

always_ff @(posedge clk) begin
  r <= (reset) ? 32'h0 : next_r2;
  d <= (reset) ? 1'd0 : next_d;
end

always_comb begin
  next_d  = start;
  next_r2 = '0;
  for (j = 0; j < 16; j=j+1) begin
    next_r2 = next_r2 + next_r[j];
  end
end

assign done = d;
assign result = r;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
mult16x16 multiplier (
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
