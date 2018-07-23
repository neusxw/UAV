function  rawRoutes=UAV2(amount)
clc
close all
%% name space
%   MAXliquid        ҩ���������
%   MAXbattery       ����������
%   liquidState      ҩ��״̬
%   batteryState     ���״̬
%   idleSpeed        ����ҵʱ�����ٶ�
%   operationSpeed   ��ҵʱ�����ٶ�
%   liquidPerOD         ��λ�����ҩҺ������
%   batteryPerOD       ��λ����ĵ��������
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
%% ���Ƶ�ͼ
origin=[-1,0];
gridPoints = [];
fill([-0.1 0.1 0.1 -0.1 ]*0.2-0.98,[0.2 0.2 0 0]*0.2,'black');
xv=[0.2 0.5 0.6 0.1];
yv=[0.7 0.8 0.3 0.4];
gridPoints = addPatch(xv,yv,gridPoints);
xv=[-0.8 -0.7 -0.3 -0.2 -0.5];
yv=[0.25  0.7 0.6 0.3 0.2];
gridPoints = addPatch(xv,yv,gridPoints);
%xv=[0.8 0.95 0.85 0.7];
%yv=[0.8 0.7 0.6 0.7];
%gridPoints = addPatch(xv,yv,gridPoints);
disp('�밴�������ʼ����...')
pause;
%% �滮·��
matrixRoutes = routesPlanning(gridPoints,amount)
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
%% �����ʾ
hold on
FPS=0;
for i=1:C
    title(['��' num2str(i) '�ַ���']);
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
%             if k == 1
%                  plot(currentRoute(2,1),currentRoute(2,2),'ro','LineWidth',2);
%                  plot(currentRoute(1:2,1),currentRoute(1:2,2),'b','LineWidth',1.5);
%                  continue;
%             elseif k == length(currentRoute)
%                 plot(currentRoute(end-1:end,1),currentRoute(end-1:end,2),'y','LineWidth',1.5);
%                 plot(currentRoute(end-1,1),currentRoute(end-1,2),'rx','LineWidth',3);
%                 continue;
%             elseif k > length(currentRoute)
%                 continue;
%             else
%                 plot(currentRoute(k:k+1,1),currentRoute(k:k+1,2),'-b');
%             end
            num = ceil(size(currentRoute,1)/len*k);
            if num < 1 || num > size(currentRoute,1)
                continue;
            elseif num==1
                plot(currentRoute(2,1),currentRoute(2,2),'ro','LineWidth',2);
                plot(currentRoute(1:2,1),currentRoute(1:2,2),'b','LineWidth',1.5);
                continue;
            elseif num+1 < size(currentRoute,1)
                plot(currentRoute(num:num+1,1),currentRoute(num:num+1,2),'-b');
            else
                plot(currentRoute(end-1:end,1),currentRoute(end-1:end,2),'y','LineWidth',1.5);
                plot(currentRoute(end-1,1),currentRoute(end-1,2),'rx','LineWidth',3);
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
    pause(1);
end
