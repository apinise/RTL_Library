module seven_seg(
  input             clk,
  input             reset_n,
  input       [3:0] dispA,    //dispA is left most
  input       [3:0] dispB,    //midleft
  input       [3:0] dispC,    //midright
  input       [3:0] dispD,    //rightmost
  output  reg [6:0] seg,
  output  reg [3:0] an
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

localparam  D_MAX_COUNT = 16'd31_249; //320Hz clk for display

//create states for mux 7 seg anodes
localparam  LEFT=2'b00, 
            MIDLEFT=2'b01, 
            MIDRIGHT=2'b10, 
            RIGHT=2'b11;
            
//cathode seg values for bcd output
localparam  ZERO  = 7'b0000001, 
            ONE   = 7'b1001111, 
            TWO   = 7'b0010010, 
            THREE = 7'b0000110,
            FOUR  = 7'b1001100, 
            FIVE  = 7'b0100100, 
            SIX   = 7'b0100000, 
            SEVEN = 7'b0001111,
            EIGHT = 7'b0000000, 
            NINE  = 7'b0001100, 
            A     = 7'b0001000, 
            B     = 7'b1100000,
            C     = 7'b0110001, 
            D     = 7'b1000010, 
            E     = 7'b0110000, 
            F     = 7'b0111000;

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

wire update_disp;

reg [3:0] dispout;
reg [15:0] count_value;
reg [1:0] state = LEFT;

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

//counter flag for alternating anode
assign update_disp = (count_value == D_MAX_COUNT) ? 1'b1 : 1'b0;

//200Hz synchronous clk
always @(posedge clk)
begin
  if (reset_n == 1'b0) begin
    count_value <= 16'd0;
  end
  else if (count_value == D_MAX_COUNT) begin
    count_value <= 16'd0;
  end
  else begin
    count_value <= count_value + 17'd1;
  end
end

always @(posedge clk) begin
  if (reset_n == 1'b0) begin //reset regs on clk reset and setting default state
    an      <= 4'b1111;
    seg     <= 7'b1111111;
    dispout <= 4'b0000;
    state   <= LEFT;
  end
  else if (update_disp == 1'b1) begin
    case (dispout) //7seg BCD decoder using active low 
      4'b0000: seg <= ZERO; //active low logic here, this displays zero on the seven segment
      4'b0001: seg <= ONE; //"1"
      4'b0010: seg <= TWO; //"2"
      4'b0011: seg <= THREE; //3
      4'b0100: seg <= FOUR; //4
      4'b0101: seg <= FIVE; //5
      4'b0110: seg <= SIX; //6
      4'b0111: seg <= SEVEN; //7               
      4'b1000: seg <= EIGHT; //8
      4'b1001: seg <= NINE; //9
      4'b1010: seg <= A; //A
      4'b1011: seg <= B; //B
      4'b1100: seg <= C; //C
      4'b1101: seg <= D; //D
      4'b1110: seg <= E; //E
      4'b1111: seg <= F; //F
    endcase
    case (state) //dispout is set in previous state because of bcd decoder coming first
      LEFT:
      begin
        dispout <= dispB;   //set disp value
        an      <= 4'b0111; //set active anode
        state   <= MIDLEFT; //change state
      end
      MIDLEFT:
      begin
        dispout <= dispC;     //set disp value
        an      <= 4'b1011;   //set active anode
        state   <= MIDRIGHT;  //change state
      end
      MIDRIGHT:
      begin
        dispout <= dispD;   //set disp value
        an      <= 4'b1101; //set active anode
        state   <= RIGHT;   //change state
      end 
      RIGHT:
      begin
        dispout <= dispA;   //set disp value
        an      <= 4'b1110; //set active anode
        state   <= LEFT;    //change state
      end
    endcase
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////

/*
seven_seg seven_seg_inst(
    .dispA(),
    .dispB(),
    .dispC(),
    .dispD(),
    .clk(),
    .reset_n(),
    .seg(),
    .an()
);
*/

endmodule
