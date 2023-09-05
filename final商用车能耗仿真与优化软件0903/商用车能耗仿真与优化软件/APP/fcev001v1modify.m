% clear;clc
%% 修改：
%       最高车速确定电机额定功率
%       加速时间确定电机峰值功率
%       坡起确定电机峰值扭矩
%% 性能指标
global tm;
evalin('base','global tm');                                                %百公里加速时间
global Vmax;                                                               %最大车速km/h
% tgtheta=0.25;                                                            %坡起
global theta;                                                              %坡度
global L;                                                                  %WLTP目标续航里程km
global g;                                                                  %重力加速度m2/s   
global GVW;                                                                %爬坡用满载质量kg
global GVW_n;                                                              %空载质量，最高车速和续航里程算kg
global Cd;                                                                 %风阻系数,暂定
global Area;                                                                  %迎风面积 m2，暂定
global f;                                                                  %滚动阻力系数，暂定
global delta;                                                              %质量换算系数，暂定
global Vm;                                                                 %加速后期车速km/h
Vi=20;                                                                     %爬坡速度km/h，暂定
% global Vp;                                                               %爬坡达到的速度
% global tp;                                                               %达到爬坡速度所需的时间
global i0;                                                                 %主减速比
global r0;                                                                 %车轮滚动半径:m

hk=0.79;                                                                   %空载质心高度:m
global hg;                                                                 %满载质心高度:mm
global Line;                                                               %轴距:mm
global Forward;                                                            %前轴到质心距离：mm
A=245.44;
B=1.8536;
C=0.0791; 
global nt;                                                                 %效率综合值，暂定
n0=1;                                                                      %电池到电机效率，暂定
global Pa;                                                                 %附件功率 KW 
%lmada=2.5;                                                                %过载系数  
%ndoc=0.8;                                                                  %放电深度 需要匹配,暂定
nm=0.8;%电机平均效率，暂定
global Condition_Path;                                                     %工况路径
SOCint=0.95;
SOCend=0.12;
nm=0.95;%电机平均效率，暂定
nc=0.95;%逆变器平均效率，暂定
ndoc=SOCint-SOCend;
% global qianqu
% global houqu
%% 求电机相关参数
Pe=1/nt*(GVW_n*g*f*Vmax/3600+Cd*Area*Vmax^3/76140);                           %最高车速确定电机额定功率

Pi0=1/(3600*tm*nt)*(delta*GVW_n*Vm^2/7.2+GVW_n*g*f*Vm/1.5*tm+Cd*Area*Vm^3/21.15/2.5*tm); %百公里加速确定电机峰值功率

% Pi1=1/nt*(GVW*g*cos(theta)*f/3600*Vp+Cd*A/76140*Vp^3+GVW*g*sin(theta)*Vp/3600);%坡起确定电机峰值功率，根据坡道车速指标

% Pi2=1/nt/3600*(GVW*g*cos(theta)*f*Vp+GVW*g*sin(theta)*Vp+delta*GVW*(Vp/3.6/tp)*Vp);%根据坡道起步能力确定峰值功率
                                                                           %根据坡道起步性能确定峰值功率，暂定

Pi1=1/nt*((A+B*Vi+C*Vi*Vi)/3600*Vi+GVW*g*sin(atan(theta))*Vi/3600);%坡起确定电机峰值功率，根据坡道车速指标
% Pm=[Pi0,Pi1,Pi2];
Pm=[Pi0,Pi1];
Pmax=max(Pm);                                                               %确定峰值功率
backward = Line - Forward;

Tmax = (GVW * g * (backward/Line*cos(atan(theta))-hg/Line * sin(atan(theta))) * f + GVW * g * sin(atan(theta))) * r0 / nt / i0;


Tmax=((A+B*Vi+C*Vi*Vi)+GVW*g*sin(atan(theta)))*r0/nt/i0;   %求电机峰值转矩
% Tmax1=(GVW*g*f*cos(theta)+GVW*g*sin(theta)+Cd*A*(Vi/3.6)^2/21.15)*r0/nt/i0; %求电机峰值转矩
nmax=Vmax*i0/(0.3777*r0);                                                  %电机峰值转速rpm单位

%% 动力电池选型
PFCE=Pe/ndoc/nm;%燃料电池输出功率
Pbat=Pmax/ndoc/nm-PFCE;%动力电池和燃料电池共同驱动
Pimax=Pbat;
%% WLTP工况
WLTP=xlsread(Condition_Path); 
x=WLTP(:,1);
y=WLTP(:,2);
N = length(x);                                                             %总时间
W=zeros( 1, N - 1 );                                                       %每秒功率
interv_x=zeros(1,N-1 );
mid_y=zeros(1,N-1);
interv_x1=zeros(1,N-1 );
mid_y1=zeros(1,N-1);
%% 单个WLTP行程
for i = 2 : N
mid_y(i-1) = ( y(i) + y(i-1) ) / 2;
interv_x(i - 1) = x(i) - x(i-1);
end
L0 = interv_x * mid_y'/3600;                                               %一个WLTP行程Km
%% WLTP工况下的功率用功率算
for i = 2 : N
v0=y(i-1);                                                                 %1s的初始速度
v1=1/2*(y(i-1)+y(i));                                                      %1s的平均速度
t0=x(i)-x(i-1);
a=(y(i)-y(i-1))/3.6/t0;
W(i-1)=1/3600/3600/nt*v1*(GVW_n*g*f+Cd*Area*v0^2/21.15+delta*GVW_n*a);        %计算每一秒所消耗的功率即能量
end
Ws=sum(W);                                                                 %一个工况仅车辆行驶所消耗的能量kwh
n1=L/L0;                                                                   %循环次数

%% 结尾段
ans1=fix(n1);
L1=L-ans1*L0;                                                              %剩下的距离
L3=0;
for i = 2 : N
mid_y1(i-1) = ( y(i) + y(i-1) ) / 2;
interv_x1(i - 1) = x(i) - x(i-1);
L2 = interv_x1 * mid_y1'/3600;                                             %算出剩下的距离
if L2>=L1
    N1=i;                                                                  %跑完剩下距离所需时间
    break
end
end
W1=zeros( 1, N1 - 1 );                                                     %定义最后一段功率
for i = 2 : N1
v0=y(i-1);                                                                 %1s的初始速度
v1=1/2*(y(i-1)+y(i));                                                      %1s的平均速度
t0=x(i)-x(i-1);
a=(y(i)-y(i-1))/3.6/t0;
W1(i-1)=1/3600/3600/nt*v1*(GVW_n*g*f+Cd*Area*v1^2/21.15+delta*GVW_n*a);       %计算每一秒所消耗的功率即能量
end
Ws1=sum(W1);                                                               %%剩余一段所消耗能量
Wtotal=ans1*Ws/n0+Ws1/n0;                                                  %不加附件功率满足续航所需能量

W=Wtotal/(SOCint-SOCend)/nm/nc;%不加附件功率消耗能量
PFCE=Pe/ndoc/nm;%燃料电池输出功率
Pbat=Pmax/ndoc/nm-PFCE;%动力电池和燃料电池共同驱动，计算动力电池放电功率





