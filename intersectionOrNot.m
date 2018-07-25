function TF=intersectionOrNot(point1OfLine1,point2OfLine1,point1OfLine2,point2OfLine2)
p1=[point1OfLine1(1),point1OfLine1(2),point2OfLine1(1),point2OfLine1(2)];
p2=[point1OfLine2(1),point1OfLine2(2),point2OfLine2(1),point2OfLine2(2)];
figure;
hold on;
line([point1OfLine1(1),point2OfLine1(1)],[point1OfLine1(2),point2OfLine1(2)]);
line([point1OfLine2(1),point2OfLine2(1)],[point1OfLine2(2),point2OfLine2(2)]);

k1=(p1(2)-p1(4))/(p1(1)-p1(3));
b1=p1(2)-k1*p1(1);
k2=(p2(2)-p2(4))/(p2(1)-p2(3));
b2=p2(2)-k2*p2(1);

x=-(b1-b2)/(k1-k2);             %求两直线交点
y=-(-b2*k1+b1*k2)/(k1-k2);
%判断交点是否在两线段上
if min(p1(1),p1(3))<=x && x<=max(p1(1),p1(3)) && ...
        min(p1(2),p1(4))<=y && y<=max(p1(2),p1(4)) && ...
        min(p2(1),p2(3))<=x && x<=max(p2(1),p2(3)) && ...
        min(p2(2),p2(4))<=y && y<=max(p2(2),p2(4))
    plot(x,y,'.');
end
TF=min(p1(1),p1(3))<=x && x<=max(p1(1),p1(3)) && ...
        min(p1(2),p1(4))<=y && y<=max(p1(2),p1(4)) && ...
        min(p2(1),p2(3))<=x && x<=max(p2(1),p2(3)) && ...
        min(p2(2),p2(4))<=y && y<=max(p2(2),p2(4));