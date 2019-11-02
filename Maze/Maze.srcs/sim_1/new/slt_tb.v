/*`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/31 14:12:53
// Design Name: 
// Module Name: slt_tb
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


module slt_tb();
    reg [31:0] a;
    reg [31:0] b;
    reg result;
    reg [31:0] y;
    reg OF;
    reg up;
    initial
    begin
    a=32'hffffffff;
    b=32'h0;
    #10
    result=(a<b)?1:0;
    #10
    result=(a-b)<0?1:0;
    #10
    {up,y}=a-b;
    OF=(a[31]^b[31])&~(up^y[31]);
    result=(a[31]>b[31])||(~(a[31]<b[31]))||(y[31]==1);
    #10
    y=a-b;
    result=(y<0);
    end
endmodule*/
