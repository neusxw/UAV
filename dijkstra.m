function [mydistance,mypath]=dijkstra(matrix,source,goal)
%%��ʼ��
n=size(matrix,1); 
u=source;
parent(1:n)=0;         %�ڵ�ĸ��ڵ�
visited(1:n)=0;         %�ڵ��Ƿ��Ѿ�������
distance(1:n)=inf;    %�����ڵ㵽Դ��ľ���
distance(source)=0;
visited(source)=1;
for i=1:n-1
    id=find(visited==0);    %δ���ʵĽڵ� 
    for v = id                    %�����u���µ���·����ĩ��
        if distance(u)+matrix(u,v)<distance(v)  %����distance(u)�ǵ�ǰ����̵������������±�ĵ�
            distance(v) = distance(u)+matrix(u,v);
            parent(v)=u;        %parent�����ǰ���ڵ�
        end
    end
    temp=distance;
    temp(visited==1)=inf;       %�Ѿ���ŵľ��뻻������
    [t,u]=min(temp);                %�ҵ����ֵ��С�Ķ���
    visited(u)=1;                       %����Ѿ���ŵĶ���
end
%% ��ȡ��㵽�յ�����·��
mypath = [];
if parent(goal)~=0                  %�������·
    mypath = [goal];
    t =goal;
    while t~=source
        p=parent(t);
        mypath = [p mypath];
        t=p;
    end
end
mydistance=distance(goal);