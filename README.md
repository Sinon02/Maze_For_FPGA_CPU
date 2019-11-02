# Maze_For_FPGA_CPU
很早之前写的实验，作为组原最后的实验设计。

大致思路是利用已经实现的MIPS-CPU，通过写出汇编形式的BFS算法，找出给定迷宫的最短路径。



## 运行环境

Vivado 2018.2

Mars（如果想试一试编译汇编）



## 文件说明

| 文件（夹）路径 | 说明                                           |
| -------------- | ---------------------------------------------- |
| ./C/           | BFS寻找最短路径的C实现                         |
| ./C/data       | 可以用于测试BFS的迷宫数据                      |
| ./Maze/        | 迷宫的verilog实现                              |
| ./data.coe     | CPU读入的迷宫数据                              |
| ./in.coe       | 汇编的机器码形式                               |
| ./maze.py      | 这两个py文件都是在网上找到的用于生成迷宫的代码 |
| ./getmaze.py   | 但是由于都是转载的所以找不到原作者……仅供参考   |
| ./Maze.asm     | 迷宫的汇编实现，使用MIPS汇编                   |
| ./Photo        | 整体结构，存储器空间分配以及结果展示           |
| ./MIPS-CPU     | 如果对MIPS-CPU不了解可以参考下                 |



**本来是有一份实验报告的，但是我看了一下，那个报告写的太繁琐且贴代码占据大量空间（终于知道为什么实验报告给我扣了一分了2333），所以不放出来丢人了。**