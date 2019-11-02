import random
from PIL import Image
import numpy as np
row, col = 25, 25
i, j = 0, 0

status = [[[False for _ in range(4)] for _ in range(col)] 
		  for _ in range(row)]
visited = [[False for _ in range(col)] for _ in range(row)]

stack = [(i, j)]
while stack:
    visited[i][j] = True
    choosable = []
    if j > 0 and not visited[i][j-1]:
        choosable.append('L')
    if i > 0 and not visited[i-1][j]:
        choosable.append('U')
    if j < col-1 and not visited[i][j+1]:
        choosable.append('R')
    if i < row-1 and not visited[i+1][j]:
        choosable.append('D')
    if choosable:
        direct = random.choice(choosable)
        if direct == 'L':
            status[i][j][0] = True
            j -= 1
            status[i][j][2] = True
        elif direct == 'U':
            status[i][j][1] = True
            i -= 1
            status[i][j][3] = True
        elif direct == 'R':
            status[i][j][2] = True
            j += 1
            status[i][j][0] = True
        elif direct == 'D':
            status[i][j][3] = True
            i += 1
            status[i][j][1] = True
        stack.append((i, j))
    else:
        i, j = stack.pop()

maze = [[1 for _ in range(col*2+1)] for _ in range(row*2+1)]
for r in range(row):
    for c in range(col):
        cell = status[r][c]
        maze[r*2+1][c*2+1] = 0
        if cell[0]:
            maze[r*2+1][c*2] = 0
        if cell[1]:
            maze[r*2][c*2+1] = 0
        if cell[2]:
            maze[r*2+1][c*2+2] = 0
        if cell[3]:
            maze[r*2+2][c*2+1] = 0


for r in range(row*2+1):
    for c in range(col*2+1):
        print(maze[r][c], end=' ')
    print()
np_maze = np.array(maze)
np_maze =np_maze *255
np_maze_converse=(np_maze==0)*1
np.savetxt("a.txt",np_maze_converse,fmt="%d",delimiter='\n')
print(np_maze)
print(np_maze_converse)
img = Image.fromarray(np_maze.astype('uint8'))
img1=Image.fromarray((np_maze_converse*255).astype('uint8'))
img1.show()