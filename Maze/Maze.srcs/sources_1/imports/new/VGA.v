`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 16:35:14
// Design Name: 
// Module Name: VGA
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


module VGA(
   input pixel_clk,
   input rst,
   input [3:0] dir, 
   input [31:0] vga_rd,
   output reg [13:0] vga_ra,
   output reg [13:0] vga_wa,
   output reg [31:0] vga_wd,
   output vga_hs,
   output vga_vs,
   output [11:0] vrgb,
   input button,
   output reg vga_we
 );
 
 //PCU
 wire reset,locked;
 wire d_clock;
 reg [24:0] d_count;
 reg [7:0] x,y;
 reg [2:0] t;
 reg [5:0] s;

always @(posedge pixel_clk or negedge rst)
begin
    if(~rst)
    d_count <=25'd0;
    else if(d_count>=25'd500000)
    d_count=25'd0;
    else
    d_count=d_count+25'd1;
end
assign d_clock =  (d_count== 25'd1) ? 1'b1 : 1'b0;
reg [5:0] count;
 always @(posedge d_clock or negedge rst )
 begin
    if(~rst)
    begin
        x <= 8'd0;
        y <= 8'd0;
        count <= 0;
    end
    else
    begin
        //dir[0]=up dir[1]=right dir[2]=down dir[3]=left
            if (~(dir==0))
            begin
                if(count == 0)
                    begin
                    x <= x + dir[1] - dir[3];
                    y <= y - dir[0] + dir[2];
                    count <= count + 1;
                    end
                else if(count < 6'd5)  //1 cycle= 0.2s 5 cycle = 1s
                    begin
                    x <= x;
                    y <= y;
                    count <= count + 1;
                    end  
                else
                    begin
                    x <= x + dir[1] - dir[3];
                    y <= y - dir[0] + dir[2];
                    end
            end
                else
                count <= 0;
     end
 end
 
 
 //VRAM
 
 wire [15:0] paddr ;
 wire [11:0] pdata ;
 wire [11:0] rgb_input;
 wire we;
 
 //assign  paddr = {y,x};
 //assign  we = draw;
 //assign  rgb_input=rgb;
 //reg [15:0] vaddr;
 //wire [11:0] vdata;
 
 
 
 // DCU
 
 
 

 //H
 parameter H_Total = 1040 - 1;
 parameter H_Sync = 120 - 1;
 parameter H_Back = 64 - 1;
 parameter H_Active = 800 - 1;
 parameter H_Front = 56 - 1;
 parameter H_Start = 184 + 100 - 1;
 parameter H_End = 984 -100 - 1;
 parameter Maze_H_Start = 184 + 196 - 1;
 parameter Maze_H_End = 984 -196 - 1;
 //V
 parameter V_Total = 666 - 1;
 parameter V_Sync = 6 - 1;
 parameter V_Back = 23 - 1;
 parameter V_Active = 600 - 1;
 parameter V_Front = 37 - 1;
 parameter V_Start = 29 + 0 - 1;
 parameter V_End =  629 - 0 - 1; 
 parameter Maze_V_Start = 29 + 96 - 1;
 parameter Maze_V_End = 629 - 96 - 1;
 
 reg [11:0] x_cnt;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
         x_cnt <= 12'd0;
     else if(x_cnt == H_Total)
         x_cnt <= 12'd0;
     else
         x_cnt <= x_cnt + 1'b1;
 end
 
 reg hsync_r;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
         hsync_r <= 1'b1;
     else if(x_cnt>=0 && x_cnt < H_Sync)
         hsync_r <= 1'b0;
     else
         hsync_r <= 1'b1;
 end
 
 reg hs_de;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
         hs_de <= 1'b0;
     else if((x_cnt>=Maze_H_Start&&x_cnt<=Maze_H_End))
         hs_de <= 1'b1;
     else
         hs_de <= 1'b0;
 end
 
 reg [11:0] y_cnt;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
         y_cnt <= 12'd0;
     else if(y_cnt == V_Total)
         y_cnt <= 12'd0;
     else if(x_cnt == H_Total)
         y_cnt <= y_cnt + 1'b1;
 end
 
 
 reg vsync_r;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
         vsync_r <= 1'b1;
     else if(y_cnt>=0 && y_cnt<V_Sync)
         vsync_r <= 1'b0;
     else
         vsync_r <= 1'b1;
 end
 
 reg vs_de;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
         vs_de <= 1'b0;
     else if((y_cnt>=Maze_V_Start)&&(y_cnt<=Maze_V_End))
         vs_de <= 1'b1;
     else
         vs_de <= 1'b0;
 end
 

 wire Cross;
assign Cross =(((x_cnt-Maze_H_Start)>>3)==x)&&(y==(y_cnt-Maze_V_Start)>>3);
 
 always @(posedge pixel_clk)
 begin
    if((x_cnt>=Maze_H_Start&&x_cnt<=Maze_H_End)&&(y_cnt>=Maze_V_Start)&&(y_cnt<=Maze_V_End))
        begin
        vga_ra <= ((y_cnt-Maze_V_Start)>>3)*51+((x_cnt-Maze_H_Start)>>3);
        end
 end
 
 
reg [24:0] run_cnt;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
     run_cnt <= 0;
     else
     begin
     if(button == 1)
     run_cnt <= run_cnt + 1;
     else
     run_cnt <= 0;
     end

 end
 
 
 always @(posedge pixel_clk or negedge rst)
 begin
      if(~rst)
      vga_we <=0;
      else
      begin
      if(run_cnt==1)
      begin
      vga_wa <= x+y*51;
      vga_wd <= 0;
      vga_we <=1;
      end
      else
      begin
      vga_we <=0;
      end
      end
    
 end
 reg [3:0] vga_r_reg;
 reg [3:0] vga_g_reg;
 reg [3:0] vga_b_reg;
 always @(posedge pixel_clk or negedge rst)
 begin
     if(~rst)
     begin
         vga_r_reg <= 4'hF;
         vga_g_reg <= 4'hF;
         vga_b_reg <= 4'hF;
     end
     else
     begin
     if(~Cross)
     begin
        if(vga_rd==32'd0)
        begin
        vga_r_reg <= 4'hF;
        vga_g_reg <= 4'hF;
        vga_b_reg <= 4'hF;
        end
        else if(vga_rd==32'd1)
        begin
        vga_r_reg <= 4'd0;
        vga_g_reg <= 4'd0;
        vga_b_reg <= 4'd0;
        end
        else if(vga_rd==32'd2)
        begin
        vga_r_reg <= 4'd13;
        vga_g_reg <= 4'd9;
        vga_b_reg <= 4'd7;
        end
        else
        begin
        vga_r_reg <= 4'd0;
        vga_g_reg <= 4'd0;
        vga_b_reg <= 4'd0;
        end
     end
    else
        begin
        vga_r_reg <= 4'd9;
        vga_g_reg <= 4'd2;
        vga_b_reg <= 4'd15;        
        end
     end
 end
 
 assign vga_hs = hsync_r;
 assign vga_vs = vsync_r;
 assign vrgb[11:8] = (hs_de & vs_de) ? vga_r_reg : 4'h0;
 assign vrgb[7:4] = (hs_de & vs_de) ? vga_g_reg : 4'h0;
 assign vrgb[3:0] = (hs_de & vs_de) ? vga_b_reg : 4'h0;
endmodule
