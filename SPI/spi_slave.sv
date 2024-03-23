//! SPI_SLAVE module creates a customizable SPI slave interface to select sampling clock polarity and phase.
module spi_slave #(
    parameter CPOL = 0, //! IDLE Clock Polarity (0 - Low) (1 - High)
    parameter CPHA = 0  //! Sampling Clock Phase (0 - Rising) (1 - Falling)
  )(
    input   logic           clk,    //! System Clock
    input   logic           rst,    //! System Reset
    input   logic           ss,     //! Slave Select Pin
    input   logic           mosi,   //! Master Out Slave In
    output  logic           miso,   //! Master In Slave Out
    input   logic           sck,    //! Serial Clock
    output  logic           done,   //! Transaction Finished
    input   logic   [7:0]   din,    //! Data To Send Over SPI
    output  logic   [7:0]   dout    //! Data Recieved Over SPI
  );

  ////////////////////////////////////////////////////////////////
  ///////////////////////   Internal Net   ///////////////////////
  ////////////////////////////////////////////////////////////////

  // Nets for Outputs
  logic   [7:0]   dout_c, dout_r;
  logic           miso_c, miso_r;
  logic           done_c, done_r;

  // Nets for Inputs
  logic           ss_c, ss_r;
  logic           mosi_c, mosi_r;
  logic           sck_c;
  logic   [1:0]   sck_r;
  logic   [7:0]   data_c, data_r;

  // SCK Edge Detection
  logic   sck_falling;
  logic   sck_rising;

  // Misc Nets
  logic   [2:0]   bit_cnt_c, bit_cnt_r;

  ////////////////////////////////////////////////////////////////
  ///////////////////////   Module Logic   ///////////////////////
  ////////////////////////////////////////////////////////////////

  assign dout = dout_r;
  assign miso = miso_r;
  assign done = done_r;

  // Combinational Logic
  always_comb
  begin: Combinational
    ss_c        = ss;
    mosi_c      = mosi;
    miso_c      = miso_r;
    sck_c       = sck;
    data_c      = data_r;
    done_c      = 1'b0;
    bit_cnt_c   = bit_cnt_r;
    dout_c      = dout_r;

    // Use instantiation parameters to determine sampling logic
    if (~CPOL)
    begin
      if (ss_r)
      begin
        bit_cnt_c   = 3'b0;
        data_c       = din;
        miso_c      = data_r[7];
      end
      else
      begin
        if (~CPHA)
        begin
          if (sck_rising)
          begin
            data_c = {data_r[6:0], mosi_r};
            bit_cnt_c = bit_cnt_r + 1'b1;
            if (bit_cnt_r == 3'b111)
            begin
              dout_c = {data_r[6:0], mosi_r};
              done_c = 1'b1;
              data_c = din;
            end
          end
          else if (sck_falling)
          begin
            miso_c = data_r[7];
          end
        end
        else
        begin
          if (sck_falling)
          begin
            data_c = {data_r[6:0], mosi_r};
            bit_cnt_c = bit_cnt_r + 1'b1;
            if (bit_cnt_r == 3'b111)
            begin
              dout_c = {data_r[6:0], mosi_r};
              done_c = 1'b1;
              data_c = din;
            end
          end
          else if (sck_rising)
          begin
            miso_c = data_r[7];
          end
        end
      end
    end
    else
    begin
      if (~ss_r)
      begin
        bit_cnt_c   = 3'b0;
        data_c       = din;
        miso_c      = data_r[7];
      end
      else
      begin
        if (~CPHA)
        begin
          if (sck_rising)
          begin
            data_c = {data_r[6:0], mosi_r};
            bit_cnt_c = bit_cnt_r + 1'b1;
            if (bit_cnt_r == 3'b111)
            begin
              dout_c = {data_r[6:0], mosi_r};
              done_c = 1'b1;
              data_c = din;
            end
          end
          else if (sck_falling)
          begin
            miso_c = data_r[7];
          end
        end
        else
        begin
          if (sck_falling)
          begin
            data_c = {data_r[6:0], mosi_r};
            bit_cnt_c = bit_cnt_r + 1'b1;
            if (bit_cnt_r == 3'b111)
            begin
              dout_c = {data_r[6:0], mosi_r};
              done_c = 1'b1;
              data_c = din;
            end
          end
          else if (scl_rising)
          begin
            miso_c = data_r[7];
          end
        end
      end
    end
  end

  // Determine SCK Edge
  assign sck_falling = (sck_r[1] && !sck_r[0]);
  assign sck_rising = (!sck_r[1] && sck_r[0]);

  always_ff @(posedge clk)
  begin: Edge_Detection
    sck_r[0]    <= sck_c;
    sck_r[1]    <= sck_r[0];
  end

  // Sequential Logic
  always_ff @(posedge clk)
  begin: Sequential
    if (rst)
    begin
      dout_r      <= 8'b0;
      done_r      <= 1'b0;
      miso_r      <= 1'b1;
      bit_cnt_r   <= 3'b0;
    end
    else
    begin
      dout_r      <= dout_c;
      done_r      <= done_c;
      miso_r      <= miso_c;
      bit_cnt_r   <= bit_cnt_c;
    end
    mosi_r      <= mosi_c;
    ss_r        <= ss_c;
    data_r      <= data_c;
  end

  ////////////////////////////////////////////////////////////////
  //////////////////   Instantiation Template   //////////////////
  ////////////////////////////////////////////////////////////////
  /*
  spi_slave spi_slave #(
      .CPOL(),
      .CPHA()
  )(
      .clk(),
      .rst(),
      .ss(),
      .mosi(),
      .miso(),
      .sck(),
      .done(),
      .din(),
      .dout()
  );
  */
endmodule
