%用某个工况提取的规则在另一个工况下进行检验，与DP和恒扭矩进行对比，该工况可以就是规则提取所使用的工况
%先运行rule_extract_cluster.m
load('.\+ResultData\+EV_3S_SJTU\CLTC_Grid_SOC_0.5_1.mat')

%% 用提取的规则在另一个工况下运行
SOC_next_step=0.8;
fuel_total=0;
SOC_save=zeros(1,Index_End);
lambda_per_step_save=zeros(1,Index_End);

for step = 1:Index_End
    velocity_current = EV.Result.Velocity(step);
    acceleration_current = EV.Result.Acceleration(step);
    SOC_current_step=SOC_next_step;
    if(velocity_current-v_min<=0)
        v_index=1;
    elseif(velocity_current-v_max>=0)
        v_index=precision;
    else
        v_index=ceil((velocity_current-v_min)/delta_v);
    end
    if(acceleration_current-a_min<=0)
        a_index=1;
    elseif(acceleration_current-a_max>=0)
        a_index=precision;
    else
        a_index=ceil((acceleration_current-a_min)/delta_a);
    end
    if(SOC_current_step-SOC_min<=0)
        SOC_index=1;
    elseif(SOC_current_step-SOC_max>=0)
        SOC_index=precision/4;
    else
        SOC_index = ceil((SOC_current_step-SOC_min)/delta_SOC);
    end
    
    lambda_current=lambda_save(v_index,a_index,SOC_index);%根据当前v,a,SOC，读取扭矩分配系数
    
    SOC_save(step)=SOC_current_step;
    lambda_per_step_save(step)=lambda_current;
    
    T_wheel = EV.Result.Tw(step);
    W_wheel = EV.Result.Ww(step);
    final_eff_F = (T_wheel>=0)/EV.Finala.Eff+(T_wheel<0)*EV.Finala.Eff;
    final_eff_R = (T_wheel>=0)/EV.Finalb.Eff+(T_wheel<0)*EV.Finalb.Eff;
    T_motor_F = final_eff_F.*T_wheel./EV.Finala.Ratio.*lambda_current;
    T_motor_R = final_eff_R.*T_wheel./EV.Finalb.Ratio.*(1-lambda_current);
    W_motor_F = W_wheel.* EV.Finala.Ratio;
    W_motor_R = W_wheel.* EV.Finalb.Ratio;
    
    EV.Motor1.Tm = T_motor_F;
    EV.Motor2.Tm = T_motor_R;
    EV.Motor1.Wm = W_motor_F;
    EV.Motor2.Wm = W_motor_R;
    EV.Motor1.Cal_Motor()
    EV.Motor2.Cal_Motor()
    P_motor_F = EV.Motor1.P_EM;
    P_motor_R = EV.Motor2.P_EM;
    
    EV.Batt.SOC_K = SOC_current_step;
    P_battery=P_motor_F+P_motor_R+EV.Paux;
    EV.Batt.P_Batt_K = P_battery;
    EV.Batt.Cal_SOC();
    SOC_next_step = EV.Batt.SOC_K_1;
    fuel_total = fuel_total+P_battery/ 1000;
end
Fuel_rule_based = fuel_total / 3600 * 100 / (EV.Distance/1000);    % k·Wh·(100 km)^-1

%% 扭矩分配系数恒为0.5时的情况
SOC_next_step=0.8;
lambda_initial=0.5;
fuel_total=0;
SOC_save_5=zeros(1,Index_End);
for step = 1:Index_End
    velocity_current = EV.Result.Velocity(step);
    acceleration_current = EV.Result.Acceleration(step);
    SOC_current_step=SOC_next_step;
    lambda_current=0.5;
    SOC_save_5(step)=SOC_current_step;
 
    T_wheel = EV.Result.Tw(step);
    W_wheel = EV.Result.Ww(step);
    final_eff_F = (T_wheel>=0)/EV.Finala.Eff+(T_wheel<0)*EV.Finala.Eff;
    final_eff_R = (T_wheel>=0)/EV.Finalb.Eff+(T_wheel<0)*EV.Finalb.Eff;
    T_motor_F = final_eff_F.*T_wheel./EV.Finala.Ratio.*lambda_current;
    T_motor_R = final_eff_R.*T_wheel./EV.Finalb.Ratio.*(1-lambda_current);
    W_motor_F = W_wheel.* EV.Finala.Ratio;
    W_motor_R = W_wheel.* EV.Finalb.Ratio;
    
    EV.Motor1.Tm = T_motor_F;
    EV.Motor2.Tm = T_motor_R;
    EV.Motor1.Wm = W_motor_F;
    EV.Motor2.Wm = W_motor_R;
    EV.Motor1.Cal_Motor()
    EV.Motor2.Cal_Motor()
    P_motor_F = EV.Motor1.P_EM;
    P_motor_R = EV.Motor2.P_EM;
    
    EV.Batt.SOC_K = SOC_current_step;
    P_battery=P_motor_F+P_motor_R+EV.Paux;
    EV.Batt.P_Batt_K = P_battery;
    EV.Batt.Cal_SOC();
    SOC_next_step = EV.Batt.SOC_K_1;
    fuel_total = fuel_total+P_battery/ 1000;
end
Fuel_5 = fuel_total / 3600 * 100 / (EV.Distance/1000);    % k·Wh·(100 km)^-1
%% 画图
x=1:1:Index_End;
SOC_DP=OPT_Result.SOC_K_1;
SOC_DP=cat(2,0.8,SOC_DP);
plot(x,SOC_save,'LineWidth',2);
hold on
plot(x,SOC_DP,'LineWidth',2);
hold on 
plot(x,SOC_save_5,'LineWidth',2);
xlabel('步长/时间');
ylabel('SOC值');
legend('Rule-Based','DP','const_0.5');