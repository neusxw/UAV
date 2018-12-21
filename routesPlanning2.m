function Routes = routesPlanning2(Lines,barrier,AMOUNT)
%% name space
%
%% 初始化参数
global OD OW MAXliquid MAXbattery
global liquidPerOD batteryPerOD;
SaftyMargin=OD*10;
origin=[-1,0];
tempLines=Lines;
Routes=[];
TURN=0;
while ~isempty(tempLines)
    TURN=TURN+1;
    for M=1:AMOUNT
        liquidState=MAXliquid;
        batteryState=MAXbattery;
        nowDot=origin;
        route=[nowDot];
        while ~isempty(tempLines)
            site=size(route,1);
            len=inf;
            %% 寻找下一条最近的线
            for i=1:length(tempLines)
                [tempLen,tempLink]=distanceOfDot2Line(nowDot,tempLines(i));
                if tempLen<len
                    len=tempLen;    %当前点到线的距离
                    link=tempLink;  %线上的位置（首或尾）
                    lineNumber=i;   %第i条线
                    nextDot=tempLines(lineNumber).XY(link,:);%找到的下一个点（距离最短）
                end
            end
            %% 避障
            [isCross,trash]=crossBarrierOrNot(nowDot,nextDot,barrier);
            if isCross==1
                route=obstacleAvoidance(nowDot,nextDot,barrier,route);
            end
            %% 生成线路
            if link==1
                route=[route;tempLines(lineNumber).XY];
                nowDot=tempLines(lineNumber).XY(end,:);
            else
                route=[route;flipud(tempLines(lineNumber).XY)];
                nowDot=tempLines(lineNumber).XY(1,:);
            end
            tempLines(lineNumber)=[];
            for s=site:size(route,1)-1
                len=distance(route(s,:),route(s+1,:));
                liquidState = liquidState - len*liquidPerOD;%没有考虑在飞行过程中存在不喷药的情况
                batteryState = batteryState - len*batteryPerOD;
            end
            toOrigin=distance(nowDot,origin);
            if liquidState<toOrigin+SaftyMargin||batteryState<toOrigin+SaftyMargin
                break;
            end
        end
        route=obstacleAvoidance(route(end,:),origin,barrier,route);
        route=[route;origin];
        Routes{TURN,M}=route;
    end
end
Routes{1,1}=flipud(Routes{1,1}); %%无用
%% 绘制结果
hold on
myObj = VideoWriter('newfile');%初始化一个avi文件
writerObj.FrameRate = 30;
open(myObj);
TURN=size(Routes,1);
velocity=0.015;
nowsite=zeros(AMOUNT,2);
nowdot=nowsite;
for i=1:AMOUNT
    turn(i)=1;
    nowsite(i,:)=origin;
    mark(i)=1;
    plotRoute{i}=Routes{turn(i),i};
    nowdot(i,:)=plotRoute{i}(mark(i),:);
    nextdot(i,:)=plotRoute{i}(mark(i)+1,:);
end
for i=1:AMOUNT
    text((i-2)*0.1-0.01,0.9,[num2str(i),'#']);
end

while 1
    for i=1:AMOUNT
        rgbi=i/AMOUNT;
        len=distance(nowsite(i,:),nextdot(i,:));
        nextX=nowsite(i,1)+(nextdot(i,1)-nowsite(i,1))*velocity/len;
        nextY=nowsite(i,2)+(nextdot(i,2)-nowsite(i,2))*velocity/len;
        nextsite(i,:)=[nextX,nextY];
        if distance(nowsite(i,:),nextsite(i,:))>= distance(nowsite(i,:),nextdot(i,:));
            %plot([nowsite(i,1),nextdot(i,1)],[nowsite(i,2),nextdot(i,2)],'go-');
            x0=nowsite(i,1);
            y0=nowsite(i,2);
            panel([(i-2)*0.1,0.83],nowsite(i,:),nextsite(i,:));
            plotCircle(x0,y0,OW/2,[rgbi,rgbi,0]);
            remainVelocity=velocity-len;
            mark(i)=mark(i)+1;
            nowdot(i,:)=plotRoute{i}(mark(i),:);
            nowsite(i,:)=nowdot(i,:);
            if mark(i)==size(plotRoute{i},1)
                turn(i)=turn(i)+1;
                if turn(i)>TURN
                    continue;
                end
                plotRoute{i}=Routes{turn(i),i};
                mark(i)=1;
                nowsite(i,:)=origin;
                nowdot(i,:)=plotRoute{i}(mark(i),:);
                nextdot(i,:)=plotRoute{i}(mark(i)+1,:);
                continue;
            end
            nextdot(i,:)=plotRoute{i}(mark(i)+1,:);
            len=distance(nowdot(i,:),nextdot(i,:));
            nextX=nowsite(i,1)+(nextdot(i,1)-nowdot(i,1))*remainVelocity/len;
            nextY=nowsite(i,2)+(nextdot(i,2)-nowdot(i,2))*remainVelocity/len;
            nextsite(i,:)=[nextX,nextY];
            
        end
        %plot([nowsite(i,1),nextsite(i,1)],[nowsite(i,2),nextsite(i,2)],'go-');
        x0=nowsite(i,1);
        y0=nowsite(i,2);
        
        %fill([x0-OW/2 x0+OW/2 x0+OW/2 x0-OW/2]+rand*0.2*OW,[y0+OD/2 y0+OD/2 y0-OD/2 y0-OD/2]+rand*0.5*OD,[rgbi,rgbi,0],'edgealpha',0)
        plotCircle(x0,y0,OW/2,[rgbi,rgbi,0]);
        panel([(i-2)*0.1,0.83],nowsite(i,:),nextsite(i,:));
        nowsite(i,:)=nextsite(i,:);
    end
    if all(turn>TURN)
        break;
    end
    writeVideo(myObj,getframe);
end
close(myObj);
