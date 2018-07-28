function [len,link]=distanceOfTwoLines(Line1,Line2)
dot11=Line1.XY(1,:);
dot12=Line1.XY(end,:);
dot21=Line2.XY(1,:);
dot22=Line2.XY(end,:);
len11 = distance(dot11,dot21);
len12 = distance(dot11,dot22);
len21 = distance(dot12,dot21);
len22 = distance(dot12,dot22);
[len,index]=min([len11 len12 len21 len22]);
index=index(1);
if index==1
    link=[1,1];
elseif index==2
    link=[1,size(Line2.XY,1)];
elseif index==3
    link=[size(Line1.XY,1),1];
else
     link=[size(Line1.XY,1),size(Line2.XY,1)];
end
