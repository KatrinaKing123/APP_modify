
%% 修改：
%       最高车速确定电机额定功率
%       加速时间确定电机峰值功率
%       坡起确定电机峰值扭矩
%% 性能指标
%tm=21;                                                                    %百公里加速时间
%Vmax=130;                                                                 %最大车速km/h
tgtheta=0.25;                                                              %坡起
%theta=atan(tgtheta);                                                      %坡度
global L;                                                                  %WLTP目标续航里程km
g=9.81;                                                                    %重力加速度m2/s   
GVW=4250;                                                                  %爬坡用满载质量kg
GVW_n=2681+100;                                                            %空载质量，最高车速和续航里程算kg
Cd=0.31;                                                                   %风阻系数,暂定
A=2.22;                                                                    %迎风面积 m2，暂定
f=0.01;                                                                    %滚动阻力系数，暂定
delta=1.08;                                                                %质量换算系数，暂定
Vm=100;                                                                    %加速后期车速km/h
Vi=20;                                                                     %爬坡速度km/h，暂定
Vp=5;                                                                      %爬坡达到的速度
tp=1;                                                                      %达到爬坡速度所需的时间
i0=15.046;                                                                 %主减速比
r0=0.346;                                                                  %车轮滚动半径:m

hk=0.79;                                                                   %空载质心高度:m
hm=0.88;                                                                   %满载质心高度:m
lz=3.76;                                                                   %轴距:m
nt=0.95;                                                                   %效率综合值，暂定
n0=1;                                                                      %电池到电机效率，暂定
Pa=5+5+7;                                                                  %附件功率 KW 
%lmada=2.5;                                                                %过载系数  
ndoc=0.8;%放电深度 需要匹配,暂定

syms Vmax
Pe=31.27;                                                                  %电机额定功率
eqn=1/nt*(GVW_n*g*f*Vmax/3600+Cd*A*Vmax^3/76140)-Pe==0;   %电机额定功率确定最高车速
S1=vpasolve(eqn,Vmax);
Vmax1=S1(1)                                                               %最高车速KM/h

syms tm
% Pmax=15.3773;                                                              %电机峰值功率
Pmax = 67.21;                                                              % 电机峰值功率
eqn2=Pmax==1/(3600*tm*nt)*(delta*GVW_n*Vm^2/7.2+GVW_n*g*f*Vm/1.5*tm+Cd*A*Vm^3/21.15/2.5*tm); %电机峰值功率确定百公里加速时间
S2=vpasolve(eqn2,tm);
tm1=S2(1)

% fun = @(x)sin(x); % function
% x0 = [2 4]; % initial point
% x = fzero(fun,x0)

% fun=@(theta)sin(theta);
% theta0=[-100 100];
% theta=0.245;
% Pmax=1/0.95*(4250*9.81*cos(theta)*0.01/3600*5+0.31*2.22/76140*5^3+4250*9.81*sin(theta)*5/3600)
%% 仅仅需要15.3773的功率就能是坡起达到0.25，而一般情况下峰值功率都是大于这个数的，而已经满足坡起 0.25；
fun=@(theta,Pamx)(Pmax-1/0.95*(4250*9.81*cos(theta)*0.01/3600*5+0.31*2.22/76140*5^3+4250*9.81*sin(theta)*5/3600));%电机峰值功率，根据坡道车速指标,确定坡起
myfun=@(theta)myfun(theta,Pmax);
S3=fzero(fun,0.24)
theta1=S3(1)

%% JY 修改 根据电机峰值转矩算坡起
syms theta
Tmax = 260;
% theta = atan(tgtheta);
eqn3 = Tmax * i0 * nt / r0 - Cd * A * Vp * Vp / 21.15 == GVW * g * (f * cos(atan(theta)) + sin(atan(theta)));
S3 = vpasolve(eqn3, theta)
% fun = @(theta, Tmax)()
%% 
WLTP=xlsread(Condition_Path); 

x=WLTP(:,1);
y=WLTP(:,2);
N = length(x);                                                             %总时间
W=zeros( 1, N - 1 );%每秒功率
interv_x=zeros(1,N-1 );
mid_y=zeros(1,N-1);
interv_x1=zeros(1,N-1 );
mid_y1=zeros(1,N-1);
%%单个WLTP行程
for i = 2 : N
mid_y(i-1) = ( y(i) + y(i-1) ) / 2;
interv_x(i - 1) = x(i) - x(i-1);
end
L0 = interv_x * mid_y'/3600;                                               %一个WLTP行程Km
%%WLTP工况下的功率用功率算
for i = 2 : N
v0=y(i-1);                                                                 %1s的初始速度
v1=1/2*(y(i-1)+y(i));                                                      %1s的平均速度
t0=x(i)-x(i-1);
a=(y(i)-y(i-1))/3.6/t0;
W(i-1)=1/3600/3600/nt*v1*(GVW_n*g*f+Cd*A*v0^2/21.15+delta*GVW_n*a);        %计算每一秒所消耗的功率即能量
%W(i-1)=1/3600/nt/t0*(GVW_n*g*f*v1/1.5+Cd*A*v1^3/21.15/2.5+delta*GVW_n*a/2*v1)*t0/3600;
end
Ws=sum(W);                                                                 %一个工况仅车辆行驶所消耗的能量kwh

Wtotal=44.18;                                                              %电机总能量 ！！！modify_电池总能量
n1=Wtotal/Ws;
ans1=fix(n1);
W1=Wtotal-ans1*Ws;                                                         %剩下的非整数段功率

Wm=zeros( 1, N - 1 );%每秒功率
for i = 2 : N
v0=y(i-1);                                                                 %1s的初始速度
v1=1/2*(y(i-1)+y(i));                                                      %1s的平均速度
t0=x(i)-x(i-1);
a=(y(i)-y(i-1))/3.6/t0;
Wm(i-1)=1/3600/3600/nt*v1*(GVW_n*g*f+Cd*A*v0^2/21.15+delta*GVW_n*a);        %计算每一秒所消耗的功率即能量
%W(i-1)=1/3600/nt/t0*(GVW_n*g*f*v1/1.5+Cd*A*v1^3/21.15/2.5+delta*GVW_n*a/2*v1)*t0/3600;
Ws1=sum(Wm);
if Ws1>=W1
    N1=i;
    break
end
end

for i = 2 : N1
mid_y1(i-1) = ( y(i) + y(i-1) ) / 2;
interv_x1(i - 1) = x(i) - x(i-1);
L2 = interv_x1 * mid_y1'/3600;%算出剩下的距离
end

Ltotal=L0*ans1+L2
%  syms Vmax
%  
%  eqn = sin(Vmax) == Vmax^2 - 1;
%  
%  S = solve(eqn,Vmax)