clc;
clear all;
figure
xv=[0.2 0.5 0.6 0.1];
yv=[0.7 0.8 0.3 0.4];
boundary=[xv;yv];
barrier={};
aBarrier=[0.4 0.5 0.5 0.4;0.5 0.5 0.4 0.4];
barrier=[barrier;aBarrier];
aBarrier=[0.2 0.3 0.35 0.2; 0.6 0.6 0.5 0.5];
barrier=[barrier;aBarrier];
Lines=[];
Lines = addPatch2Line(boundary,barrier,Lines);
Routes=routesPlanning2(Lines,barrier);
