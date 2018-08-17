function  [Lines] = addPatch2LineWithAngle(boundary,barrier,Lines,Angle)
%%
%����
%Angle��ԭ�����ᵽ�����������ת�Ƕ�
%���

%% ���ɵ�ͼ
%%% mane space
%  boundaryX������ζ���ĺ�����
%  boundaryY������ζ����������
%  OW��operation width����ҵ���
%  OD��operation depth����ҵ��ȣ����ȣ�

%% ��������
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
%% Ѱ�һ��ֵ���ʼ�㣨xStart��yStart��
%�Ա߽���������任��ע���ʱ��AngleΪԭ�����ᵽ�����������ת�Ƕ�
TM=[cos(Angle),-sin(Angle);sin(Angle),cos(Angle)];
newBoundary=TM*boundary;
newBoundaryX=newBoundary(1,:);
newBoundaryY=newBoundary(2,:);
newBoundaryXLoop=[newBoundaryX newBoundaryX(1)];
newBoundaryYLoop=[newBoundaryY newBoundaryY(1)];
%��ʼ�㼴Ϊx����ֵ��С���Ǹ��㣬��x������С�ĵ㲻ֹһ������ȡ����y������С���Ǹ���
xStart=min(newBoundaryX);
xStartNo = find(newBoundaryX == xStart);
if(length(xStartNo)>1)
    yselect = newBoundaryY(xStartNo);
    yStart = min(yselect);
    xStartNo = find( (newBoundaryX == xStart) & (newBoundaryY == yStart));
    xStartNo = xStartNo(1);
end
% ��boundaryX��boundaryY�������±�ţ�ʹ��ʼ����Ϊ1�����������ΰ���ʱ��˳����
newBoundaryX = newBoundaryX([xStartNo:-1:1 end:-1:xStartNo+1]);
newBoundaryY = newBoundaryY([xStartNo:-1:1 end:-1:xStartNo+1]);
%% ����������
x0=xStart + OW/2;
for i=1:length(newBoundaryX)-1
    if newBoundaryX(i+1) < newBoundaryX(i)
        break;
    end
    oldLine=Line;
    dot1=[newBoundaryX(i),newBoundaryY(i)];
    dot2=[newBoundaryX(i+1),newBoundaryY(i+1)];
    y0=dotInLine(dot1,dot2,x0);
    y0=y0+OD/2;%???�Ƿ���Ҫ��OD/2��
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
        %�ж����ϵĵ��Ƿ����ϰ��У���Ϊ�ǣ���isInBarrierNow����1
        for k=1:size(barrier,1)
            aBarrier=barrier{k};
            barrierXLoop=[aBarrier(1,:),aBarrier(1,1)];
            barrierYLoop=[aBarrier(2,:),aBarrier(2,1)];
            %�ھ�����ϵ���жϵ��Ƿ����ϰ���
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
            % ���귴�任Ϊ������ϵ
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
    %���벻���ϰ��е����һ���ߣ����ߣ�
    if isInBarrierBefore==0
        newLines=[newLines;aLine];
    end
end
Lines=newLines;
%% ���ͼ��
hold on;
axis equal
axis([-1 1 0 1]);
plot(oldBoundaryXLoop,oldBoundaryYLoop,'r');
%�����ϰ�
for i=1:size(barrier,1)
    aBarrier=barrier{i};
    barrierXLoop=[aBarrier(1,:),aBarrier(1,1)];
    barrierYLoop=[aBarrier(2,:),aBarrier(2,1)];
    fill(barrierXLoop,barrierYLoop,'y');
end
%����������·����
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