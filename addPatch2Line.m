function  [Lines] = addPatch2Line(xv,yv,Lines)
%% 生成地图
%%% mane space
%  xv：多边形顶点的横坐标
%  yv：多边形顶点的纵坐标
%  OW：operation width，作业宽度
%  OD：operation depth，作业深度（精度）

%% 参数设置
global OW OD LineNum
OW=0.01;
OD=0.01;
LineNum=1;
xvLoop=[xv xv(1)];
yvLoop=[yv yv(1)];

Line.Number=0;
Line.XY=[];
Line.Neighbor={};
%% 寻找划分的起始点（xStart，yStart）
%起始点即为x坐标值最小的那个点，若x坐标最小的点不止一个，则取其中y坐标最小的那个。
xStart=min(xv);
xStartNo = find(xv == xStart);
if(length(xStartNo)>1)
    yselect = yv(xStartNo);
    yStart = min(yselect);
    %xStartNo = find(( (xv == xStart) .* (yv == yStart)) == 1 );
    xStartNo = find( (xv == xStart) & (yv == yStart));
    xStartNo = xStartNo(1);
end
% 对xv和yv进行重新编号，使起始点编号为1，其它点依次按逆时针顺序编号
xv = xv([xStartNo:-1:1 end:-1:xStartNo+1]);
yv = yv([xStartNo:-1:1 end:-1:xStartNo+1]);
%% 绘制网格线
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
    y0=y0+OD/2;%???是否需要加OD/2？
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
%% 输出图形

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