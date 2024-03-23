//SPI system interface for FIR filter chip 
//This will be used as a means of communicating to an external MCU
//The main purpose of this interface for the chip is to load 32 registers 
//Data is processed as MSB first 

// SPI write should work as follows
//			byte 1: preamble for write 
//			byte 2: register value to write to 
//			byte 3+4: values to be writen to reg

// SPI read should work as follows
//			byte 1: preamble for read 
//			byte 2: register value to read from 
//			byte 3+4: values to be read and sent through MOSI

module SPI(
	input logic SCK,
	input logic CS, 
	input logic MOSI,
  input logic Reset,
	output logic MISO,
	output logic load,
	output logic [7:0] register_address,
	output logic [15:0] register_value,
	output logic [7:0] read_address,
	input logic [15:0] read_value
);
 
parameter [7:0] 	incoming_write = 8'hFB; 
parameter [7:0]		incoming_read = 8'hFC;

logic [7:0] byte_received, store1, store2, store3;
logic [3:0] count_bits;
logic [1:0] byte_count;
logic [15:0] MISO_reg; 
logic reading, writing, read_que; 
logic begin_count, load_reg;

always_ff @(negedge SCK or posedge Reset) begin
///data will be clocked at CS = '0' 
  if (Reset) begin
    MISO          <= '0;
    load_reg      <= '0;
    store3        <= '0;
    store2        <= '0;
    store1        <= '0;
    read_address  <= '0;
  end
  else begin
    if(CS) begin 
      byte_received <= 8'd0;
      begin_count <= 1'b0;
      count_bits <= 4'd0;
      byte_count <= 2'b0; 
      load_reg <= 1'b0;
      writing <= 1'b0;
      reading <= 1'b0;
      read_que <= 1'b0; 
    end else begin 
      load_reg <= 1'b0;
      byte_received <= {byte_received[6:0], MOSI};
      MISO_reg <= {MISO_reg[14:0], 1'b0}; 
      MISO <= MISO_reg[15]; 
    
      if(read_que) begin 
        read_que <= 1'b0; 
        MISO_reg <= read_value;
      end
      
      if(begin_count == 1'b1) begin 
        count_bits <= count_bits + 1'b1; 
      end if(byte_count == 2'd3) begin 
        begin_count <= 1'b0; 
        byte_count <= 2'd0;
        if (writing == 1'b1) begin 
          load_reg <= 1'b1;
          writing <= 1'b0; 
        end
      end else if(byte_received == incoming_write && begin_count <= 1'b0) begin 
        begin_count <= 1'b1; 
        writing <= 1'b1; 
        store1 <= 8'd0;
        store2 <= 8'd0;
        store3 <= 8'd0;
      end else if(byte_received == incoming_read && begin_count <= 1'b0) begin 
        reading <= 1'b1; 
        begin_count <= 1'b1; 
      end
      
      if (count_bits == 4'd7 && writing == 1'b1) begin 
        store1 <= byte_received;
        store2 <= store1;
        store3 <= store2;
        byte_count <= byte_count + 1'b1; 
        count_bits <= 4'd0; 
      end else if (count_bits == 4'd7 && reading == 1'b1) begin 
        reading <= 1'b0; 
        read_address <= byte_received;
        read_que <= 1'b1; 
        byte_count <= byte_count + 1'b1; 
        count_bits <= 4'd0; 
      end else if (count_bits == 4'd7) begin 
        byte_count <= byte_count + 1'b1; 
        count_bits <= 4'd0; 
      end
    end
	end
end 



always_comb begin
	register_address <= store3; 
	register_value <= {store2, store1};
	load <= load_reg; 
end



endmodule