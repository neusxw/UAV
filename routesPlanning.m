function Routes = routesPlanning(gridPoints,amount)
%% name space
%   currentPoint     当前位置
%% 初始化参数
global OW OD MAXliquid MAXbattery 
global idleSpeed operationSpeed liquidPerOD batteryPerOD;
liquidState=MAXliquid;
batteryState=MAXbattery;
origin=[-1,0]; %原点
j=1;
restGridPoints = gridPoints;
while ~isempty(restGridPoints)
    for i=1:amount
        if isempty(restGridPoints)
            break;
        end
        currentRoute=origin;
        minx = min(restGridPoints(:,1));
        XNo = find(equalTo(restGridPoints(:,1),minx));
        miny = min(restGridPoints(XNo,2));
        YNo = find(equalTo(restGridPoints(XNo,2),miny));
        currentPoint.No = XNo(YNo);
        currentPoint.XY=restGridPoints(currentPoint.No,:);
        currentPoint.Direction = 'up';
        currentRoute=[currentRoute;restGridPoints(currentPoint.No,:)];
        restGridPoints(currentPoint.No,:) =[];
        currentPoint.XY;
        len=distance(origin,currentPoint.XY);
        batteryState = batteryState-len/OD*batteryPerOD*0.1; %从工作台到作业点的电池消耗
        while  batteryState > distance(origin,currentPoint.XY) && liquidState > 0 && ~isempty(restGridPoints)
            if strcmp(currentPoint.Direction, 'up')
                nextNo = find(equalTo(restGridPoints(:,1),currentPoint.XY(1))&equalTo(restGridPoints(:,2),currentPoint.XY(2)+OD));
                if ~isempty(nextNo)
                    currentPoint.No=nextNo(1);
                    currentPoint.XY=restGridPoints(currentPoint.No,:);
                    currentRoute=[currentRoute;restGridPoints(currentPoint.No,:)];
                    restGridPoints(currentPoint.No,:) =[];
                else
                    DIS = zeros(1,size(restGridPoints,1));
                    for ii = 1:size(restGridPoints,1)
                        DIS(ii)=sqrt(sum((currentPoint.XY-restGridPoints(ii,:)).^2));
                    end
                    nextNo = find(DIS==min(DIS));
                    nextXY = restGridPoints(nextNo,:);
                    while 1
                        hasNextY = find(equalTo(restGridPoints(:,1),nextXY(1))&equalTo(restGridPoints(:,2),nextXY(2)+OD));
                        if ~isempty(hasNextY)
                            nextXY(2) = nextXY(2) + OD;
                            nextNo = hasNextY;
                        else
                            break;
                        end
                    end
                    currentPoint.No=nextNo(1);
                    currentPoint.XY=restGridPoints(currentPoint.No,:);
                    currentPoint.Direction = 'down';
                    currentRoute=[currentRoute;restGridPoints(currentPoint.No,:)];
                    restGridPoints(currentPoint.No,:) =[];
                end
            else
                nextNo = find(equalTo(restGridPoints(:,1),currentPoint.XY(1))&equalTo(restGridPoints(:,2),currentPoint.XY(2)-OD));
                if ~isempty(nextNo)
                    currentPoint.No=nextNo(1);
                    currentPoint.XY=restGridPoints(currentPoint.No,:);
                    currentRoute=[currentRoute;restGridPoints( currentPoint.No,:)];
                    restGridPoints(currentPoint.No,:) =[];
                else
                    DIS = zeros(1,size(restGridPoints,1));
                    for ii = 1:size(restGridPoints,1)
                        DIS(ii)=sqrt(sum((currentPoint.XY-restGridPoints(ii,:)).^2));
                    end
                    nextNo = find(DIS==min(DIS));
                    nextXY = restGridPoints(nextNo,:);
                    while 1
                        hasNextY = find(equalTo(restGridPoints(:,1),nextXY(1))&equalTo(restGridPoints(:,2),nextXY(2)-OD));
                        if ~isempty(hasNextY)
                            nextXY(2) = nextXY(2) - OD;
                            nextNo = hasNextY;
                        else
                            break;
                        end
                    end
                    currentPoint.No=nextNo(1);
                    currentPoint.XY=restGridPoints(currentPoint.No,:);
                    currentPoint.Direction = 'up';
                    currentRoute=[currentRoute;restGridPoints(currentPoint.No,:)];
                    restGridPoints(currentPoint.No,:) =[];
                end
            end
            batteryState = batteryState - batteryPerOD;
            liquidState = liquidState - liquidPerOD;
        end
        currentRoute =[currentRoute;origin];
        batteryState = batteryState-len/OD*batteryPerOD*0.1; %从作业点返回工作台的电池消耗
        Routes{i,j}= currentRoute;
        liquidState=MAXliquid;
        batteryState=MAXbattery;
        if isempty(restGridPoints)
            break;
        end
    end
    j=j+1;
end