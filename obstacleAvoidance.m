function Routes=obstacleAvoidance(nowDot,nextDot,barrier,Routes)
%ѡȡ���
vertexes =[nowDot'];
for i=1:size(barrier,1)
    vertexes=[vertexes,barrier{i}];
end
vertexes =[vertexes,nextDot'];
%�����ڽӾ���
matrix=zeros(size(vertexes,2),size(vertexes,2));
for i=1:size(vertexes,2)
    for j=i+1:size(vertexes,2)
        v1=vertexes(:,i);
        v2=vertexes(:,j);
        if crossBarrierOrNot(v1',v2',barrier)==1
            %ʹͨ���ϰ���·������Ϊinf
            matrix(i,j)=inf;
        else
            matrix(i,j)=distance(v1,v2);
        end
    end
end
matrix=matrix+matrix';
%���õϽ�˹�����㷨����·��
[trash,path]=dijkstra(matrix,1,size(vertexes,2));
path([1,end])=[];
Routes=cat(1,Routes,vertexes(:,path)');