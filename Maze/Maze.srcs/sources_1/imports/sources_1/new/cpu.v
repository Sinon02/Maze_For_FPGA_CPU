`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 15:58:29
// Design Name: 
// Module Name: cpu
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


module cpu(
    input run,
    input [7:0] addr,
    output reg [31:0] PC,
    output [31:0] mem_data,
    output [31:0] reg_data,
    input clk,
    input rst,
    output [31:0] MemData,
    output    reg [31:0] IR,
    output   reg [31:0] ALUOut,
       output     reg [3:0] currentstate,
    output reg [3:0] nextstate,
     output [31:0] ALU_a,
     output [31:0] ALU_b,
     input [13:0] data_add,
     output reg MemWrite,
     output reg [31:0] B
//    input vga_we,
//    output [31:0] vga_rd,
//    input [13:0] vga_ra,
//    input [13:0] vga_wa,
//    input [31:0] vga_wd
 );
    

    //state
    parameter Q0=4'b0000; //instruction fetch
    parameter Q1=4'b0001; //instruction decode / register fetch
    parameter Q2=4'b0010;
    parameter Q3=4'b0011;
    parameter Q4=4'b0100;
    parameter Q5=4'b0101;
    parameter Q6=4'b0110;
    parameter Q7=4'b0111;
    parameter Q8=4'b1000;
    parameter Q9=4'b1001;
    parameter Q10=4'b1010;
    parameter Q11=4'b1011;
    parameter Q_start = 4'b1100;
//    reg [3:0] currentstate;
//    reg [3:0] nextstate;
    
    //control
    reg MemRead,ALUSrcA,IorD,IRWrite,PCWrite,PCWriteCond,RegDst,RegWrite,MemtoReg;//MemWrite;
    reg [1:0] ALUSrcB,ALUOp;
    reg [1:0] PCSource;
    
    //registers
    reg [31:0] A;//,B;
    reg [31:0] MDR;//,IR,ALUOut;
    //MEM
    wire [7:0] paddr ;
    wire [31:0] pdata ;
    wire [31:0] PCData;

    assign paddr = (IorD == 0) ? PC[9:2] : ALUOut[9:2];
    
    dist_mem_gen_0   MEM (
    .a(PC[9:2]),            // input wire [7 : 0] a
    .d(B),            // input wire [31 : 0] d
    //.dpra(addr),      // input wire [7 : 0] dpra
    .clk(clk),        // input wire clk
    .we(0),          // input wire we
    //.dpo(mem_data),        // output wire [31 : 0] dpo
    .spo(PCData)             //output wire [31:0] spo
    );
    
    //存放数据的内存会被cpu和IO访问
    //当IO访问的时候发送信号
    
//    wire vga_write;
//    assign  vga_write=vga_we||MemWrite;
//    wire [31:0] vgaMem_data;
//    assign vgaMem_data=(vga_we==1)?vga_wd:B;
//    wire [13:0] vgaMem_address;
//    assign vgaMem_address=(vga_we==1)?vga_wa:ALUOut[15:2];
    
 
//  wire [31:0]MemData;
    dist_mem_gen_1 data_MEM //used for vga and maze
    (
    .a(ALUOut[15:2]),            // input wire [7 : 0] a
    .d(B),            // input wire [31 : 0] d
    .dpra({6'd0,addr}),      // input wire [7 : 0] dpra
    .clk(clk),        // input wire clk
    .we(MemWrite),          // input wire we
    .dpo(mem_data),        // output wire [31 : 0] dpo
    .spo(MemData)             //output wire [31:0] spo
    );

    //state machine
    always @(posedge clk or negedge rst)
    begin
        if(~rst)
        currentstate <= Q_start;
        else
        currentstate <= nextstate;
    end

    always @(*)
    begin
        nextstate = Q_start;
        case(currentstate)
        Q_start: begin
            if(run)
            nextstate=Q0;
            else
            nextstate=Q_start;
            end
        Q0:nextstate=Q1;
        Q1: begin
            case(IR[31:26])
            6'd0:nextstate=Q2; //R
            6'd8,6'd10,6'd12,6'd13,6'd14:nextstate=Q3; //imm
            6'd35,6'd43:nextstate=Q4; //lw sw
            6'd4,6'd5:nextstate=Q5; //beq bne
            6'd2:nextstate=Q6; //j
            endcase
            end
        Q2: nextstate=Q7;//R-type completion
        Q3: nextstate=Q8;//imm
        Q4: begin
            if(IR[31:26]==6'd35)
            nextstate=Q9;//lw
            else
            nextstate=Q10;//sw
        end
        Q5,Q6:nextstate=Q_start;
        Q7,Q8,Q10,Q11:nextstate=Q_start;
        Q9:nextstate=Q11; 

        endcase
    end
    
    always @(*)
        begin
            MemRead = 1;
            ALUSrcA = 0;
            IorD = 0;
            PCWrite = 0;
            MemWrite = 0;
            IRWrite = 0;
            RegWrite = 0;
            PCWriteCond = 0;
            PCSource = 2'b00;
            ALUSrcB = 2'b01;
            ALUOp = 2'b00;
            MemtoReg = 0;
            RegDst = 0; 
            case(currentstate)
            Q_start:
            begin
            MemRead = 1;
            ALUSrcA = 0;
            IorD = 0;
            PCWrite = 0;
            MemWrite = 0;
            IRWrite = 0;
            RegWrite = 0;
            PCWriteCond = 0;
            end
            Q0:begin
            MemRead = 1;
            ALUSrcA = 0;
            IorD = 0;
            ALUSrcB = 2'b01;
            ALUOp = 2'b00;
            PCWrite = 1;
            PCSource = 2'b00;
            MemWrite = 0;
            IRWrite = 1;
            RegWrite = 0;
            PCWriteCond=0;
            end

            Q1:begin
            ALUSrcA = 0;
            ALUSrcB = 2'b11;
            ALUOp = 2'b00;
            IRWrite = 0;
            PCWrite = 0;
            end
            
            Q2:begin
            ALUSrcA = 1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b10;
            end

            Q3:begin
            ALUSrcA = 1;
            ALUSrcB = 2'b10;
            ALUOp = 2'b10;
            end

            Q4:begin
            ALUSrcA = 1;
            ALUSrcB = 2'b10;
            ALUOp = 2'b00;           
            end

            Q5:begin
            ALUSrcA = 1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b01;
            PCSource = 2'b01;
            PCWriteCond = 1;
            end

            Q6:begin
            PCWrite = 1;
            PCSource = 2'b10;
            end

            Q7:begin
            RegDst = 1;
            RegWrite = 1;
            MemtoReg = 0;    
            end
            
            Q8:begin
            RegDst = 0;
            RegWrite = 1;
            MemtoReg = 0;    
            end
            

            Q9:begin
            MemRead = 1;
            IorD = 1;
            end

            Q10:begin
            MemWrite = 1;
            IorD = 1;
            end

            Q11:begin
            RegDst = 0;
            RegWrite = 1;
            MemtoReg = 1;
            end
            endcase

    end

    //IR
    always @(posedge clk)
    begin
        if(IRWrite)
        IR <= PCData;
    end


    // MDR
    always @(posedge clk)
    begin
        MDR <= MemData; 
    end

    //ALU
    
//    wire [31:0] ALU_a;
//    wire [31:0] ALU_b;
    wire [2:0] s;
    wire Zero;
    wire [31:0] Imm;
    wire [31:0] ALU_result;
    assign ALU_a = (ALUSrcA) ? A : PC;
    assign Imm =(IR[15]==0)?{16'd0,IR[15:0]}:{16'hffff,IR[15:0]};
    MUX_4to1 mux(.s1(B),.s2(32'd4),.s3(Imm),.s4(Imm<<2),.control(ALUSrcB),.out(ALU_b));
    ALU alu(.s(s),.a(ALU_a),.b(ALU_b),.y(ALU_result),.Zero(Zero));
    

    always @(posedge clk)
    begin
        ALUOut <= ALU_result;
    end

    //ALU Control
    wire [5:0] fun;
    assign fun = (currentstate == Q3) ? IR[31:26] : IR[5:0]; 
    ALU_control alu_control (.funct(fun),.ALUOp(ALUOp),.s(s));

    //PC
    wire [31:0] PC_MUX;
    wire zero;
    MUX_3to1 mux2(.s1(ALU_result),.s2(ALUOut),.s3({IR[31:28],IR[25:0],2'b00}),.control(PCSource),.out(PC_MUX));
    //        if(IR[31:26]==6'd5||IR[31:26]==6'd4)
    assign zero = (IR[31:26]==6'd5) ? ~Zero : Zero; 
    always @(posedge clk or negedge rst)
    begin
        if(~rst)
        PC <=0;
        else
        begin
        if(PCWrite||(zero&&PCWriteCond))
        PC <= PC_MUX;
        end
    end


    //RF
    wire [4:0] MUX_wa;
    wire [31:0] MUX_wd;
    wire [31:0] A_data,B_data;
    RF rf(.ra0(IR[25:21]),.ra1(IR[20:16]),.daddr(addr[4:0]),.wa(MUX_wa),.wd(MUX_wd),.we(RegWrite),.clk(clk),.rst(rst),.rd0(A_data),.rd1(B_data),.ddata(reg_data));
    
    always @ (posedge clk)
    begin
    A <= A_data;
    B <= B_data;
    end
    
    assign MUX_wa = (RegDst) ? IR[15:11] : IR[20:16]; //rd rt
    assign MUX_wd = (MemtoReg) ? MDR : ALUOut;

endmodule
