clc;
clear all;
close all;
figure;
hold on;
axis equal
axis([-1 1 0 1]);
xv1=[0.2 0.6 0.7 0.1 0.2];
yv1=[0.7 0.75 0.3 0.4 0.7];
plot(xv1,yv1);
xv2=[-0.9 -0.7 -0.3 -0.4 -0.8 -0.9];
yv2=[0.9 0.9 0.7 0.5 0.6 0.9];
plot(xv2,yv2);

aBarrier=[0.4 0.5 0.5 0.4;0.5 0.5 0.4 0.4];
fill(aBarrier(1,:),aBarrier(2,:),'y');
aBarrier=[0.2 0.3 0.35 0.2; 0.6 0.6 0.5 0.5];
fill(aBarrier(1,:),aBarrier(2,:),'y');
aBarrier=[-0.6 -0.4 -0.4 -0.6; 0.3 0.3 0.1 0.1];
fill(aBarrier(1,:),aBarrier(2,:),'y');
aBarrier=[-0.7 -0.6 -0.6 -0.7;0.8 0.8 0.6 0.6];
fill(aBarrier(1,:),aBarrier(2,:),'y');

station=[-0.1 0.1 0.1 -0.1;0.05 0.05 0 0];
fill(station(1,:),station(2,:),'g');
a=load('D:\github\Java\JavaUAV\output\linesOut.txt');
for i=1:size(a,1)
    plot([a(i,1) a(i,3)],[a(i,2) a(i,4)])
end
b=load('D:\github\Java\JavaUAV\output\pointsOut.txt');
for i=1:size(b,1)
    plot(b(i,1),b(i,2),'r*');
end
%plot([-0.60,-0.7],[0.96,1.06],'r');
for i=1:size(b,1)-1
   % plot([b(i,1),b(i+1,1)],[b(i,2),b(i+1,2)],'r','LineWidth',2);
    %getframe;
    %pause(0.1);
end