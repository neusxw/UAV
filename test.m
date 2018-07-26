clc;
clear all;
xv=[0.2 0.5 0.6 0.1];
yv=[0.7 0.8 0.3 0.4];
boundary=[xv;yv];
barrier=[0.4 0.5 0.5 0.4;0.5 0.5 0.4 0.4];
Lines=[];
Lines = addPatch2Line(boundary,barrier,Lines)