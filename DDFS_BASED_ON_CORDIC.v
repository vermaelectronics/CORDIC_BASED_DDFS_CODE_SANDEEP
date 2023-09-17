`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2023 16:16:38
// Design Name: 
// Module Name: DDFS_BASED_ON_CORDIC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2023 09:44:08
// Design Name: 
// Module Name: DDFS_BASED_ON_CORDIC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDFS_BASED_ON_CORDIC (clock_100_MHz, FCW, clear_DDFS, COSINE_WAVE, SINE_WAVE);
   
  parameter SAN_CP = 16;          
 
  localparam STG = SAN_CP;        
  localparam VALUE = 20000/1.647; 
  input         [9:0] FCW;
  input               clock_100_MHz;
  input               clear_DDFS;
  
  wire signed  [15:0] atan_table [0:15];
  reg  signed  [SAN_CP - 1:0] Xin = VALUE; 
  reg  signed  [SAN_CP - 1:0] Yin = 0;

  output  signed      [SAN_CP-1:0]      COSINE_WAVE;
  output  signed      [SAN_CP-1:0]      SINE_WAVE;
 
assign atan_table[00] = 16'b0010000000000000; 
assign atan_table[01] = 16'b0001001011100100; 
assign atan_table[02] = 16'b0000100111111011; 
assign atan_table[03] = 16'b0000010100010001; 
assign atan_table[04] = 16'b0000001010001011;
assign atan_table[05] = 16'b0000000101000111;
assign atan_table[06] = 16'b0000000010100011;
assign atan_table[07] = 16'b0000000001010001;
assign atan_table[08] = 16'b0000000000101000;
assign atan_table[09] = 16'b0000000000010100;
assign atan_table[10] = 16'b0000000000001010;
assign atan_table[11] = 16'b0000000000000101;
assign atan_table[12] = 16'b0000000000000010;
assign atan_table[13] = 16'b0000000000000001;
assign atan_table[14] = 16'b0000000000000000; 
assign atan_table[15] = 16'b0000000000000000; 
   

  reg signed [SAN_CP-1 :0] X [0:STG-1];
  reg signed [SAN_CP-1 :0] Y [0:STG-1];
  reg signed        [15:0] Z [0:STG-1];
  
  wire [1:0] quadrant;   
  reg        [31:0] PHASE_ADDER;  
  reg signed [15:0] PHASE_IN;
  
  always @(posedge clock_100_MHz)
    begin
      if(!clear_DDFS)
        begin
          if (PHASE_ADDER < 360) 
            begin
              PHASE_IN <= ((1 << 16) * PHASE_ADDER) / 360;  
              PHASE_ADDER <= PHASE_ADDER + FCW;
            end
          else 
            begin
              PHASE_ADDER <= 0;
            end
        end
      else 
        begin
          PHASE_IN    <= 0;      
          PHASE_ADDER <= 0;
        end
    end
  assign quadrant = PHASE_IN [15:14];
  
  always @(posedge clock_100_MHz)
    begin                 
      case (quadrant)
        2'b00,
        2'b11:            
          begin           
            X[0] <= Xin;
            Y[0] <= Yin;
            Z[0] <= PHASE_IN;
          end
         
        2'b01:
          begin
            X[0] <= -Yin;
            Y[0] <= Xin;
            Z[0] <= {2'b00, PHASE_IN[13:0]}; 
          end
         
        2'b10:
          begin
            X[0] <= Yin;
            Y[0] <= -Xin;
            Z[0] <= {2'b11, PHASE_IN[13:0]}; 
          end
      endcase
    end

  genvar i;
  generate   
    for (i=0; i < (STG-1); i=i+1)
      begin
        wire Z_sign;
        wire signed  [SAN_CP-1 :0] X_shr, Y_shr; 
        
        assign X_shr = X[i] >>> i;   
        assign Y_shr = Y[i] >>> i;
        
        assign Z_sign = Z[i][15];    
        
        always @(posedge clock_100_MHz)  
        begin
          X[i+1] <= Z_sign ? X[i] + Y_shr         : X[i] - Y_shr;
          Y[i+1] <= Z_sign ? Y[i] - X_shr         : Y[i] + X_shr;
          Z[i+1] <= Z_sign ? Z[i] + atan_table[i] : Z[i] - atan_table[i];
        end
      end
  endgenerate
 
  assign COSINE_WAVE = X[STG-1];
  assign SINE_WAVE   = Y[STG-1];

endmodule