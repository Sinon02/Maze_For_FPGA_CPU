`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/07 16:24:50
// Design Name: 
// Module Name: MUX
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


module MUX_4to1(
    input [31:0] s1,
    input [31:0] s2,
    input [31:0] s3,
    input [31:0] s4,
    input [1:0] control,
    output reg [31:0] out
    );

    always @(*)
    begin
        case(control)
        2'b00:out=s1;
        2'b01:out=s2;
        2'b10:out=s3;
        2'b11:out=s4;
        endcase
    end
endmodule


module MUX_3to1(
    input [31:0] s1,
    input [31:0] s2,
    input [31:0] s3,
    input [1:0] control,
    output reg [31:0] out
    );

    always @(*)
    begin
        case(control)
        2'b00:out=s1;
        2'b01:out=s2;
        2'b10:out=s3;
        default:out=0;
        endcase
    end
endmodule
