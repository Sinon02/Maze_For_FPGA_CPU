#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>

int direct[4][2] = { 1,0,-1,0,0,1,0,-1 };
struct QElemType
{
	int x;
	int y;
	int step;
};
typedef struct QNode
{
	QElemType data;
	struct QNode *next;
}QNode, *QueuePtr;
QElemType *Path;
typedef struct
{
	QueuePtr front;
	QueuePtr rear;
}LinkQueue;

int InitQueue(LinkQueue &Q)//初始化队列
{
	Q.front = Q.rear = (QueuePtr)malloc(sizeof(QNode));
	if (!Q.front) return -1;
	Q.front->next = NULL;
	return 1;
}

int EnQueue(LinkQueue &Q, QElemType e)//入队列
{
	QueuePtr p;
	p = (QueuePtr)malloc(sizeof(QNode));
	if (!p) return -1;
	p->data = e;
	p->next = NULL;
	Q.rear->next = p;
	Q.rear = p;
	return 1;
}
int DeQueue(LinkQueue &Q, QElemType &e)//出队列
{
	QueuePtr p;
	if (Q.front == Q.rear) return 0;
	p = Q.front->next;
	e.x = p->data.x;
	e.y = p->data.y;
	e.step = p->data.step;
	Q.front->next = p->next;
	if (Q.rear == p) Q.rear = Q.front;
	free(p);
	return 1;
}
int QueueEmpty(LinkQueue Q)//检查队列是否为空
{
	return (Q.front == Q.rear);
}
QueuePtr GetHead(LinkQueue Q)//获得队列的头结点
{
	return Q.front->next;
}
int QueueLength(LinkQueue Q)//获得队列长度
{
	int i = 0;
	QueuePtr p = GetHead(Q);
	while (p != NULL)
	{
		i++;
		p = p->next;
	}
	return i;
}
void Init(LinkQueue &Q, int * &Map, int* &Maze, int m, int n)//统一初始化
{
	InitQueue(Q);
	Map = (int *)malloc(m*n * sizeof(int));
	for (int i = 0; i < m; i++)
		for (int j = 0; j < n; j++)
			Map[i*n + j] = 0;
	Path = (QElemType *)malloc(m*n * sizeof(QElemType));
	Maze = (int *)malloc(m*n * sizeof(int));
}
int BFS(LinkQueue &Q, int n, int m,int *Map,int *Maze, QElemType &start, QElemType &end)//BFS算法求最短路径
{//Maze指迷宫,Map用于记录是否走过
	QElemType pos,e;
	start.step = 0;
	EnQueue(Q, start);
	pos = start;
	Map[(pos.x-1)*n+(pos.y-1)] = 1;
	while (!QueueEmpty(Q))
	{
		DeQueue(Q, e);//出队列
		if (e.x == end.x&&e.y == end.y)
			return e.step;//到达终点结束
		for (int i = 0; i < 4; i++)//四个方向均走一遍
		{
			pos.x = e.x + direct[i][0];
			pos.y = e.y + direct[i][1];
			if ((pos.x>0&&pos.x<=m)&&(pos.y>0&&pos.y<=n)&&Maze[(pos.x - 1)*n + (pos.y - 1)]&&!Map[(pos.x - 1)*n + (pos.y - 1)])
			{//第一个条件时x,y都在迷宫的范围内;第二个条件是这个位置可以走,即值为1;第三个条件是这个位置没有走过,即值为0
				pos.step = e.step + 1;//记录步数
				Map[(pos.x - 1)*n + (pos.y - 1)] = 1;//记录这个位置走过
				EnQueue(Q, pos);//入队列
				Path[(pos.x - 1)*n + (pos.y - 1)].x = e.x;//记录路径
				Path[(pos.x - 1)*n + (pos.y - 1)].y = e.y;
			}
		}
	}
	return -1;//无法找到达到终点的路径
}

int main()
{
	int m, n,i,j,result;
	int *Maze, *Map;
	LinkQueue Q;
	QElemType start, end;
	scanf("%d%d", &m, &n);
	getchar();
	Init(Q, Map, Maze, m, n);
	for (i = 0; i < m; i++)
	{
		for (j = 0; j < n; j++)
			scanf("%d", &Maze[i*n + j]);
		getchar();
	}
	scanf("%d%d", &start.x, &start.y);
	getchar();
	scanf("%d%d", &end.x, &end.y);
	getchar();
	result = BFS(Q, n, m, Map, Maze, start, end);
	if (result != -1)
	{
		QElemType *Temp = (QElemType *)malloc((result + 1) * sizeof(QElemType));
		Temp[result].x = end.x;
		Temp[result].y = end.y;
		for (i = result - 1; i >= 0; i--)
		{//递归回退,求路径
			Temp[i].x = Path[(Temp[i + 1].x - 1)*n + (Temp[i + 1].y - 1)].x;
			Temp[i].y = Path[(Temp[i + 1].x - 1)*n + (Temp[i + 1].y - 1)].y;
		}
		for (i = 0; i < result; i++)
		{
			printf("(%d,%d)->", Temp[i].x, Temp[i].y);
		}
		printf("(%d,%d)", Temp[i].x, Temp[i].y);
	}
	else
	{
		printf("-1");
	}
system("pause");
    return 0;
}

