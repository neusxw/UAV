function  rawRoutes=UAV2(amount)
clc
close all
%% name space
%   MAXliquid        药箱最大容量
%   MAXbattery       电池最大容量
%   liquidState      药箱状态
%   batteryState     电池状态
%   idleSpeed        非作业时飞行速度
%   operationSpeed   作业时飞行速度
%   liquidPerOD         单位距离的药液消耗量
%   batteryPerOD       单位距离的电池消耗量
%%
global OW OD MAXliquid MAXbattery
global idleSpeed operationSpeed liquidPerOD batteryPerOD;
OW = 0.02;
OD = 0.02;
MAXliquid = 3;
MAXbattery =3;
idleSpeed = 0.3;
operationSpeed = 0.2;
liquidPerOD = OD*1;
batteryPerOD = OD*1;

if nargin < 1
    amount =4;
end
%% 绘制地图
origin=[-1,0];
gridPoints = [];
fill([-0.1 0.1 0.1 -0.1 ]*0.2-0.98,[0.2 0.2 0 0]*0.2,'black');
xv=[0.2 0.5 0.6 0.1];
yv=[0.7 0.8 0.3 0.4];
gridPoints = addPatch(xv,yv,gridPoints);
xv=[-0.8 -0.7 -0.3 -0.2 -0.5];
yv=[0.25  0.7 0.6 0.3 0.2];
gridPoints = addPatch(xv,yv,gridPoints);
barrier =[-0.4 0.4];
%xv=[0.8 0.95 0.85 0.7];
%yv=[0.8 0.7 0.6 0.7];
%gridPoints = addPatch(xv,yv,gridPoints);
size(gridPoints)
disp('请按任意键开始运行...')
pause;
%% 规划路径
matrixRoutes = routesPlanning(gridPoints,amount);
matrixRoutes = reshape(matrixRoutes,prod(size(matrixRoutes)),1);
minDis=inf;
for ii= 1:length(matrixRoutes)
    if ~isempty(matrixRoutes{ii})
        rawRoutes{ii}=matrixRoutes{ii};
    end
end
len = length(rawRoutes);
C=ceil(len/amount);
F=floor(len/amount);
for ii=1:amount
    if ii<=len-F*amount
        Numbering{ii}=(ii-1)*C+1:ii*C;
    else
        S=(len-F*amount)*C+(ii-1-(len-F*amount))*F;
        Numbering{ii}=S+1:S+F;
    end
end
hold on
FPS=0;
for i=1:C
    title(['第' num2str(i) '轮飞行']);
    len=0;
    for j=1:amount
        Vj=Numbering{j};
        if length(Vj)>=i &&len<size(rawRoutes{Vj(i)},1)
            len =size(rawRoutes{Vj(i)},1);
        end
    end
     for k=1:len
        FPS=FPS+1;
        %disp(['FPS:' num2str(FPS)])
        for j=1:amount
            Vj=Numbering{j};
            if length(Vj)>=i
                currentRoute = rawRoutes{Vj(i)};
            else
                continue;
            end
            num = ceil(size(currentRoute,1)/len*k);
            if num < 1 || num > size(currentRoute,1)
                continue;
            elseif num==1
                plot(currentRoute(2,1),currentRoute(2,2),'ro','LineWidth',1.5);
                plot(currentRoute(1:2,1),currentRoute(1:2,2),'r','LineWidth',1.5);
                continue;
            elseif num+1 < size(currentRoute,1)
                plot(currentRoute(num:num+1,1),currentRoute(num:num+1,2),'-b');
            else
                plot(currentRoute(end-1:end,1),currentRoute(end-1:end,2),'y','LineWidth',1.5);
                plot(currentRoute(end-1,1),currentRoute(end-1,2),'yo','LineWidth',1.5);
                continue;
                %pause(0.2);
            end
            x0=currentRoute(num,1);
            y0=currentRoute(num,2);
            rgbj=j/amount;
            fill([x0-OW/2 x0+OW/2 x0+OW/2 x0-OW/2]+rand*0.2*OW,[y0+OD/2 y0+OD/2 y0-OD/2 y0-OD/2]+rand*0.2*OD,[rgbj,rgbj,0],'edgealpha',0)
           %fill([x0-OW/2 x0+OW/2 x0+OW/2 x0-OW/2],[y0+OD/2 y0+OD/2 y0-OD/2 y0-OD/2],[rgbj,rgbj,0],'edgealpha',0)
            %plot(currentRoute(num,1),currentRoute(num,2),'o-','color',[i/size(Routes,1),0,0]);
        end
        getframe;
        %m(FPS)=getframe;
     end
    pause(2);
end
