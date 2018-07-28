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
    for i=1:length(tempLines)
        [tempLen,tempLink]=distanceOfDot2Line(nowDot,tempLines(i));
        if tempLen<len
            len=tempLen;
            link=tempLink;
            lineNumber=i;
            nextDot=tempLines(lineNumber).XY(link,:);
            [isCross,index]=crossBarrierOrNot(nowDot,nextDot,barrier); %%此处待优化，未考虑复杂形状,未考虑多个交点
        end
    end
    if isCross==1
        aBarrier=barrier{index(1)};
        len=inf;
        for j=1:size(aBarrier,2)
            tempLen=distance(nowDot,aBarrier(:,j));
            if len>tempLen
                len=tempLen;
                index=j;
            end
        end
        while 1
            Routes=[Routes;aBarrier(:,index)'];
            temp={aBarrier};%将aBarrier包装为cell
            [isCross,intersectionPoint]=crossBarrierOrNot(aBarrier(:,index)',nextDot,temp)
            if isCross==1
                index=index+1;
                if index>size(aBarrier,2)
                    index=1;
                end
            else
                break;
            end
        end
    end
    if link==1
        Routes=[Routes;tempLines(lineNumber).XY];
        nowDot=tempLines(lineNumber).XY(end,:);
    else
        Routes=[Routes;flipud(tempLines(lineNumber).XY)];
        nowDot=tempLines(lineNumber).XY(1,:);
    end
    tempLines(lineNumber)=[];
end
Routes=[Routes;origin];
hold on
%plot(Routes(:,1),Routes(:,2),'-')
for i=1:size(Routes,1)-1
    plot([Routes(i,1),Routes(i+1,1)],[Routes(i,2),Routes(i+1,2)],'ro-')
    %pause(1)
    getframe;
end