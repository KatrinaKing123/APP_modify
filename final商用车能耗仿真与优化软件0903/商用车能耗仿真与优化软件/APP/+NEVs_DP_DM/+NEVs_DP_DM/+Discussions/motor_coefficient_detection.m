clear all
close all
clc

%% Plot 电机效率MAP图
load('.\+ResultData\+EV_3S_SJTU\CYC_NEDC_Grid_SOC_0.5_1.mat')
speed_1=EV.Motor1.W_Row/(2*pi/60);
torque_1=EV.Motor1.T_Col; %Scale为1就不管了
efficiency_1 = EV.Motor1.Eff_map*100;
[S_1, T_1] = meshgrid(0:10:15000,-190:5:190);
eff_1 = griddata(speed_1,torque_1,efficiency_1,S_1,T_1);

speed_2=EV.Motor2.W_Row/(2*pi/60);
torque_2=EV.Motor2.T_Col; 
efficiency_2 = EV.Motor2.Eff_map*100;
[S_2, T_2] = meshgrid(0:10:13000,-330:5:330);
eff_2 = griddata(speed_2,torque_2,efficiency_2,S_2,T_2);

T_m_Front = OPT_Result.T_m_Front_K_1;
T_m_Rear = OPT_Result.T_m_Rear_K_1;
W_m_Front = OPT_Result.W_m_Front_K_1;
W_m_Rear = OPT_Result.W_m_Rear_K_1;

index_1 = find(T_m_Front~=0|T_m_Front==0);
T_m_Front_1 = T_m_Front(index_1);
W_m_Front_1 = W_m_Front(index_1);

index_2 = find(T_m_Rear~=0|T_m_Rear==0);
T_m_Rear_1 = T_m_Rear(index_2);
W_m_Rear_1 = W_m_Rear(index_2);


subplot(1,2,1)
value=(40:3:120);
[c1,h1] = contourf(S_1,T_1,eff_1,value);
hold on
% clabel=(c,h,value);
xlabel = ('Torque');
ylabel = ('Speed');

scatter(W_m_Front_1/(2*pi/60),T_m_Front_1);

subplot(1,2,2)

[c2,h2] = contourf(S_2,T_2,eff_2,value);
hold on
% xlabel = ('Torque');
% ylabel = ('Speed');
scatter(W_m_Rear_1/(2*pi/60),T_m_Rear_1);

    
    
        
        
        
        
        
        
        
        
    
    