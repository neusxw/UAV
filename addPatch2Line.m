function  [Lines] = addPatch2Line(xv,yv,Lines)
%% ���ɵ�ͼ
%%% mane space
%  xv������ζ���ĺ�����
%  yv������ζ����������
%  OW��operation width����ҵ���
%  OD��operation depth����ҵ��ȣ����ȣ�

%% ��������
global OW OD LineNum
OW=0.01;
OD=0.01;
LineNum=1;
xvLoop=[xv xv(1)];
yvLoop=[yv yv(1)];

Line.Number=0;
Line.XY=[];
Line.Neighbor={};
%% Ѱ�һ��ֵ���ʼ�㣨xStart��yStart��
%��ʼ�㼴Ϊx����ֵ��С���Ǹ��㣬��x������С�ĵ㲻ֹһ������ȡ����y������С���Ǹ���
xStart=min(xv);
xStartNo = find(xv == xStart);
if(length(xStartNo)>1)
    yselect = yv(xStartNo);
    yStart = min(yselect);
    %xStartNo = find(( (xv == xStart) .* (yv == yStart)) == 1 );
    xStartNo = find( (xv == xStart) & (yv == yStart));
    xStartNo = xStartNo(1);
end
% ��xv��yv�������±�ţ�ʹ��ʼ����Ϊ1�����������ΰ���ʱ��˳����
xv = xv([xStartNo:-1:1 end:-1:xStartNo+1]);
yv = yv([xStartNo:-1:1 end:-1:xStartNo+1]);
%% ����������
x0=xStart + OW/2;
for i=1:length(xv)-1
    if xv(i+1) < xv(i)
        break;
    end
    i
    oldLine=Line;
    dot1=[xv(i),yv(i)];
    dot2=[xv(i+1),yv(i+1)];
    y0=dotInLine(dot1,dot2,x0);
    y0=y0+OD/2;%???�Ƿ���Ҫ��OD/2��
    while x0 < xv(i+1)
        newLine=Line;
        newLine.Number=LineNum;
        LineNum=LineNum+1;
        newLine.XY=[];
        newLine.Neighbor=[oldLine];
        while inpolygon(x0,y0,xvLoop,yvLoop)
            newLine.XY = [newLine.XY;[x0 y0]];
            y0 = y0 + OD;
        end
        Lines=[Lines;newLine]
        x0 = x0 + OW;
        y0 = dotInLine(dot1,dot2,x0);
        y0=y0+OD/2;
        oldLine.Neighbor=[oldLine.Neighbor;newLine];
        oldLine=newLine;
    end
end
%% ���ͼ��

hold on;
axis equal
axis([-1 1 0 1]);
plot(xvLoop,yvLoop,'r');
for i=1:size(Lines,1)
    points=Lines(i).XY;
    for j=1:size(points,1)
        plot(points(j,1),points(j,2));
    end
end
% plot(gridPoints(:,1),gridPoints(:,2),'.','markersize',2);
% hold off;