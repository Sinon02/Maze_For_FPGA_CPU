`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/10 19:11:33
// Design Name: 
// Module Name: DDU
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


module DDU(
    input cont,
    input button,
    input mem,
    input inc,
    input dec,
    input clk_100M,
    input rst,
    output reg [15:0] display,
    output reg [7:0] addr,
    output  [7:0] PC,
    input [3:0] dir,
    output vga_hs,
    output vga_vs,
    output [11:0] vrgb,
    input draw
     );
     
    wire clk_50M;
    wire locked;
    wire reset;
    clk_wiz_0 inst
   (
   // Clock out ports  
   .clk_out1(clk_50M),
   // Status and control signals               
   .reset(reset), 
   .locked(locked),
  // Clock in ports
   .clk_in1(clk_100M)
   ); 
   
   reg [24:0] d_count;
   wire clk_10M;
   wire clk_10hz;
   always @(posedge clk_50M or negedge rst)
   begin
       if(~rst)
       d_count <=25'd0;
       else if(d_count>=25'd500)
       d_count=25'd0;
       else
       d_count=d_count+25'd1;
   end
   assign clk_10M =  (d_count== 25'd1) ? 1'b1 : 1'b0;
   
   reg [24:0] d_count_10;
   always @(posedge clk_50M or negedge rst)
      begin
          if(~rst)
          d_count_10 <=25'd0;
          else if(d_count_10>=25'd5000000)
          d_count_10=25'd0;
          else
          d_count_10=d_count_10+25'd1;
      end
      assign clk_10hz =  (d_count_10== 25'd1) ? 1'b1 : 1'b0;
    

        reg run;
    always @ (posedge clk_10M or negedge rst)
    begin
       if(~rst)
       run <= 0;
       else
       begin
       if(cont == 1)
//       begin
//       if(run_cnt == 1)
//       run <= 1;
//       else
//       run <= 0;
//       end
//       else
       run <= 1;
       end
    end
     
     
     always @ (posedge clk_10hz or negedge rst)
     begin
     if(~rst)
     addr <= 0;
     else
     addr <= addr + inc - dec ;
     end
     
     wire [31:0] mem_data;
     wire [31:0] reg_data;
     wire [31:0] PC_32;
     wire [31:0] vga_rd;
     wire vga_we;
     wire [13:0] vga_ra;
     wire [13:0] vga_wa;
     wire [31:0] vga_wd;
     cpu mycpu(.run(run),
     .addr(addr),
     .PC(PC_32),
     .mem_data(mem_data),
     .reg_data(reg_data),     
     .clk(clk_10M),
     .rst(rst),
     .vga_we(draw),
     .vga_rd(vga_rd),
     .vga_ra(vga_ra),
     .vga_wa(vga_wa),
     .vga_wd(vga_wd)
     );
     wire [31:0] data;
     assign data = (mem) ? mem_data : reg_data;
     assign PC = PC_32[7:0];
     reg [7:0] an;
     wire [6:0] seg;
     reg [3:0] count;    
     reg [3:0] Q [7:0];
     
     always @(posedge clk_50M)
     begin
     Q[0] <= PC_32[3:0];
     Q[1] <= PC_32[7:4];
     Q[2] <= PC_32[11:8];
     Q[3] <= PC_32[15:12];
     Q[4] <= PC_32[19:16];
     Q[5] <= PC_32[23:20];
     Q[6] <= PC_32[27:24];
     Q[7] <= PC_32[31:28];    
     end
    
     change change1(Q[count],seg);
     always @(posedge clk_10M or negedge rst)
     begin
     if(~rst)
     begin
     display[15:0]<=16'b1111111111111111;
     count <=3'd0;
     end
     else
     begin

       display[7:0]<=8'b11111111;
       display[14:8]<=seg;
       display[15]<=1;
       display[count]<=0;       
       count <= count+1;
       if(count==8)
       count <= count-8;        
     end
     end
     
     
     VGA maze_vga(
         clk_50M,
         rst,
         dir, 
         vga_rd,
         vga_ra,
         vga_wa,
         vga_wd,
         vga_hs,
         vga_vs,
         vrgb,
         button,
         vga_we
      );
endmodule
     
     
module change(
    input [3:0] x,
    output reg [6:0] seg
     );
     always @(*)
     begin
     case (x)
     4'h0:seg = 7'b1000000;
     4'h1:seg = 7'b1111001;
     4'h2:seg = 7'b0100100;
     4'h3:seg = 7'b0110000;
     4'h4:seg = 7'b0011001;
     4'h5:seg = 7'b0010010;
     4'h6:seg = 7'b0000010;
     4'h7:seg = 7'b1111000;
     4'h8:seg = 7'b0000000;
     4'h9:seg = 7'b0010000;
     4'ha:seg = 7'b0001000;
     4'hb:seg = 7'b0000011;
     4'hc:seg = 7'b1000110;
     4'hd:seg = 7'b0100001;
     4'he:seg = 7'b0000110;
     4'hf:seg = 7'b0001110;
     endcase
     end
     endmodule