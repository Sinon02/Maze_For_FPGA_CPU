`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/19 15:59:03
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [2:0] s,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] y,
    output Zero);
    //f[0]=CF/VF f[1]=SV f[2]=V f[3]=Z
    //000 :add | 001 :sub |010 :slt | 100 :and | 101 :or | 110 :xor |111 :nor
    reg up,OF;
    reg [3:0] f;
    reg [31:0] result;
    always @(*)
    begin
      f=4'b0000;
      case(s)
      3'b000: 
      begin
        {up,y}=a+b;
        OF=~(a[5]^b[5])&(up^y[5]);
        f[0]=up;
        f[1]=y[5];
        f[2]=OF;
        f[3]=(y==0);
      end
      3'b001:
      begin
        {up,y}=a-b;
        OF=(a[5]^b[5])&~(up^y[5]);
        f[0]=up;
        f[1]=y[5];
        f[2]=OF;
        f[3]=(y==0);
      end
      3'b010:
      begin
      {up,result}=a-b;
       OF=(a[31]^b[31])&~(up^y[31]);
       y=(~(a[31]<b[31]))&&((a[31]>b[31])||(result[31]==1));
      end
      3'b100:
      begin
        y=a&b;
        f[3]=(y==0);
      end
      3'b101:
      begin
        y=a|b;
        f[3]=(y==0);
      end

      3'b110:
      begin
        y=a^b;
        f[3]=(y==0);
      end
      3'b111:
      begin
        y=~(a|b);
        f[3]=(y==0);
      end
      default: y=0;
      endcase
    end
    assign Zero = f[3];
endmodule



module ALU_control(
  input [5:0] funct,
  input [1:0] ALUOp,
  output reg [2:0] s
);
  always @(*)
  begin
    case (ALUOp)
    2'b00:s = 3'b000;
    2'b01:s = 3'b001;
    2'b10:
        begin
        if(funct==6'b100010)
        s = 3'b001;
        else
        s = funct[2:0];
        end
    default :s =3'b000;
    endcase
  end

endmodule