function panel()
center=[0.5 0.5];
bigRadius=0.5;
smallRadius=0.1;
dot1=[0 0];
dot2=[1 1];
vector=dot2-dot1;
vector=vector/sqrt(vector(1)^2+vector(2)^2);
XY=center+vector*bigRadius-smallRadius;
plotCircle(center,bigRadius,[1 1 1])
hold on
plotCircle(center,smallRadius,[0 0 0])
plotCircle(XY,smallRadius,[1 0 0])
end

function plotCircle(XY,R,C)
X=XY(1);
Y=XY(2);
alpha=0:pi/20:2*pi;    %½Ç¶È[0,2*pi] 
 x=R*cos(alpha)+X; 
 y=R*sin(alpha)+Y; 
 plot(x,y,'-') 
 fill(x,y,C);   
end