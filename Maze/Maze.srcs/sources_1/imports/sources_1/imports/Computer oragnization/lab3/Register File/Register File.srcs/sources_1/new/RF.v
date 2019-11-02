`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/09 20:17:40
// Design Name: 
// Module Name: RF
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


module RF(
    input [4:0] ra0,
    input [4:0] ra1,
    input [4:0] daddr,
    input [4:0] wa,
    input [31:0] wd,
    input we,
    input clk,
    input rst,
    output [31:0] rd0,
    output [31:0] rd1,
    output [31:0] ddata
    );
    reg [31:0] RF [31:0];
    assign rd0 = RF[ra0];
    assign rd1 = RF[ra1];
    assign ddata = RF[daddr];
    always @ (posedge clk  or negedge rst)
    begin
    if(~rst)
    begin
    RF[0] <= 32'd0;
    RF[1] <= 32'd0;
    RF[2] <= 32'd0;
    RF[3] <= 32'd0;
    RF[4] <= 32'd0;
    RF[5] <= 32'd0;
    RF[6] <= 32'd0;
    RF[7] <= 32'd0;
    RF[8] <= 32'd0;
    RF[9] <= 32'd0;
    RF[10] <= 32'd0;
    RF[11] <= 32'd0;
    RF[12] <= 32'd0;
    RF[13] <= 32'd0;
    RF[14] <= 32'd0;
    RF[15] <= 32'd0;
    RF[16] <= 32'd0;
    RF[17] <= 32'd0;
    RF[18] <= 32'd0;
    RF[19] <= 32'd0;
    RF[20] <= 32'd0;
    RF[21] <= 32'd0;
    RF[22] <= 32'd0;
    RF[23] <= 32'd0;
    RF[24] <= 32'd0;
    RF[25] <= 32'd0;
    RF[26] <= 32'd0;
    RF[27] <= 32'd0;
    RF[28] <= 32'd0;
    RF[29] <= 32'd0;
    RF[30] <= 32'd0;
    RF[31] <= 32'd0;
    end
    else
    begin
        if(we)
            begin
                RF[wa] <= wd;
            end
    end
    end
endmodule
