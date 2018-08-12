function Routes=obstacleAvoidance(nowDot,nextDot,barrier,Routes)
%选取结点
vertexes =[nowDot'];
for i=1:size(barrier,1)
    vertexes=[vertexes,barrier{i}];
end
vertexes =[vertexes,nextDot'];
%构造邻接矩阵
matrix=zeros(size(vertexes,2),size(vertexes,2));
for i=1:size(vertexes,2)
    for j=i+1:size(vertexes,2)
        v1=vertexes(:,i);
        v2=vertexes(:,j);
        if crossBarrierOrNot(v1',v2',barrier)==1
            %使通过障碍的路径长度为inf
            matrix(i,j)=inf;
        else
            matrix(i,j)=distance(v1,v2);
        end
    end
end
matrix=matrix+matrix';
%利用迪杰斯特拉算法计算路径
[trash,path]=dijkstra(matrix,1,size(vertexes,2));
path([1,end])=[];
Routes=cat(1,Routes,vertexes(:,path)');