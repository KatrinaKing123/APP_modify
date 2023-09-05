clear all
close all
clc

%% Plot NEDC Driving Cycle
load('.\+CycleData\WLTC.mat')
figure('Name', 'SOC Range', 'NumberTitle', 'off','Position',[300 200 600 300]);
axes('Position',[0.10 0.15 0.8 0.8]);
plot(velocity, '-k', 'LineWidth', 1)
hold on
grid on
xlabel('Time (s)','FontSize',12,'FontName','Times New Roman');
ylabel('Velocity (km\cdoth^-^1)','FontSize',12,'FontName','Times New Roman');
%% Plot NEDC Driving Cycle
load('.\+ResultData\+EV_3S_SJTU\CYC_NEDC_Grid_SOC_0.5_1.mat')
T_total =zeros(1,1180);
ve = zeros(1,1180);
ve_step =0;
x= (1:1:1180);
for i = 1:1:1179
    EV.VehBody.Velocity = EV.Result.Velocity(i);
    EV.VehBody.Acceleration = EV.Result.Acceleration(i);
    EV.VehBody.Cal_VehBody()
    if(EV.VehBody.Ft>=0)
    T_total(i) = OPT_Result.T_m_Front_K_1(i).*EV.Finala.Ratio.*EV.Finala.Eff + OPT_Result.T_m_Rear_K_1(i).*EV.Finalb.Ratio.*EV.Finalb.Eff;
     else
         T_total(i) =EV.VehBody.Ft*EV.Wheel.R; 
    end
    ac = (T_total(i)./EV.Wheel.R- EV.VehBody.Frwi)./((1 + EV.VehBody.mt2m_f) * EV.VehBody.M_F);
    ve_step = ve_step + 3.6*ac./1; %步长正好是1秒
    ve(i+1) = ve_step;
end

% plot(x,ve,'r', 'LineWidth', 1)
% hold on

    
    
        
        
        
        
        
        
        
        
    
    