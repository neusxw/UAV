function [gridPoints] = addPatch(xv,yv,gridPoints)
%% 生成地图
%%% mane space
%  xv：多边形顶点的横坐标
%  yv：多边形顶点的纵坐标
%  OW：operation width，作业宽度
%  OD：operation depth，作业深度（精度）

%% 参数设置
global OW OD 
xvLoop=[xv xv(1)];
yvLoop=[yv yv(1)];
%% 寻找网格划分的起始点（xStart，yStart）
%起始点即为x坐标值最小的那个点，若x坐标最小的点不止一个，则取其中y坐标最小的那个。
xStartNo = find(xv == min(xv));
if(length(xStartNo)>1)
    yselect = yv(xStartNo);
    yStart = min(yselect);
    xStart = min(xv);
    xStartNo = find(( (xv == xStart) .* (yv == yStart)) == 1 );
    xStartNo = xStartNo(1);
else
    xStart = xv(xStartNo);
    %yStart = yv(xStartNo);
end
% 对xv和yv进行重新编号，使起始点编号为1，其它点依次按逆时针编号
xv = xv([xStartNo:-1:1 end:-1:xStartNo+1]);
yv = yv([xStartNo:-1:1 end:-1:xStartNo+1]);
%% 绘制网格
x0=xStart + OW/2;
for i=1:length(xv)-1
    if xv(i+1) < xv(i)
        break;
    end
    dot1=[xv(i),yv(i)];
    dot2=[xv(i+1),yv(i+1)];
    y0=dotInLine(dot1,dot2,x0);
    y0=y0+OD/2;
    while x0 < xv(i+1)
        while inpolygon(x0,y0,xvLoop,yvLoop)
            gridPoints = [gridPoints;[x0 y0]];
            y0 = y0 + OD;
        end
        x0 = x0 + OW;
        y0 = dotInLine(dot1,dot2,x0);
        y0=y0+OD/2;
    end
end
%% 输出图形
hold on;
axis equal
axis([-1 1 0 1]);
plot(xvLoop,yvLoop,'r');
plot(gridPoints(:,1),gridPoints(:,2),'.','markersize',2);
hold off;
