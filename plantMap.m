function [points] = plantMap(map)
%% mane space
%  xv������ζ���ĺ�����
%  yv������ζ����������
%  OW��operation width����ҵ���
%  OD��operation depth����ҵ��ȣ����ȣ�
% plot([0 1 2 3 0],[4 4 1 9 4],'color','red');
%% ���ɵ�ͼ
global OW OD ;
xv=[0.2 0.5 0.6 0.1];
yv=[0.7 0.7 0.2 0.1];
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
x0=xStart + OD/2;
gridPoint = [];
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
            gridPoint = [gridPoint;[x0 y0]];
            y0 = y0 + OD;
        end
        x0 = x0 + OW;
        y0 = dotInLine(dot1,dot2,x0);
        y0=y0+OD/2;
    end
end
axis([0 1 0 1]);
hold on;
plot(xvLoop,yvLoop,'r');
plot(gridPoint(:,1),gridPoint(:,2),'.');
hold off;
