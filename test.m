clc;
clear all;
close all;
xv=[0.2 0.5 0.6 0.1];
yv=[0.7 0.8 0.3 0.4];
boundary=[xv;yv];
barrier={};
aBarrier=[0.4 0.5 0.5 0.4;0.5 0.5 0.4 0.4];
barrier=[barrier;aBarrier];
aBarrier=[0.2 0.3 0.35 0.2; 0.6 0.6 0.5 0.5];
barrier=[barrier;aBarrier];
aBarrier=[-0.6 -0.4 -0.4 -0.6; 0.3 0.3 0.1 0.1];
barrier=[barrier;aBarrier];
Lines=[];
N=5;
for i=1:N
figure;
Angle=i*(pi/2)/N;
Lines=[];
Lines = addPatch2LineWithAngle(boundary,barrier,Lines,Angle);
end
%Lines = addPatch2Line(boundary,barrier,Lines);
%Lines = addPatch2LineWithAngle(boundary,barrier,Lines,Angle);
% Routes=routesPlanning2(Lines,barrier);