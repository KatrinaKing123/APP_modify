% clc;
% clear;
% V_wheel_kmh=xlsread('WLTP',1,'A1:B1800');
% V_wheel_kmh = xlsread(Condition_Path,1,'A1:B1800');
[~,~,fileExt] = fileparts(Condition_Path);
if strcmpi(fileExt, '.xlsx')

    velocity = xlsread(Condition_Path);
    velocity = velocity(:,2);

    
elseif strcmpi(fileExt, '.mat')
   load(Condition_Path);
end
V_wheel_kmh=velocity;
% discharge_motor_eff_map = xlsread('parameter_original',5,'B6:o21');
discharge_motor_eff_map = xlsread(parameters_Path, 5,'B6:o21');
% charge_motor_eff_map = xlsread('parameter_original',5,'B26:o40');
charge_motor_eff_map = xlsread(parameters_Path,5,'B26:o40');

% pedal_eccelerate_map = xlsread('parameter_original',2,'B4:Q16');
pedal_eccelerate_map = xlsread(parameters_Path,2,'B4:Q16');

% V_wheel_ms(:,1)=V_wheel_kmh(:,1);
% V_wheel_ms(:,2)=V_wheel_kmh(:,2)/3.6;

V_wheel_ms(:,1)=[1:1:length(velocity)]';
V_wheel_ms(:,2)=V_wheel_kmh/3.6;

%计算每一秒车辆对应的加速度
[rows,cols] = size(V_wheel_ms);
for i=1:(rows-1)
  a(i,1)=(V_wheel_ms(i+1,2)-V_wheel_ms(i,2))/(V_wheel_ms(i+1,1)-V_wheel_ms(i,1));
end
%设置车辆参数
% m=4250;
m=m_calcu;
% g=9.81;
g=gravity_acc;
% C_d=0.188;
C_d = wind_coeff;
% A_d=1.2;
A_d = air_density;
% mu=0.1;
mu=rolling_coeff;
rm = rotation_converse_coeff;
% i0=12.1;
i0 = final_ratio;
%车轮半径单位m
% r=0.346;
r = radius_wheel;

for ii=1:(rows-1)
    T(ii,1)=(rm*m*a(ii,1)+m*g*mu+V_wheel_ms(ii,2)^2*C_d*A_d/21.5)*r/i0;
%     T(ii,1)=(m*a(ii,1)+m*g*mu+V_wheel_ms(ii,2)^2*C_d*A_d/21.5)*r/i0;

end
for iii=1:(rows-1)
n(iii,1)=V_wheel_ms(iii,2)/r/(2*pi/60)*i0;
end

for iiii=1:(rows-1)
    P(iiii,1)=T(iiii,1)*n(iiii,1)/9.55;
end
 [rows1,cols1] = size(discharge_motor_eff_map);
 [rows2,cols2] = size(charge_motor_eff_map);
for iiiii=1:(rows-1)
    if P(iiiii,1)>0
    for tt=1:(rows1-1)
        P_big_may(tt,1)=interp2(discharge_motor_eff_map(2:rows1,1),discharge_motor_eff_map(1,2:cols1),discharge_motor_eff_map(2:rows1,2:cols1)',discharge_motor_eff_map(tt+1,1),n(iiiii,1));
    end
    P_big(iiiii,1)=interp1(P_big_may,discharge_motor_eff_map(2:rows1,1),P(iiiii,1));
    end
    if P(iiiii,1)==0
         P_big(iiiii,1)=0;
    end
    if P(iiiii,1)<0
        P_big(iiiii,1)=interp2(charge_motor_eff_map(2:rows2,1),charge_motor_eff_map(1,2:cols2),charge_motor_eff_map(2:rows2,2:cols2)', P(iiiii,1),n(iiiii,1));
    end
end
[r2,c2]=size(pedal_eccelerate_map);
% for iiiiii=1:(rows-1)
%     
%    T_back_max(iiiiii,1)=interp2(pedal_eccelerate_map(2:r2,1),pedal_eccelerate_map(1,2:c2),pedal_eccelerate_map(2:r2,2:c2)', 0,V_wheel_kmh(iiiiii,2));
% end
scatter(n, P_big)
%散点图

n_list = xlsread(parameters_Path, 5,'c6:o6');
P_list1 = xlsread(parameters_Path,5,'b7:b21');
P_list2 = xlsread(parameters_Path,5,'b27:b39');
P_list = [P_list2' P_list1'];

% CData=density2C(n,P_big,0:1500:15000,-160000:20000:200000);
CData=density2C(n,P_big,n_list,P_list);

scatter(n,P_big,'filled','CData',CData);
hold on;
%等高线图
% [~,~,XMesh,YMesh,ZMesh,colorList]=density2C(n,P_big,0:1500:15000,-160000:20000:200000);
[~,~,XMesh,YMesh,ZMesh,colorList]=density2C(n,P_big,n_list,P_list);

% axesHandle = app.UIAxes;
colormap(colorList)
contourf(XMesh,YMesh,ZMesh,8);
% h.x = XMesh;
% h.y = YMesh;
% h.z = ZMesh;

function [CData,h,XMesh,YMesh,ZMesh,colorList]=density2C(X,Y,XList,YList,colorList)
[XMesh,YMesh]=meshgrid(XList,YList);
XYi=[XMesh(:) YMesh(:)];
F=ksdensity([X,Y],XYi);
[aa,~]=size(XYi);
for ii=1:aa
    if XYi(ii,2)>=0
        F(ii)=F(ii)* XYi(ii,2);
    end
    if XYi(ii,2)<0
         F(ii)=-F(ii)* XYi(ii,2);
    end
end


ZMesh=zeros(size(XMesh));
ZMesh(1:length(F))=F;

h=interp2(XMesh,YMesh,ZMesh,X,Y);
if nargin<5
colorList=[0.9300    0.9500    0.9700
    0.7900    0.8400    0.9100
    0.6500    0.7300    0.8500
    0.5100    0.6200    0.7900
    0.3700    0.5100    0.7300
    0.2700    0.4100    0.6300
    0.2100    0.3200    0.4900
    0.1500    0.2200    0.3500
    0.0900    0.1300    0.2100
    0.0300    0.0400    0.0700];
end
colorFunc=colorFuncFactory(colorList);
CData=colorFunc((h-min(h))./(max(h)-min(h)));
colorList=colorFunc(linspace(0,1,100)');

function colorFunc=colorFuncFactory(colorList)
x=(0:size(colorList,1)-1)./(size(colorList,1)-1);
y1=colorList(:,1);y2=colorList(:,2);y3=colorList(:,3);
colorFunc=@(X)[interp1(x,y1,X,'pchip'),interp1(x,y2,X,'pchip'),interp1(x,y3,X,'pchip')];
end
end



%% 
% 输出：ZMesh（对应转速、功率、密度*功率）,图
% 输入：车速，参数表，车辆动力学全部参数

