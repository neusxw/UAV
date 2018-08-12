function [TF,intersectionPoint]=intersectionOrNot(point1OfLine1,point2OfLine1,point1OfLine2,point2OfLine2)
p1=[point1OfLine1,point2OfLine1];
p2=[point1OfLine2,point2OfLine2];
%figure;
% hold on;
% line([point1OfLine1(1),point2OfLine1(1)],[point1OfLine1(2),point2OfLine1(2)]);
% line([point1OfLine2(1),point2OfLine2(1)],[point1OfLine2(2),point2OfLine2(2)]);
k1=(p1(2)-p1(4))/(p1(1)-p1(3));
b1=p1(2)-k1*p1(1);
k2=(p2(2)-p2(4))/(p2(1)-p2(3));
b2=p2(2)-k2*p2(1);
if k1==k2
    TF=0;
    intersectionPoint =[nan,nan];
    return;
end
if abs(k1)==inf
    if abs(k2)==inf
        TF=0;
        intersectionPoint =[nan,nan];
        return
    else
        x=p1(1);
        y=k2*x+b2;
    end
else
    if abs(k2)==inf
        x=p2(1);
        y=k1*x+b1;
    else
        x=-(b1-b2)/(k1-k2);             %����ֱ�߽���
        y=-(-b2*k1+b1*k2)/(k1-k2);
    end
end
%�жϽ����Ƿ������߶���
TF=min(p1(1),p1(3))<=x && x<=max(p1(1),p1(3)) && ...
    min(p1(2),p1(4))<=y && y<=max(p1(2),p1(4)) && ...
    min(p2(1),p2(3))<=x && x<=max(p2(1),p2(3)) && ...
    min(p2(2),p2(4))<=y && y<=max(p2(2),p2(4));
intersectionPoint =[x,y];