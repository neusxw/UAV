function  [Lines] = addPatch2Line(boundary,barrier,Lines)
%% 生成地图
%%% mane space
%  boundaryX：多边形顶点的横坐标
%  boundaryY：多边形顶点的纵坐标
%  OW：operation width，作业宽度
%  OD：operation depth，作业深度（精度）

%% 参数设置
global OW OD LineNum
OW=0.02;
OD=0.02;
LineNum=1;
boundaryX=boundary(1,:);
boundaryY=boundary(2,:);
boundaryXLoop=[boundaryX boundaryX(1)];
boundaryYLoop=[boundaryY boundaryY(1)];
% barrierX=barrier(1,:);
% barrierY=barrier(2,:);
% barrierXLoop=[barrierX barrierX(1)];
% barrierYLoop=[barrierY barrierY(1)];
Line.Number=[];
Line.XY=[];
%Line.Neighbor=[];
%% 寻找划分的起始点（xStart，yStart）
%起始点即为x坐标值最小的那个点，若x坐标最小的点不止一个，则取其中y坐标最小的那个。
xStart=min(boundaryX);
xStartNo = find(boundaryX == xStart);
if(length(xStartNo)>1)
    yselect = boundaryY(xStartNo);
    yStart = min(yselect);
    xStartNo = find( (boundaryX == xStart) & (boundaryY == yStart));
    xStartNo = xStartNo(1);
end
% 对boundaryX和boundaryY进行重新编号，使起始点编号为1，其它点依次按逆时针顺序编号
boundaryX = boundaryX([xStartNo:-1:1 end:-1:xStartNo+1]);
boundaryY = boundaryY([xStartNo:-1:1 end:-1:xStartNo+1]);
%% 绘制网格线
x0=xStart + OW/2;
for i=1:length(boundaryX)-1
    if boundaryX(i+1) < boundaryX(i)
        break;
    end
    oldLine=Line;
    dot1=[boundaryX(i),boundaryY(i)];
    dot2=[boundaryX(i+1),boundaryY(i+1)];
    y0=dotInLine(dot1,dot2,x0);
    y0=y0+OD/2;%???是否需要加OD/2？
    while x0 < boundaryX(i+1)
        newLine=Line;
        newLine.Number=LineNum;
        LineNum=LineNum+1;
        newLine.XY=[];
        %newLine.Neighbor=[oldLine.Number];
        while inpolygon(x0,y0,boundaryXLoop,boundaryYLoop)
            newLine.XY = [newLine.XY;[x0 y0]];
            y0 = y0 + OD;
        end
        Lines=[Lines;newLine];
        x0 = x0 + OW;
        y0 = dotInLine(dot1,dot2,x0);
        y0=y0+OD/2;
        %oldLine.Neighbor=[oldLine.Neighbor;newLine.Number];
        oldLine=newLine;
    end
end
newLines=[];
for i=1:size(Lines,1)
    MotherLine=Lines(i);
    XY=MotherLine.XY;
    isInBarrierBefore=1;
    isInBarrierNow=0;
    aLine=MotherLine;
    aLine.XY=[];
    for j=1:size(XY,1)
        isInBarrierNow=0;
        for k=1:size(barrier,1)
            aBarrier=barrier{k};
            barrierXLoop=[aBarrier(1,:),aBarrier(1,1)];
            barrierYLoop=[aBarrier(2,:),aBarrier(2,1)];
            if inpolygon(XY(j,1),XY(j,2),barrierXLoop,barrierYLoop)
                isInBarrierNow=1;
                break;
            end
        end
        if isInBarrierNow==1
            if isInBarrierBefore==0
                isInBarrierBefore=1;
                newLines=[newLines;aLine];
            end
        else
            if isInBarrierBefore==0
                aLine.XY=[aLine.XY;XY(j,:)];
            else
                isInBarrierBefore=0;
                aLine.XY=XY(j,:);
                aLine.Number=LineNum;
                LineNum=LineNum+1;
            end
        end
    end
    if isInBarrierBefore==0
        newLines=[newLines;aLine];
    end
end
Lines=newLines;
%% 输出图形
hold on;
axis equal
axis([-1 1 0 1]);
plot(boundaryXLoop,boundaryYLoop,'r');
for i=1:size(barrier,1)
    aBarrier=barrier{i};
    barrierXLoop=[aBarrier(1,:),aBarrier(1,1)];
    barrierYLoop=[aBarrier(2,:),aBarrier(2,1)];
    fill(barrierXLoop,barrierYLoop,'y');
end
for i=1:size(Lines,1)
    points=Lines(i).XY;
    plot(points(:,1),points(:,2),'r');
    for j=1:size(points,1)
        plot(points(j,1),points(j,2),'.');
    end
end
hold off;