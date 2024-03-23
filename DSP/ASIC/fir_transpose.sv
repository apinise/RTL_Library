module fir_transpose (
  //FIR Filter Nets
  input   logic               clk,            // Global clk
  input   logic               rst_n,          // Reset coefficients and initialize registers
  input   logic [31:0][15:0]  coefficients,
  input   logic [11:0]        din,            // 12-bit input data from ADC
  output  logic [11:0]        dout            // 12-bit output data from Filter to DAC
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

localparam NUMTAPS = 32;

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic signed  [31:0][27:0]  product_c;
logic signed  [31:0][27:0]  sum_r;

integer i;
integer l;
genvar  k;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

generate
  for (k = 0; k < NUMTAPS; k=k+1) begin : generate_multipliers
    mult12x16 multiplier (
      .Din(din),
      .Coeff(coefficients[NUMTAPS-k-1]),
      .Product(product_c[k])
    );
  end
endgenerate

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    for (l = 0; l < NUMTAPS; l=l+1) begin
      sum_r[l] <= '0;
    end    
  end
  else begin
    sum_r[0] <= product_c[0];
    for (i = 1; i < NUMTAPS; i=i+1) begin
      sum_r[i] <= sum_r[i-1] + $signed(product_c[i]);
    end
  end
end

assign dout = sum_r[31][26:15];

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////

/*
fir_transpose fir_filter (
  .clk(),
  .rst_n(),
  .coefficients(),
  .din(),
  .dout()
);
*/

endmodule