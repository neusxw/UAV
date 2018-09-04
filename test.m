clc;
clear all;
close all;
xv1=[0.2 0.5 0.6 0.1];
yv1=[0.7 0.8 0.3 0.4];
boundary1=[xv1;yv1];

xv2=[-0.9 -0.7 -0.4 -0.5 -0.8];
yv2=[0.9 0.9 0.7 0.5 0.6];
boundary2=[xv2;yv2];

barrier={};
aBarrier=[0.4 0.5 0.5 0.4;0.5 0.5 0.4 0.4];
barrier=[barrier;aBarrier];
aBarrier=[0.2 0.3 0.35 0.2; 0.6 0.6 0.5 0.5];
barrier=[barrier;aBarrier];
aBarrier=[-0.6 -0.4 -0.4 -0.6; 0.3 0.3 0.1 0.1];
barrier=[barrier;aBarrier];
aBarrier=[-0.7 -0.6 -0.6 -0.7;0.8 0.8 0.6 0.6];
barrier=[barrier;aBarrier];
Lines=[];
%Lines = addPatch2Line(boundary,barrier,Lines);
Angle=pi/3;
Lines1 = addPatch2LineWithAngle(boundary1,barrier,Angle);
Lines=[Lines;Lines1];
Lines2 = addPatch2LineWithAngle(boundary2,barrier,Angle);
Lines=[Lines;Lines2];
Routes=routesPlanning2(Lines,barrier);

