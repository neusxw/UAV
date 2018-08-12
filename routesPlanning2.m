function Routes = routesPlanning2(Lines,barrier)
%% name space
%
%% 初始化参数
global origin
origin=[-1,0];
tempLines=Lines;
nowDot=origin;
Routes=[nowDot];
while ~isempty(tempLines)
    len=inf;
    isCross=0;
    %% 寻找下一条最近的线
    for i=1:length(tempLines)
        [tempLen,tempLink]=distanceOfDot2Line(nowDot,tempLines(i));
        if tempLen<len
            len=tempLen;
            link=tempLink;
            lineNumber=i;
            nextDot=tempLines(lineNumber).XY(link,:);
        end
    end
    %% 避障
    [isCross,trash]=crossBarrierOrNot(nowDot,nextDot,barrier); 
    if isCross==1
        Routes=obstacleAvoidance(nowDot,nextDot,barrier,Routes);
    end
    %% 生成线路
    if link==1
        Routes=[Routes;tempLines(lineNumber).XY];
        nowDot=tempLines(lineNumber).XY(end,:);
    else
        Routes=[Routes;flipud(tempLines(lineNumber).XY)];
        nowDot=tempLines(lineNumber).XY(1,:);
    end
    tempLines(lineNumber)=[];
end
Routes=obstacleAvoidance(Routes(end,:),origin,barrier,Routes);
Routes=[Routes;origin];
%% 绘制结果
hold on
%plot(Routes(:,1),Routes(:,2),'-')
for i=1:size(Routes,1)-1
    plot([Routes(i,1),Routes(i+1,1)],[Routes(i,2),Routes(i+1,2)],'ro-')
    %pause(1)
    getframe;
end