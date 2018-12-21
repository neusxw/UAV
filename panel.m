function panel(center,dot1,dot2)
bigRadius=0.045;
smallRadius=0.01;
vector=dot2-dot1;
vector=vector/sqrt(vector(1)^2+vector(2)^2);
XY=center+vector*(bigRadius-smallRadius);
hold on
plotCircle(center,bigRadius,[1 1 1],1);
plotCircle(center,smallRadius,[0 0 0],0);
plotCircle(XY,smallRadius,[1 0 0],0);
end

function plotCircle(XY,R,C,edge)
X=XY(1);
Y=XY(2);
alpha=0:pi/20:2*pi;    %½Ç¶È[0,2*pi] 
 x=R*cos(alpha)+X; 
 y=R*sin(alpha)+Y; 
 %plot(x,y,'-') 
 fill(x,y,C,'edgealpha',edge);   
end