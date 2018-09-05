function plotCircle(X,Y,R,color)
 alpha=0:pi/20:2*pi;    %½Ç¶È[0,2*pi] 
 x=R*cos(alpha)+X; 
 y=R*sin(alpha)+Y; 
 %plot(x,y,'-') 
 fill(x,y,color,'edgealpha',0);         %ÓÃºìÉ«Ìî³ä

