% clc
% clear all
% load('.\+ResultData\+EV_3S_SJTU\WLTC_Grid_SOC_0.5_1.mat')
fileID = fopen('window.txt', 'w');
fclose(fileID);
diary('window.txt');
num_of_kmeans = 20;
num_lambda_cluster = 8;

lambda = zeros(1,Index_End);
lambda(1) = Index_Start;
lambda(2:Index_End) = OPT_Result.G_K_1;
SOC = zeros(1,Index_End);
SOC(1) = SOC_Init;
SOC(2:Index_End) = OPT_Result.SOC_K_1;
velocity = EV.Result.Velocity;
acceleration = EV.Result.Acceleration;
% %剔除停车状态的点，排除干扰
% index_1=find(velocity~=0&acceleration~=0);
% lambda=lambda(index_1);
% velocity=velocity(index_1);
% acceleration=acceleration(index_1);
% SOC=SOC(index_1);

%先将扭矩分配系数视为v,a,SOC的函数，进行聚类
X=zeros(length(SOC),4);
X(:,1)=velocity;
X(:,2)=acceleration*20;
X(:,3)=SOC*40;
X(:,4)=lambda*40;
idx_real = 0;C_real = 0;sumD_real = 0;
%多次聚类，选取最优结果
for i= 1:num_of_kmeans
    if(i == 1)
        [idx,C,sumD]=kmeans(X,num_lambda_cluster );
%idx存储每个数据（指X的每一行）的类的标号，C存储聚类中心，sumD存储距离和
        idx_real = idx;
        C_real = C;
        sumD_real = sumD;
    else
        [idx,C,sumD]=kmeans(X,num_lambda_cluster );
        
        if(sum(sumD) < sum(sumD_real))
           idx_real = idx;
           C_real = C;
           sumD_real = sumD;
        end
    end
end
sum_distance = sum(sumD_real);
lambda_cluster = cell(1,num_lambda_cluster);
for i = 1:num_lambda_cluster
    lambda_cluster{i} = X(idx_real == i,:);
end



for j=1:num_lambda_cluster
    lambda_cluster{j}(:,2) = lambda_cluster{j}(:,2)/20;
    lambda_cluster{j}(:,3) = lambda_cluster{j}(:,3)/40;
    lambda_cluster{j}(:,4) = lambda_cluster{j}(:,4)/40;
end
X(:,1)=velocity;
X(:,2)=acceleration;
X(:,3)=SOC;
X(:,4)=lambda;

v_max=max(velocity);v_min=min(velocity);
a_max=max(acceleration);a_min=min(acceleration);
SOC_max=max(SOC);SOC_min=min(SOC);
precision_1=precision;




delta_v=(v_max-v_min)/precision_1;

delta_a_P=(a_max)/(precision_1/2);
delta_a_N=(-a_min)/(precision_1/2);
delta_SOC=(SOC_max-SOC_min)/(precision_1/2);

%利用一个三维数组存储规则提取的结果
lambda_default=0.5;
%没有提取到规则的区域默认设为0.5
lambda_save=ones(precision_1,precision_1,precision_1/2)*lambda_default;
count=1;
for i=1:precision_1
    for j=1:precision_1
        for k=1:(precision_1/2)
            v_judge_total=(X(:,1)>=v_min+(i-1)*delta_v)&(X(:,1)<=v_min+i*delta_v);
            if j>precision_1/2
                a_judge_total=(X(:,2)>=(j-precision_1/2-1)*delta_a_P)&(X(:,2)<=(j-precision_1/2)*delta_a_P);
            else
                a_judge_total=(X(:,2)>=a_min+(j-1)*delta_a_N)&(X(:,2)<=a_min+j*delta_a_N);
            end
            SOC_judge_total=(X(:,3)>=SOC_min+(k-1)*delta_SOC)&(X(:,3)<=SOC_min+k*delta_SOC);
            if_contain_total=v_judge_total&a_judge_total&SOC_judge_total;
            index_total=find(if_contain_total);
            num_of_point_cube=length(index_total);
            for m=1:num_lambda_cluster  
                v_judge=(lambda_cluster{m}(:,1)>=v_min+(i-1)*delta_v)&(lambda_cluster{m}(:,1)<=v_min+i*delta_v);
                
                if j>precision_1/2
                    a_judge=(lambda_cluster{m}(:,2)>=(j-precision_1/2-1)*delta_a_P)&(lambda_cluster{m}(:,2)<=(j-precision_1/2)*delta_a_P);
                else
                    a_judge=(lambda_cluster{m}(:,2)>=a_min+(j-1)*delta_a_N)&(lambda_cluster{m}(:,2)<=a_min+j*delta_a_N);
                end
                SOC_judge=(lambda_cluster{m}(:,3)>=SOC_min+(k-1)*delta_SOC)&(lambda_cluster{m}(:,3)<=SOC_min+k*delta_SOC);
                if_contain=v_judge&a_judge&SOC_judge;
                index=find(if_contain);
                num_of_point_cluster=length(index);
                if(num_of_point_cluster>=0.5*num_of_point_cube&&num_of_point_cube>=2)
                    lambda_mean=mean(lambda_cluster{m}(index,4));
                    countstr=num2str(count);
                    if j>precision_1/2
                        str_dis = strcat('Rule',countstr,'：当v在[ ',32,num2str(v_min+(i-1)*delta_v),',',32,num2str(v_min+i*delta_v),'],a在[',32,num2str((j-precision_1/2-1)*delta_a_P),',',32,num2str((j-precision_1/2)*delta_a_P),'],SOC在[',32,num2str(SOC_min+(k-1)*delta_SOC),',',32,num2str(SOC_min+k*delta_SOC),']时，扭矩分配系数取',32,num2str(lambda_mean));
                    else
                        str_dis = strcat('Rule',countstr,'：当v在[ ',32,num2str(v_min+(i-1)*delta_v),',',32,num2str(v_min+i*delta_v),'],a在[',32,num2str(a_min+(j-1)*delta_a_N),',',32,num2str(a_min+j*delta_a_N),'],SOC在[',32,num2str(SOC_min+(k-1)*delta_SOC),',',32,num2str(SOC_min+k*delta_SOC),']时，扭矩分配系数取',32,num2str(lambda_mean));
                    end
                    disp(str_dis)
                    lambda_save(i,j,k)=lambda_mean;
                    count=count+1;
                end
            end
        end
    end
end


%已知每一步长的扭矩分配系数，计算百公里能耗
SOC_next_step=SOC_Init;
lambda_initial=0.5;
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
        v_index=precision_1;
    else
        v_index=ceil((velocity_current-v_min)/delta_v);
    end
    if(acceleration_current-a_min<=0)
        a_index=1;
    elseif(acceleration_current-a_max>=0)
        a_index=precision_1;
    elseif(acceleration_current<=0)
        a_index=ceil((acceleration_current-a_min)/delta_a_N);
    else
        a_index=ceil((acceleration_current)/delta_a_P)+precision_1/2;
    end
    if(SOC_current_step-SOC_min<=0)
        SOC_index=1;
    elseif(SOC_current_step-SOC_max>=0)
        SOC_index=precision_1/2;
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

%均分策略
SOC_next_step=SOC_Init;
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
Fuel_average = fuel_total / 3600 * 100 / (EV.Distance/1000);    % k·Wh·(100 km)^-1



% 
% x=1:1:Index_End;
% SOC_DP=OPT_Result.SOC_K_1;
% SOC_DP=cat(2,SOC_Init,SOC_DP);
% plot(x,SOC_save,'LineWidth',1);
% hold on
% plot(x,SOC_DP,'LineWidth',1);
% hold on 
% plot(x,SOC_save_5,'LineWidth',1);
% xlabel=('步长/时间');
% ylabel=('SOC值');
% legend('Rule-Based','DP','average');



diary off;

            
            

    



