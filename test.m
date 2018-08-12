clc;
clear all;
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
Lines = addPatch2Line(boundary,barrier,Lines);
Routes=routesPlanning2(Lines,barrier);
% nowDot =[-1,0];
% nextDot =[0.1100,0.4080];
%[isCross,trash]=crossBarrierOrNot(nowDot,nextDot,barrier)
% a=[-0.6 0.3];
% b=[-0.4 0.3];
% c=[-0.4 0.1];
% d=[-0.6 0.1];
% [tf,w]=intersectionOrNot(nowDot,nextDot,a,b)
% plot(w(1),w(2),'ro')
% hold on
% [tf,w]=intersectionOrNot(nowDot,nextDot,b,c)
% plot(w(1),w(2),'ro')
% axis([-1 1 -1 1])
% [tf,w]=intersectionOrNot(nowDot,nextDot,c,d)
% plot(w(1),w(2),'ro')
% [tf,w]=intersectionOrNot(nowDot,nextDot,d,a)
% plot(w(1),w(2),'ro')
% % figure
% % [tf,w]=intersectionOrNot([0 0],[1 1],[0 1],[1 0])
% % plot(w(1),w(2),'ro')