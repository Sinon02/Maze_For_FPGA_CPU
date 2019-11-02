`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 23:27:29
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb();

reg run;
 reg [7:0] addr;
 wire [31:0] PC;
  wire [31:0] mem_data;
 wire [31:0] reg_data;
    reg clk;
    reg rst;
    wire [31:0] MemData;
    wire [31:0] IR;
     wire [31:0] ALUOut;
     wire [3:0] currentstate;
wire [3:0] nextstate;
     wire [31:0] ALU_a;
wire [31:0] ALU_b;
reg [13:0] data_add;
   wire MemWrite;
wire [31:0] B;
//wire [31:0] vga_rd;
//reg [13:0] vga_ra;
//reg [13:0] vga_wa;
//reg [31:0] vga_wd;
//reg vga_we;
 cpu mycpu(
  run,
  addr,
 PC,
mem_data,
 reg_data,
 clk,
 rst,
 MemData,
IR,
ALUOut,
 currentstate,
nextstate,
ALU_a,
 ALU_b,
 data_add,
MemWrite,
 B
//vga_we,
// vga_rd,
//vga_ra,
//vga_wa,
// vga_wd

    //input vga_we,
    //output [31:0] vga_rd,
   // input [13:0] vga_ra,
 //   input [13:0] vga_wa,
 //   input [31:0] vga_wd
 );

always #10 clk=~clk;
initial
begin
clk=0;
rst=0;
run=1;
data_add=52;
//vga_we=0;
#10
rst=1;
addr<=8'd19;
#100000000
rst=0;
#10
rst=1;
end
endmodule
