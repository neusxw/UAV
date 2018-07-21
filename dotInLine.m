function y=dotInLine(dot1,dot2,x)
k=(dot2(2)-dot1(2))/(dot2(1)-dot1(1));
y=k*(x-dot1(1))+dot1(2);