function [gridPoints] = addPatch(xv,yv,gridPoints)
%% ���ɵ�ͼ
%%% mane space
%  xv������ζ���ĺ�����
%  yv������ζ����������
%  OW��operation width����ҵ���
%  OD��operation depth����ҵ��ȣ����ȣ�

%% ��������
global OW OD 
xvLoop=[xv xv(1)];
yvLoop=[yv yv(1)];
%% Ѱ�����񻮷ֵ���ʼ�㣨xStart��yStart��
%��ʼ�㼴Ϊx����ֵ��С���Ǹ��㣬��x������С�ĵ㲻ֹһ������ȡ����y������С���Ǹ���
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
% ��xv��yv�������±�ţ�ʹ��ʼ����Ϊ1�����������ΰ���ʱ����
xv = xv([xStartNo:-1:1 end:-1:xStartNo+1]);
yv = yv([xStartNo:-1:1 end:-1:xStartNo+1]);
%% ��������
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
%% ���ͼ��
hold on;
axis equal
axis([-1 1 0 1]);
plot(xvLoop,yvLoop,'r');
plot(gridPoints(:,1),gridPoints(:,2),'.','markersize',2);
hold off;
