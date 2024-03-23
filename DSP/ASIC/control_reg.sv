module control_reg (
  // Global input
  input   logic         clk,
  input   logic         rst_n,
  // Write port from SPI
  input   logic [7:0]   write_address,
  input   logic [15:0]  write_data,
  input   logic         write_en,
  // Read port to SPI
  input   logic [7:0]   read_address,
  output  logic [15:0]  read_data,
  // Control outputs
  output  logic [7:0][15:0]   coeff_a1,
  output  logic [7:0][15:0]   coeff_a2,
  output  logic [7:0][15:0]   coeff_b0,
  output  logic [7:0][15:0]   coeff_b1,
  output  logic [7:0][15:0]   coeff_b2,
  output  logic [31:0][15:0]  fir_coeff,
  output  logic               filter_select
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

// IIR Stage A1 Coeff
logic [15:0] coeff_a1_0;
logic [15:0] coeff_a1_1;
logic [15:0] coeff_a1_2;
logic [15:0] coeff_a1_3;
logic [15:0] coeff_a1_4;
logic [15:0] coeff_a1_5;
logic [15:0] coeff_a1_6;
logic [15:0] coeff_a1_7;

// IIR Stage A2 Coeff
logic [15:0] coeff_a2_0;
logic [15:0] coeff_a2_1;
logic [15:0] coeff_a2_2;
logic [15:0] coeff_a2_3;
logic [15:0] coeff_a2_4;
logic [15:0] coeff_a2_5;
logic [15:0] coeff_a2_6;
logic [15:0] coeff_a2_7;

// IIR Stage B0 Coeff
logic [15:0] coeff_b0_0;
logic [15:0] coeff_b0_1;
logic [15:0] coeff_b0_2;
logic [15:0] coeff_b0_3;
logic [15:0] coeff_b0_4;
logic [15:0] coeff_b0_5;
logic [15:0] coeff_b0_6;
logic [15:0] coeff_b0_7;

// IIR Stage B1 Coeff
logic [15:0] coeff_b1_0;
logic [15:0] coeff_b1_1;
logic [15:0] coeff_b1_2;
logic [15:0] coeff_b1_3;
logic [15:0] coeff_b1_4;
logic [15:0] coeff_b1_5;
logic [15:0] coeff_b1_6;
logic [15:0] coeff_b1_7;

// IIR Stage B2 Coeff
logic [15:0] coeff_b2_0;
logic [15:0] coeff_b2_1;
logic [15:0] coeff_b2_2;
logic [15:0] coeff_b2_3;
logic [15:0] coeff_b2_4;
logic [15:0] coeff_b2_5;
logic [15:0] coeff_b2_6;
logic [15:0] coeff_b2_7;

// FIR Tap Coeff
logic [15:0] tap_coeff_0;
logic [15:0] tap_coeff_1;
logic [15:0] tap_coeff_2;
logic [15:0] tap_coeff_3;
logic [15:0] tap_coeff_4;
logic [15:0] tap_coeff_5;
logic [15:0] tap_coeff_6;
logic [15:0] tap_coeff_7;
logic [15:0] tap_coeff_8;
logic [15:0] tap_coeff_9;
logic [15:0] tap_coeff_10;
logic [15:0] tap_coeff_11;
logic [15:0] tap_coeff_12;
logic [15:0] tap_coeff_13;
logic [15:0] tap_coeff_14;
logic [15:0] tap_coeff_15;
logic [15:0] tap_coeff_16;
logic [15:0] tap_coeff_17;
logic [15:0] tap_coeff_18;
logic [15:0] tap_coeff_19;
logic [15:0] tap_coeff_20;
logic [15:0] tap_coeff_21;
logic [15:0] tap_coeff_22;
logic [15:0] tap_coeff_23;
logic [15:0] tap_coeff_24;
logic [15:0] tap_coeff_25;
logic [15:0] tap_coeff_26;
logic [15:0] tap_coeff_27;
logic [15:0] tap_coeff_28;
logic [15:0] tap_coeff_29;
logic [15:0] tap_coeff_30;
logic [15:0] tap_coeff_31;

// Control registers
logic [15:0] filter_sel;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Write into registers
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    coeff_a1_0 <= '0;
    coeff_a1_1 <= '0;
    coeff_a1_2 <= '0;
    coeff_a1_3 <= '0;
    coeff_a1_4 <= '0;
    coeff_a1_5 <= '0;
    coeff_a1_6 <= '0;
    coeff_a1_7 <= '0;
    // ...
    coeff_a2_0 <= '0;
    coeff_a2_1 <= '0;
    coeff_a2_2 <= '0;
    coeff_a2_3 <= '0;
    coeff_a2_4 <= '0;
    coeff_a2_5 <= '0;
    coeff_a2_6 <= '0;
    coeff_a2_7 <= '0;
    // ...
    coeff_b0_0 <= '0;
    coeff_b0_1 <= '0;
    coeff_b0_2 <= '0;
    coeff_b0_3 <= '0;
    coeff_b0_4 <= '0;
    coeff_b0_5 <= '0;
    coeff_b0_6 <= '0;
    coeff_b0_7 <= '0;
    // ...
    coeff_b1_0 <= '0;
    coeff_b1_1 <= '0;
    coeff_b1_2 <= '0;
    coeff_b1_3 <= '0;
    coeff_b1_4 <= '0;
    coeff_b1_5 <= '0;
    coeff_b1_6 <= '0;
    coeff_b1_7 <= '0;
    // ...
    coeff_b2_0 <= '0;
    coeff_b2_1 <= '0;
    coeff_b2_2 <= '0;
    coeff_b2_3 <= '0;
    coeff_b2_4 <= '0;
    coeff_b2_5 <= '0;
    coeff_b2_6 <= '0;
    coeff_b2_7 <= '0;
    // ...
    tap_coeff_0   <= '0;
    tap_coeff_1   <= '0;
    tap_coeff_2   <= '0;
    tap_coeff_3   <= '0;
    tap_coeff_4   <= '0;
    tap_coeff_5   <= '0;
    tap_coeff_6   <= '0;
    tap_coeff_7   <= '0;
    tap_coeff_8   <= '0;
    tap_coeff_9   <= '0;
    tap_coeff_10  <= '0;
    tap_coeff_11  <= '0;
    tap_coeff_12  <= '0;
    tap_coeff_13  <= '0;
    tap_coeff_14  <= '0;
    tap_coeff_15  <= '0;
    tap_coeff_16  <= '0;
    tap_coeff_17  <= '0;
    tap_coeff_18  <= '0;
    tap_coeff_19  <= '0;
    tap_coeff_20  <= '0;
    tap_coeff_21  <= '0;
    tap_coeff_22  <= '0;
    tap_coeff_23  <= '0;
    tap_coeff_24  <= '0;
    tap_coeff_25  <= '0;
    tap_coeff_26  <= '0;
    tap_coeff_27  <= '0;
    tap_coeff_28  <= '0;
    tap_coeff_29  <= '0;
    tap_coeff_30  <= '0;
    tap_coeff_31  <= '0;
    // ...
    filter_sel    <= '0;
  end
  else begin
    if (write_en) begin
      casez(write_address)
        8'h00: coeff_a1_0   <= write_data;
        8'h01: coeff_a1_1   <= write_data;
        8'h02: coeff_a1_2   <= write_data;
        8'h03: coeff_a1_3   <= write_data;
        8'h04: coeff_a1_4   <= write_data;
        8'h05: coeff_a1_5   <= write_data;
        8'h06: coeff_a1_6   <= write_data;
        8'h07: coeff_a1_7   <= write_data;
        // ...
        8'h10: coeff_a2_0   <= write_data;
        8'h11: coeff_a2_1   <= write_data;
        8'h12: coeff_a2_2   <= write_data;
        8'h13: coeff_a2_3   <= write_data;
        8'h14: coeff_a2_4   <= write_data;
        8'h15: coeff_a2_5   <= write_data;
        8'h16: coeff_a2_6   <= write_data;
        8'h17: coeff_a2_7   <= write_data;
        // ...
        8'h20: coeff_b0_0   <= write_data;
        8'h21: coeff_b0_1   <= write_data;
        8'h22: coeff_b0_2   <= write_data;
        8'h23: coeff_b0_3   <= write_data;
        8'h24: coeff_b0_4   <= write_data;
        8'h25: coeff_b0_5   <= write_data;
        8'h26: coeff_b0_6   <= write_data;
        8'h27: coeff_b0_7   <= write_data;
        // ...
        8'h30: coeff_b1_0   <= write_data;
        8'h31: coeff_b1_1   <= write_data;
        8'h32: coeff_b1_2   <= write_data;
        8'h33: coeff_b1_3   <= write_data;
        8'h34: coeff_b1_4   <= write_data;
        8'h35: coeff_b1_5   <= write_data;
        8'h36: coeff_b1_6   <= write_data;
        8'h37: coeff_b1_7   <= write_data;
        // ...
        8'h40: coeff_b2_0   <= write_data;
        8'h41: coeff_b2_1   <= write_data;
        8'h42: coeff_b2_2   <= write_data;
        8'h43: coeff_b2_3   <= write_data;
        8'h44: coeff_b2_4   <= write_data;
        8'h45: coeff_b2_5   <= write_data;
        8'h46: coeff_b2_6   <= write_data;
        8'h47: coeff_b2_7   <= write_data;
        // ...
        8'h50: tap_coeff_0  <= write_data;
        8'h51: tap_coeff_1  <= write_data;
        8'h52: tap_coeff_2  <= write_data;
        8'h53: tap_coeff_3  <= write_data;
        8'h54: tap_coeff_4  <= write_data;
        8'h55: tap_coeff_5  <= write_data;
        8'h56: tap_coeff_6  <= write_data;
        8'h57: tap_coeff_7  <= write_data;
        8'h58: tap_coeff_8  <= write_data;
        8'h59: tap_coeff_9  <= write_data;
        8'h5A: tap_coeff_10 <= write_data;
        8'h5B: tap_coeff_11 <= write_data;
        8'h5C: tap_coeff_12 <= write_data;
        8'h5D: tap_coeff_13 <= write_data;
        8'h5E: tap_coeff_14 <= write_data;
        8'h5F: tap_coeff_15 <= write_data;
        8'h60: tap_coeff_16 <= write_data;
        8'h61: tap_coeff_17 <= write_data;
        8'h62: tap_coeff_18 <= write_data;
        8'h63: tap_coeff_19 <= write_data;
        8'h64: tap_coeff_20 <= write_data;
        8'h65: tap_coeff_21 <= write_data;
        8'h66: tap_coeff_22 <= write_data;
        8'h67: tap_coeff_23 <= write_data;
        8'h68: tap_coeff_24 <= write_data;
        8'h69: tap_coeff_25 <= write_data;
        8'h6A: tap_coeff_26 <= write_data;
        8'h6B: tap_coeff_27 <= write_data;
        8'h6C: tap_coeff_28 <= write_data;
        8'h6D: tap_coeff_29 <= write_data;
        8'h6E: tap_coeff_30 <= write_data;
        8'h6F: tap_coeff_31 <= write_data;
        // ...
        8'hF0: filter_sel   <= write_data;
        default: begin
          coeff_a1_0    <= coeff_a1_0;
          coeff_a1_1    <= coeff_a1_1;
          coeff_a1_2    <= coeff_a1_2;
          coeff_a1_3    <= coeff_a1_3;
          coeff_a1_4    <= coeff_a1_4;
          coeff_a1_5    <= coeff_a1_5;
          coeff_a1_6    <= coeff_a1_6;
          coeff_a1_7    <= coeff_a1_7;
          // ...
          coeff_a2_0    <= coeff_a2_0;
          coeff_a2_1    <= coeff_a2_1;
          coeff_a2_2    <= coeff_a2_2;
          coeff_a2_3    <= coeff_a2_3;
          coeff_a2_4    <= coeff_a2_4;
          coeff_a2_5    <= coeff_a2_5;
          coeff_a2_6    <= coeff_a2_6;
          coeff_a2_7    <= coeff_a2_7;
          // ...
          coeff_b0_0    <= coeff_b0_0;
          coeff_b0_1    <= coeff_b0_1;
          coeff_b0_2    <= coeff_b0_2;
          coeff_b0_3    <= coeff_b0_3;
          coeff_b0_4    <= coeff_b0_4;
          coeff_b0_5    <= coeff_b0_5;
          coeff_b0_6    <= coeff_b0_6;
          coeff_b0_7    <= coeff_b0_7;
          // ...
          coeff_b1_0    <= coeff_b1_0;
          coeff_b1_1    <= coeff_b1_1;
          coeff_b1_2    <= coeff_b1_2;
          coeff_b1_3    <= coeff_b1_3;
          coeff_b1_4    <= coeff_b1_4;
          coeff_b1_5    <= coeff_b1_5;
          coeff_b1_6    <= coeff_b1_6;
          coeff_b1_7    <= coeff_b1_7;
          // ...
          coeff_b2_0    <= coeff_b2_0;
          coeff_b2_1    <= coeff_b2_1;
          coeff_b2_2    <= coeff_b2_2;
          coeff_b2_3    <= coeff_b2_3;
          coeff_b2_4    <= coeff_b2_4;
          coeff_b2_5    <= coeff_b2_5;
          coeff_b2_6    <= coeff_b2_6;
          coeff_b2_7    <= coeff_b2_7;
          // ...
          tap_coeff_0   <= tap_coeff_0;
          tap_coeff_1   <= tap_coeff_1;
          tap_coeff_2   <= tap_coeff_2;
          tap_coeff_3   <= tap_coeff_3;
          tap_coeff_4   <= tap_coeff_4;
          tap_coeff_5   <= tap_coeff_5;
          tap_coeff_6   <= tap_coeff_6;
          tap_coeff_7   <= tap_coeff_7;
          tap_coeff_8   <= tap_coeff_8;
          tap_coeff_9   <= tap_coeff_9;
          tap_coeff_10  <= tap_coeff_10;
          tap_coeff_11  <= tap_coeff_11;
          tap_coeff_12  <= tap_coeff_12;
          tap_coeff_13  <= tap_coeff_13;
          tap_coeff_14  <= tap_coeff_14;
          tap_coeff_15  <= tap_coeff_15;
          tap_coeff_16  <= tap_coeff_16;
          tap_coeff_17  <= tap_coeff_17;
          tap_coeff_18  <= tap_coeff_18;
          tap_coeff_19  <= tap_coeff_19;
          tap_coeff_20  <= tap_coeff_20;
          tap_coeff_21  <= tap_coeff_21;
          tap_coeff_22  <= tap_coeff_22;
          tap_coeff_23  <= tap_coeff_23;
          tap_coeff_24  <= tap_coeff_24;
          tap_coeff_25  <= tap_coeff_25;
          tap_coeff_26  <= tap_coeff_26;
          tap_coeff_27  <= tap_coeff_27;
          tap_coeff_28  <= tap_coeff_28;
          tap_coeff_29  <= tap_coeff_29;
          tap_coeff_30  <= tap_coeff_30;
          tap_coeff_31  <= tap_coeff_31;
          // ...
          filter_sel    <= filter_sel;
        end
      endcase
    end
  end
end

// Read from registers
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    read_data <= '0;
  end
  else begin
    casez(read_address)
      8'h00: read_data  <= coeff_a1_0;
      8'h01: read_data  <= coeff_a1_1;
      8'h02: read_data  <= coeff_a1_2;
      8'h03: read_data  <= coeff_a1_3;
      8'h04: read_data  <= coeff_a1_4;
      8'h05: read_data  <= coeff_a1_5;
      8'h06: read_data  <= coeff_a1_6;
      8'h07: read_data  <= coeff_a1_7;
      // ...
      8'h10: read_data  <= coeff_a2_0;
      8'h11: read_data  <= coeff_a2_1;
      8'h12: read_data  <= coeff_a2_2;
      8'h13: read_data  <= coeff_a2_3;
      8'h14: read_data  <= coeff_a2_4;
      8'h15: read_data  <= coeff_a2_5;
      8'h16: read_data  <= coeff_a2_6;
      8'h17: read_data  <= coeff_a2_7;
      // ...
      8'h20: read_data  <= coeff_b0_0;
      8'h21: read_data  <= coeff_b0_1;
      8'h22: read_data  <= coeff_b0_2;
      8'h23: read_data  <= coeff_b0_3;
      8'h24: read_data  <= coeff_b0_4;
      8'h25: read_data  <= coeff_b0_5;
      8'h26: read_data  <= coeff_b0_6;
      8'h27: read_data  <= coeff_b0_7;
      // ...
      8'h30: read_data  <= coeff_b1_0;
      8'h31: read_data  <= coeff_b1_1;
      8'h32: read_data  <= coeff_b1_2;
      8'h33: read_data  <= coeff_b1_3;
      8'h34: read_data  <= coeff_b1_4;
      8'h35: read_data  <= coeff_b1_5;
      8'h36: read_data  <= coeff_b1_6;
      8'h37: read_data  <= coeff_b1_7;
      // ...
      8'h40: read_data  <= coeff_b2_0;
      8'h41: read_data  <= coeff_b2_1;
      8'h42: read_data  <= coeff_b2_2;
      8'h43: read_data  <= coeff_b2_3;
      8'h44: read_data  <= coeff_b2_4;
      8'h45: read_data  <= coeff_b2_5;
      8'h46: read_data  <= coeff_b2_6;
      8'h47: read_data  <= coeff_b2_7;
      // ...
      8'h50: read_data <= tap_coeff_0;
      8'h51: read_data <= tap_coeff_1;
      8'h52: read_data <= tap_coeff_2;
      8'h53: read_data <= tap_coeff_3;
      8'h54: read_data <= tap_coeff_4;
      8'h55: read_data <= tap_coeff_5;
      8'h56: read_data <= tap_coeff_6;
      8'h57: read_data <= tap_coeff_7;
      8'h58: read_data <= tap_coeff_8;
      8'h59: read_data <= tap_coeff_9;
      8'h5A: read_data <= tap_coeff_10;
      8'h5B: read_data <= tap_coeff_11;
      8'h5C: read_data <= tap_coeff_12;
      8'h5D: read_data <= tap_coeff_13;
      8'h5E: read_data <= tap_coeff_14;
      8'h5F: read_data <= tap_coeff_15;
      8'h60: read_data <= tap_coeff_16;
      8'h61: read_data <= tap_coeff_17;
      8'h62: read_data <= tap_coeff_18;
      8'h63: read_data <= tap_coeff_19;
      8'h64: read_data <= tap_coeff_20;
      8'h65: read_data <= tap_coeff_21;
      8'h66: read_data <= tap_coeff_22;
      8'h67: read_data <= tap_coeff_23;
      8'h68: read_data <= tap_coeff_24;
      8'h69: read_data <= tap_coeff_25;
      8'h6A: read_data <= tap_coeff_26;
      8'h6B: read_data <= tap_coeff_27;
      8'h6C: read_data <= tap_coeff_28;
      8'h6D: read_data <= tap_coeff_29;
      8'h6E: read_data <= tap_coeff_30;
      8'h6F: read_data <= tap_coeff_31;
      // ...
      8'hF0: read_data <= filter_sel;
      default: begin
        read_data  <= '0;
      end
    endcase
  end
end

////////////////////// Assign outputs //////////////////////////
// IIR Stage A1 Coeff
assign coeff_a1[0] = coeff_a1_0;
assign coeff_a1[1] = coeff_a1_1;
assign coeff_a1[2] = coeff_a1_2;
assign coeff_a1[3] = coeff_a1_3;
assign coeff_a1[4] = coeff_a1_4;
assign coeff_a1[5] = coeff_a1_5;
assign coeff_a1[6] = coeff_a1_6;
assign coeff_a1[7] = coeff_a1_7;

// IIR Stage A2 Coeff
assign coeff_a2[0] = coeff_a2_0;
assign coeff_a2[1] = coeff_a2_1;
assign coeff_a2[2] = coeff_a2_2;
assign coeff_a2[3] = coeff_a2_3;
assign coeff_a2[4] = coeff_a2_4;
assign coeff_a2[5] = coeff_a2_5;
assign coeff_a2[6] = coeff_a2_6;
assign coeff_a2[7] = coeff_a2_7;

// IIR Stage B0 Coeff
assign coeff_b0[0] = coeff_b0_0;
assign coeff_b0[1] = coeff_b0_1;
assign coeff_b0[2] = coeff_b0_2;
assign coeff_b0[3] = coeff_b0_3;
assign coeff_b0[4] = coeff_b0_4;
assign coeff_b0[5] = coeff_b0_5;
assign coeff_b0[6] = coeff_b0_6;
assign coeff_b0[7] = coeff_b0_7;

// IIR Stage B1 Coeff
assign coeff_b1[0] = coeff_b1_0;
assign coeff_b1[1] = coeff_b1_1;
assign coeff_b1[2] = coeff_b1_2;
assign coeff_b1[3] = coeff_b1_3;
assign coeff_b1[4] = coeff_b1_4;
assign coeff_b1[5] = coeff_b1_5;
assign coeff_b1[6] = coeff_b1_6;
assign coeff_b1[7] = coeff_b1_7;

// IIR Stage B2 Coeff
assign coeff_b2[0] = coeff_b2_0;
assign coeff_b2[1] = coeff_b2_1;
assign coeff_b2[2] = coeff_b2_2;
assign coeff_b2[3] = coeff_b2_3;
assign coeff_b2[4] = coeff_b2_4;
assign coeff_b2[5] = coeff_b2_5;
assign coeff_b2[6] = coeff_b2_6;
assign coeff_b2[7] = coeff_b2_7;

// FIR Coefficients
assign fir_coeff[0]   = tap_coeff_0;
assign fir_coeff[1]   = tap_coeff_1;
assign fir_coeff[2]   = tap_coeff_2;
assign fir_coeff[3]   = tap_coeff_3;
assign fir_coeff[4]   = tap_coeff_4;
assign fir_coeff[5]   = tap_coeff_5;
assign fir_coeff[6]   = tap_coeff_6;
assign fir_coeff[7]   = tap_coeff_7;
assign fir_coeff[8]   = tap_coeff_8;
assign fir_coeff[9]   = tap_coeff_9;
assign fir_coeff[10]  = tap_coeff_10;
assign fir_coeff[11]  = tap_coeff_11;
assign fir_coeff[12]  = tap_coeff_12;
assign fir_coeff[13]  = tap_coeff_13;
assign fir_coeff[14]  = tap_coeff_14;
assign fir_coeff[15]  = tap_coeff_15;
assign fir_coeff[16]  = tap_coeff_16;
assign fir_coeff[17]  = tap_coeff_17;
assign fir_coeff[18]  = tap_coeff_18;
assign fir_coeff[19]  = tap_coeff_19;
assign fir_coeff[20]  = tap_coeff_20;
assign fir_coeff[21]  = tap_coeff_21;
assign fir_coeff[22]  = tap_coeff_22;
assign fir_coeff[23]  = tap_coeff_23;
assign fir_coeff[24]  = tap_coeff_24;
assign fir_coeff[25]  = tap_coeff_25;
assign fir_coeff[26]  = tap_coeff_26;
assign fir_coeff[27]  = tap_coeff_27;
assign fir_coeff[28]  = tap_coeff_28;
assign fir_coeff[29]  = tap_coeff_29;
assign fir_coeff[30]  = tap_coeff_30;
assign fir_coeff[31]  = tap_coeff_31;

assign filter_select  = filter_sel[0];

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
control_reg control_reg (
  .clk(),
  .rst_n(),
  .write_address(),
  .write_data(),
  .write_en(),
  .read_address(),
  .read_data(),
  .coeff_a1(),
  .coeff_a2(),
  .coeff_b0(),
  .coeff_b1(),
  .coeff_b2(),
  .fir_coeff(),
  .filter_select()
);
*/

endmodule