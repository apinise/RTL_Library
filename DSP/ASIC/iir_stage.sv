module iir_stage (
  // Global Inputs
  input   logic         clk,
  input   logic         rst_n,
  // Coefficient Inputs,
  input   logic [15:0]  coeff_a1,
  input   logic [15:0]  coeff_a2,
  input   logic [15:0]  coeff_b0,
  input   logic [15:0]  coeff_b1,
  input   logic [15:0]  coeff_b2,
  // Data I/O
  input   logic [11:0]  din,
  output  logic [11:0]  dout
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [11:0]  din_r,  din_r2;
logic [11:0]  dout_r, dout_r2;

logic [27:0]  product_a1;
logic [27:0]  product_a2;
logic [27:0]  product_b0;
logic [27:0]  product_b1;
logic [27:0]  product_b2;

logic [29:0]  dout_sum;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

mult12x16 multiplier_a1 (
  .Din(dout_r),
  .Coeff(coeff_a1),
  .Product(product_a1)
);

mult12x16 multiplier_a2 (
  .Din(dout_r2),
  .Coeff(coeff_a2),
  .Product(product_a2)
);

mult12x16 multiplier_b0 (
  .Din(din),
  .Coeff(coeff_b0),
  .Product(product_b0)
);

mult12x16 multiplier_b1 (
  .Din(din_r),
  .Coeff(coeff_b1),
  .Product(product_b1)
);

mult12x16 multiplier_b2 (
  .Din(din_r2),
  .Coeff(coeff_b2),
  .Product(product_b2)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Register inputs and outputs
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    din_r   <= '0;
    din_r2  <= '0;
    dout_r  <= '0;
    dout_r2 <= '0;
  end
  else begin
    din_r   <= din;
    din_r2  <= din_r;
    dout_r  <= dout;
    dout_r2 <= dout_r;
  end
end

// Compute summation
assign dout_sum = product_b0 + product_b1 + product_b2 - product_a1 - product_a2;
assign dout     = dout_sum[26:15];

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////

/*
iir_stage iir_stage (
  .clk(),
  .rst_n(),
  .coeff_a1(),
  .coeff_a2(),
  .coeff_b0(),
  .coeff_b1(),
  .coeff_b2(),
  .din(),
  .dout()
);
*/

endmodule