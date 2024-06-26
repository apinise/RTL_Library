module mult12x16 (
  input  logic [11:0] Din,
  input  logic [15:0] Coeff,
  output logic [27:0] Product
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

localparam XOR_VAL = 28'hFFFFFFF;

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [15:0][27:0]  next_r;
logic [27:0] 	      next_r2;
logic [15:0]        b;

genvar  i;
integer j;

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// generate shifts for binary multiplication
generate
  for (i=0; i < 16; i++) begin
    assign next_r[i] = (b[i] == 1) ? (Din << i) : 28'd0;
  end
endgenerate

// logic for converting signed coefficient to unsigned for mult
always_comb begin
  if (Coeff[15]) begin
    b = (Coeff ^ XOR_VAL) + 16'd1;
    Product = (next_r2 ^ XOR_VAL) + 16'd1;
  end
  else begin
    b = Coeff;
    Product = next_r2;
  end
end

// summation of shifts
always_comb begin
  next_r2 = '0;
  for (j = 0; j < 16; j=j+1) begin
    next_r2 = next_r2 + next_r[j];
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////

/*
mult12x12 multiplier (
  .Din(),
  .Coeff(),
  .Product()
);
*/

endmodule
