function  [Lines] = addPatch2LineWithAngle(boundary,barrier,Lines,Angle)
%%
%输入
%Angle：原坐标轴到新坐标轴的旋转角度
%输出

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
oldBoundaryX=boundary(1,:);
oldBoundaryY=boundary(2,:);
oldBoundaryXLoop=[oldBoundaryX oldBoundaryX(1)];
oldBoundaryYLoop=[oldBoundaryY oldBoundaryY(1)];
Line.Number=[];
Line.XY=[];
%% 寻找划分的起始点（xStart，yStart）
%对边界点进行坐标变换，注意此时的Angle为原坐标轴到新坐标轴的旋转角度
TM=[cos(Angle),-sin(Angle);sin(Angle),cos(Angle)];
newBoundary=TM*boundary;
newBoundaryX=newBoundary(1,:);
newBoundaryY=newBoundary(2,:);
newBoundaryXLoop=[newBoundaryX newBoundaryX(1)];
newBoundaryYLoop=[newBoundaryY newBoundaryY(1)];
%起始点即为x坐标值最小的那个点，若x坐标最小的点不止一个，则取其中y坐标最小的那个。
xStart=min(newBoundaryX);
xStartNo = find(newBoundaryX == xStart);
if(length(xStartNo)>1)
    yselect = newBoundaryY(xStartNo);
    yStart = min(yselect);
    xStartNo = find( (newBoundaryX == xStart) & (newBoundaryY == yStart));
    xStartNo = xStartNo(1);
end
% 对boundaryX和boundaryY进行重新编号，使起始点编号为1，其它点依次按逆时针顺序编号
newBoundaryX = newBoundaryX([xStartNo:-1:1 end:-1:xStartNo+1]);
newBoundaryY = newBoundaryY([xStartNo:-1:1 end:-1:xStartNo+1]);
%% 绘制网格线
x0=xStart + OW/2;
for i=1:length(newBoundaryX)-1
    if newBoundaryX(i+1) < newBoundaryX(i)
        break;
    end
    oldLine=Line;
    dot1=[newBoundaryX(i),newBoundaryY(i)];
    dot2=[newBoundaryX(i+1),newBoundaryY(i+1)];
    y0=dotInLine(dot1,dot2,x0);
    y0=y0+OD/2;%???是否需要加OD/2？
    while x0 < newBoundaryX(i+1)
        newLine=Line;
        newLine.Number=LineNum;
        LineNum=LineNum+1;
        newLine.XY=[];
        while inpolygon(x0,y0,newBoundaryXLoop,newBoundaryYLoop)
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
        %判断线上的点是否在障碍中，若为是，则isInBarrierNow等于1
        for k=1:size(barrier,1)
            aBarrier=barrier{k};
            barrierXLoop=[aBarrier(1,:),aBarrier(1,1)];
            barrierYLoop=[aBarrier(2,:),aBarrier(2,1)];
            %在旧坐标系下判断点是否在障碍中
            tempXY=pinv(TM)*[XY(j,1);XY(j,2)];
            if inpolygon(tempXY(1),tempXY(2),barrierXLoop,barrierYLoop)
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
            % 坐标反变换为旧坐标系
            tempXY=pinv(TM)*[XY(j,1);XY(j,2)];
            tempXY=tempXY';
            if isInBarrierBefore==1
                isInBarrierBefore=0;
                aLine.XY=tempXY;
                aLine.Number=LineNum;
                LineNum=LineNum+1;
            else
                aLine.XY=[aLine.XY;tempXY];
            end
        end
    end
    %加入不在障碍中的最后一条线（顶线）
    if isInBarrierBefore==0
        newLines=[newLines;aLine];
    end
end
Lines=newLines;
%% 输出图形
hold on;
axis equal
axis([-1 1 0 1]);
plot(oldBoundaryXLoop,oldBoundaryYLoop,'r');
%绘制障碍
for i=1:size(barrier,1)
    aBarrier=barrier{i};
    barrierXLoop=[aBarrier(1,:),aBarrier(1,1)];
    barrierYLoop=[aBarrier(2,:),aBarrier(2,1)];
    fill(barrierXLoop,barrierYLoop,'y');
end
%绘制线条和路径点
for i=1:size(Lines,1)
    points=Lines(i).XY;
    getframe;
    %pause(1)
    plot(points(:,1),points(:,2),'r');
    for j=1:size(points,1)
        plot(points(j,1),points(j,2),'.');
    end
end
hold off;