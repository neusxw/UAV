function [x,y]=geography2coordinate(AlpahBeta,Origin) 
%%将经纬度转换为平面直角坐标
%输入
% AlpahBeta：待求点的经纬度
% Origin：原点的的经纬度
%输出
% x：横坐标（东西向）
% y：纵坐标（南北向）

R=6371393;                     %地球平均半径
%Requator=6377830;      %地球赤道半径
%Rpoles=63569088;        %地球两极半径
alpha0=Origin(1);
beta0=Origin(2);
alpah1=AlpahBeta(1);
beta1=AlpahBeta(2);
Dalpha=alpah1-alpah0;
Dbeta=beta1-beta0;
x=R*sin(beta0)*Dalpha;
y=R*Dbeta;

