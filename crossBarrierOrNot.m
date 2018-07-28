function  [isCross,index]=crossBarrierOrNot(dot1,dot2,barrier)
isCross=0;
for i=1:size(barrier,1)
    aBarrier=barrier{i};
    aBarrierLoop=[aBarrier,aBarrier(:,1)];
    for j=1:size(aBarrier,2)
        [isCross,intersectionPoint]=intersectionOrNot(dot1,dot2,aBarrierLoop(:,j),aBarrierLoop(:,j+1));
        if equalTo(intersectionPoint,dot1)||equalTo(intersectionPoint,dot2)
            isCross=0;
        end
        index=i;
        if isCross==1
            break;
        end
    end
    if isCross==1
        break;
    end
end