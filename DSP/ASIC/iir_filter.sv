module iir_filter #(
  parameter STAGE_CNT   = 8,
  parameter COEFF_SIZE  = 16
)(
  // Global inptus
  input   logic         clk,
  input   logic         rst_n,
  // Coefficient values
  input   logic [STAGE_CNT-1:0][COEFF_SIZE-1:0] coeff_a1,
  input   logic [STAGE_CNT-1:0][COEFF_SIZE-1:0] coeff_a2,
  input   logic [STAGE_CNT-1:0][COEFF_SIZE-1:0] coeff_b0,
  input   logic [STAGE_CNT-1:0][COEFF_SIZE-1:0] coeff_b1,
  input   logic [STAGE_CNT-1:0][COEFF_SIZE-1:0] coeff_b2,
  // Data I/O
  input   logic [11:0]  din,
  output  logic [11:0]  dout,
  // Control registers
  input   logic [15:0]  stage_length
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [7:0] filter_length_1;
logic [7:0] filter_length_2;

logic [11:0]            din_r;
logic [STAGE_CNT-1:0][11:0] stage_out;

genvar  k;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

iir_stage stage1 (
  .clk(clk),
  .rst_n(rst_n),
  .coeff_a1(coeff_a1[0]),
  .coeff_a2(coeff_a2[0]),
  .coeff_b0(coeff_b0[0]),
  .coeff_b1(coeff_b1[0]),
  .coeff_b2(coeff_b2[0]),
  .din(din_r),
  .dout(stage_out[0])
);

generate
  for (k = 1; k < STAGE_CNT-1; k=k+1) begin : generate_stages  
    iir_stage stage (
      .clk(clk),
      .rst_n(rst_n),
      .coeff_a1(coeff_a1[k]),
      .coeff_a2(coeff_a2[k]),
      .coeff_b0(coeff_b0[k]),
      .coeff_b1(coeff_b1[k]),
      .coeff_b2(coeff_b2[k]),
      .din(stage_out[k-1]),
      .dout(stage_out[k])
    );
  end
endgenerate

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Read control registers
assign filter_length_1 = stage_length[7:0];
assign filter_length_2 = stage_length[15:8];

// Register input
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    din_r <= '0;
    dout  <= '0;
  end
  else begin
    din_r <= din;
    dout  <= stage_out[STAGE_CNT-1];
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
iir_filter #(
  .STAGE_CNT(),
  .COEFF_SIZE()
)
iir_filter (
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