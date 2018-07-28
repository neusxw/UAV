function [len,link]=distanceOfDot2Line(dot,Line)
len=inf;
for i=1:size(Line.XY,1)
    tempLen=distance(dot,Line.XY(i,:));
    if len>tempLen
        len=tempLen;
    end
end
dot1=Line.XY(1,:);
dot2=Line.XY(end,:);
len1 = distance(dot,dot1);
len2 = distance(dot,dot2);
[L,index]=min([len1 len2]);
index=index(1);
if index==1
    link=1;
else
    link= size(Line.XY,1);
end