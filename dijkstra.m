function [mydistance,mypath]=dijkstra(matrix,source,goal)
%%初始化
n=size(matrix,1); 
u=source;
parent(1:n)=0;         %节点的父节点
visited(1:n)=0;         %节点是否已经被访问
distance(1:n)=inf;    %各个节点到源点的距离
distance(source)=0;
visited(source)=1;
for i=1:n-1
    id=find(visited==0);    %未访问的节点 
    for v = id                    %这里的u更新的是路径的末端
        if distance(u)+matrix(u,v)<distance(v)  %由于distance(u)是当前的最短的所以用来更新别的点
            distance(v) = distance(u)+matrix(u,v);
            parent(v)=u;        %parent存的是前驱节点
        end
    end
    temp=distance;
    temp(visited==1)=inf;       %已经标号的距离换成无穷
    [t,u]=min(temp);                %找到标号值最小的顶点
    visited(u)=1;                       %标记已经标号的顶点
end
%% 提取起点到终点的最短路径
mypath = [];
if parent(goal)~=0                  %如果存在路
    mypath = [goal];
    t =goal;
    while t~=source
        p=parent(t);
        mypath = [p mypath];
        t=p;
    end
end
mydistance=distance(goal);