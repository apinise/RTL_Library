module filter_top (
  // Clk + Reset
  input   logic clk,
  input   logic rst_n,
  // Data I/O
  input   logic [11:0] din,
  output  logic [11:0] dout,
  // SPI Interface
  input   logic SCK,
  input   logic CS,
  input   logic MOSI,
  output  logic MISO
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [11:0]  din_r;

// Mux nets
logic         out_sel;
logic [11:0]  dout_c;
logic [11:0]  dout_r;

// SPI nets
logic         load;
logic [7:0]   register_address;
logic [15:0]  register_value;
logic [7:0]   read_address;
logic [15:0]  read_value;

// FIR nets
logic [31:0][15:0]  fir_coeff;
logic       [11:0]  fir_dout;

// IIR nets
logic [7:0][15:0]   coeff_a1;
logic [7:0][15:0]   coeff_a2;
logic [7:0][15:0]   coeff_b0;
logic [7:0][15:0]   coeff_b1;
logic [7:0][15:0]   coeff_b2;
logic      [11:0]   iir_dout;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

mux2to1 #(
  .DWIDTH(12)
)
mux2to1 (
  .Mux_In_A(fir_dout),
  .Mux_In_B(iir_dout),
  .Input_Sel(out_sel),
  .Mux_Out(dout_c)
);

fir_transpose fir_filter (
  .clk(clk),
  .rst_n(rst_n),
  .coefficients(fir_coeff),
  .din(din_r),
  .dout(fir_dout)
);

iir_filter #(
  .STAGE_CNT(8),
  .COEFF_SIZE(16)
)
iir_filter (
  .clk(clk),
  .rst_n(rst_n),
  .coeff_a1(coeff_a1),
  .coeff_a2(coeff_a2),
  .coeff_b0(coeff_b0),
  .coeff_b1(coeff_b1),
  .coeff_b2(coeff_b2),
  .din(din_r),
  .dout(iir_dout)
);

control_reg control_reg (
  .clk(clk),
  .rst_n(rst_n),
  .write_address(register_address),
  .write_data(register_value),
  .write_en(load),
  .read_address(read_address),
  .read_data(read_value),
  .coeff_a1(coeff_a1),
  .coeff_a2(coeff_a2),
  .coeff_b0(coeff_b0),
  .coeff_b1(coeff_b1),
  .coeff_b2(coeff_b2),
  .fir_coeff(fir_coeff),
  .filter_select(out_sel)
);

SPI spi (
  .SCK(SCK),
  .CS(CS),
  .MOSI(MOSI),
  .Reset(~rst_n),
  .MISO(MISO),
  .load(load),
  .register_address(register_address),
  .register_value(register_value),
  .read_address(read_address),
  .read_value(read_value)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Register inputs and output
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    din_r   <= '0;
    dout_r  <= '0;
  end
  else begin
    din_r   <= din;
    dout_r  <= dout_c;
  end
end

assign dout = dout_r;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////

endmodule