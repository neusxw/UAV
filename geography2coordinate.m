function [x,y]=geography2coordinate(AlpahBeta,Origin) 
%%����γ��ת��Ϊƽ��ֱ������
%����
% AlpahBeta�������ľ�γ��
% Origin��ԭ��ĵľ�γ��
%���
% x�������꣨������
% y�������꣨�ϱ���

R=6371393;                     %����ƽ���뾶
%Requator=6377830;      %�������뾶
%Rpoles=63569088;        %���������뾶
alpha0=Origin(1);
beta0=Origin(2);
alpah1=AlpahBeta(1);
beta1=AlpahBeta(2);
Dalpha=alpah1-alpah0;
Dbeta=beta1-beta0;
x=R*sin(beta0)*Dalpha;
y=R*Dbeta;

