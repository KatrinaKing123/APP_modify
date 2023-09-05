%% 电机模型校核算法（遗传算法）
% 编写时间：2023-06-27
% 编写人：陈宇轩
% 说明：EV车静态参数，后向模型
% 依赖：谢菲尔德大学遗传算法工具箱

%% 
% clearvars Motor_Model_struct
% close all
% clc
%% 实车、电机数据读取
StaticParameters.static_parameters_EV63;
data_file_path = strcat('../../+AppResult/+Data/+Model_Verification/+update/+EV_Data/Data_Motor_processed.mat');
load(data_file_path)

%% 电机数据可视化
% data需要分为驱动和制动两部分
% 数据分类
% （1）驱动：
Motor_origin.Power_DrvM = Motor_origin.Power_M(find(Motor_origin.Trq > 0));
Motor_origin.Power_DrvE = Motor_origin.Power_E(find(Motor_origin.Trq > 0));
Motor_origin.Speed_Drvreal = Motor_origin.Speed(find(Motor_origin.Trq > 0));
Motor_origin.Trq_Drvreal = Motor_origin.Trq(find(Motor_origin.Trq > 0));
% 处理异常点：
Motor_origin.Power_Drv_M = Motor_origin.Power_DrvM(find((Motor_origin.Power_DrvE > 0) & (Motor_origin.Power_DrvM > 0)));
Motor_origin.Power_Drv_E = Motor_origin.Power_DrvE(find((Motor_origin.Power_DrvE > 0) & (Motor_origin.Power_DrvM > 0)));
Motor_origin.Speed_Drv_real = Motor_origin.Speed_Drvreal(find((Motor_origin.Power_DrvE > 0) & (Motor_origin.Power_DrvM > 0)));
Motor_origin.Trq_Drv_real = Motor_origin.Trq_Drvreal(find((Motor_origin.Power_DrvE > 0) & (Motor_origin.Power_DrvM > 0)));

% （2）制动：
Motor_origin.Power_BrkM = Motor_origin.Power_M(find(Motor_origin.Trq < 0));
Motor_origin.Power_BrkE = Motor_origin.Power_E(find(Motor_origin.Trq < 0));
Motor_origin.Speed_Brkreal = Motor_origin.Speed(find(Motor_origin.Trq < 0));
Motor_origin.Trq_Brkreal = Motor_origin.Trq(find(Motor_origin.Trq < 0));
% 处理异常点：
Motor_origin.Power_Brk_M = Motor_origin.Power_BrkM(find((Motor_origin.Power_BrkE < 0) & (Motor_origin.Power_BrkM < 0)));
Motor_origin.Power_Brk_E = Motor_origin.Power_BrkE(find((Motor_origin.Power_BrkE < 0) & (Motor_origin.Power_BrkM < 0)));
Motor_origin.Speed_Brk_real = Motor_origin.Speed_Brkreal(find((Motor_origin.Power_BrkE < 0) & (Motor_origin.Power_BrkM < 0)));
Motor_origin.Trq_Brk_real = Motor_origin.Trq_Brkreal(find((Motor_origin.Power_BrkE < 0) & (Motor_origin.Power_BrkM < 0)));

figure('Name','电机二维数据','NumberTitle','off')
subplot(211)
plot(Motor_origin.Power_Drv_M,Motor_origin.Power_Drv_E,'.')
grid on 
xlabel('电机驱动机械功率(Kw)')
ylabel('电机驱动电功率(Kw)')
subplot(212)
plot(Motor_origin.Power_Brk_M,Motor_origin.Power_Brk_E,'.r')
grid on 
xlabel('电机制动机械功率(Kw)')
ylabel('电机制动电功率(Kw)')

close all

%% 遗传算法数据辨识
% 选取数据进行分析
Start_Index_Drv=3;
End_Index_Drv = length(Motor_origin.Power_Drv_M)-Start_Index_Drv;
random_Drv =Start_Index_Drv:1:End_Index_Drv; 
Start_Index_Brk=3;
End_Index_Brk = length(Motor_origin.Power_Brk_M)-Start_Index_Brk;
random_Brk =Start_Index_Brk:1:End_Index_Brk; 

Power_real_Drv_E = Motor_origin.Power_Drv_E(random_Drv);
Power_real_Drv_M = Motor_origin.Power_Drv_M(random_Drv);
Drive_rad=Motor_origin.Speed_Drv_real(random_Drv);
Drive_Trq=Motor_origin.Trq_Drv_real(random_Drv);
Power_real_Brk_E=Motor_origin.Power_Brk_E(random_Brk);
Power_real_Brk_M=Motor_origin.Power_Brk_M(random_Brk);
Brake_rad = Motor_origin.Speed_Brk_real(random_Brk);
Brake_Trq = Motor_origin.Trq_Brk_real(random_Brk);

Motor_Update_Drv.Power_Drv_Brk_E =Power_real_Drv_E;
Motor_Update_Drv.Power_Drv_Brk_M =Power_real_Drv_M;
Motor_Update_Brk.Power_Drv_Brk_E =Power_real_Brk_E;
Motor_Update_Brk.Power_Drv_Brk_M =Power_real_Brk_M;

% 采用遗传算法，分制动与驱动部分对电机的电功率和机械功率转换效率进行辨识
% P_E = a * P_M^2 + b * P_M + c，辨识a b c三个参数
% a的范围
values_limt(1,1) = 0.00005;%-0.0002576;%
values_limt(2,1) = 0.001;%-0.0002343;%0.0004315;%
% b的范围
values_limt(1,2) = 0.2;%1.184;%
values_limt(2,2) = 1.5;%1.185;%0.8773;%
% c的范围
values_limt(1,3) = 0.1;%0.04496;%
values_limt(2,3) = 2.0;%0.05057;%

% 定义遗传算法参数
StaticParameters.GA_Params;
GA_Params_Drv=GA_Stastic_Params;
GA_Params_Brk=GA_Stastic_Params;

%% 遗传算法
%% 驱动部分
tic
str_dis = strcat('驱动部分：正在计算，第',num2str(0),'代，请等待........');
disp(str_dis)
GA_Params_Drv.FieldD = [rep(GA_Params_Drv.PRECI,[1,GA_Params_Drv.NVAR]);values_limt;rep([1;0;1;1],[1,GA_Params_Drv.NVAR])];
GA_Params_Drv.Chrom = crtbp(GA_Params_Drv.NIND, GA_Params_Drv.NVAR*GA_Params_Drv.PRECI);                         % 初始种群
gen_Drv = 0;                                                 % 代数计数器
GA_Params_Drv.trace = zeros(GA_Params_Drv.MAXGEN, GA_Params_Drv.NVAR);                             % 追踪遗传算法结果
Motor_Parameters_Drv = bs2rv(GA_Params_Drv.Chrom, GA_Params_Drv.FieldD);                 % 计算初始种群的十进制转换 
ObjV_Drv =  Program.Model_Verification.Motor.Object_Motor(Motor_Parameters_Drv,Motor_Update_Drv);           % 计算目标函数值
while gen_Drv < GA_Params_Drv.MAXGEN
    clc
    str_dis = strcat('驱动部分：正在计算，第',num2str(gen_Drv + 1),'代，请等待........');
    disp(str_dis)
    toc
    FitnV_Drv = ranking(ObjV_Drv);                               %分配适应度值 
    SelCh_Drv = select('sus',GA_Params_Drv.Chrom,FitnV_Drv,GA_Params_Drv.GGAP);              %选择
    SelCh_Drv = recombin('xovsp',SelCh_Drv,0.7);                 %重组
    SelCh_Drv = mut(SelCh_Drv);                                  %变异
    Motor_Parameters_Drv = bs2rv(SelCh_Drv,GA_Params_Drv.FieldD);              %子代十进制转换
    ObjVSel_Drv =  Program.Model_Verification.Motor.Object_Motor(Motor_Parameters_Drv,Motor_Update_Drv); 
    [GA_Params_Drv.Chrom,ObjV_Drv] = reins(GA_Params_Drv.Chrom,SelCh_Drv,1,1,ObjV_Drv,ObjVSel_Drv);  %重插入
    gen_Drv=gen_Drv+1;
    [Y, I]=min(ObjV_Drv);
    %Y,bs2rv(Chrom(I,:),FieldD)                         %输出每一次的最优解及其对应的自变量值
    GA_Params_Drv.trace(gen_Drv,1)=min(ObjV_Drv);                             %遗传算法性能跟踪
    GA_Params_Drv.trace(gen_Drv,2)=sum(ObjV_Drv)/length(ObjV_Drv);
end
% 理论能耗计算
for i=1:length(Drive_rad)
    eff_Drv=interp2(Par_Motor_Static.w_EM_row,Par_Motor_Static.T_EM_col_1,Par_Motor_Static.eta_EM_map_1',Drive_rad(i),Drive_Trq(i),'nearest');
    Pem_theory_Drv(i) = eff_Drv * Drive_rad(i) * Drive_Trq(i)/9550;
end
Motor_Parameters_Drv = bs2rv(GA_Params_Drv.Chrom,GA_Params_Drv.FieldD);              %子代十进制转换

a_Drv = Motor_Parameters_Drv(I,1);
b_Drv = Motor_Parameters_Drv(I,2);
c_Drv = Motor_Parameters_Drv(I,3);
% Pem_theory(isnan(Pem_theory))=0;
E_sim_real_Drv = GA_Params_Drv.trace(end,2);
E_theory_real_Drv = sqrt(sum((Power_real_Drv_E - Pem_theory_Drv).^2) / length(Pem_theory_Drv));
% Result visualization
% (1) Gap between the leading vehicle and the following vehicle
figure('Name','Minimum object value for each generation','NumberTitle','off')  
subplot(2,1,1)
plot(GA_Params_Drv.trace(:,2),'-r*','LineWidth',1)
grid on
legend('Average object','Location','northeast')
xlabel('Iteration Number')
ylabel('Average Object')
subplot(2,1,2)
plot(GA_Params_Drv.trace(:,1),'-b*','LineWidth',1)
grid on
legend('Minimum object','Location','northeast')
xlabel('Iteration Number')
ylabel('Minimum Object')

figure('Name','simulation vs real(Drive Part)','NumberTitle','off')
P_E_sim_Drv = a_Drv .* Motor_Update_Drv.Power_Drv_Brk_M.^2 + b_Drv .* Motor_Update_Drv.Power_Drv_Brk_M + c_Drv;
plot(Motor_Update_Drv.Power_Drv_Brk_M,P_E_sim_Drv,'linewidth',2);
hold on
plot(Power_real_Drv_M,Power_real_Drv_E,'.r')
hold on
grid on
plot(Power_real_Drv_M,Pem_theory_Drv,'.k')
legend('模型输出电机功率','实测电机功率','理论计算电机功率')
fig_name = strcat('..\..\+AppResult\+Figure\+Model_Verification\Motor\','驱动部分电机功率','.png');
saveas(gcf,fig_name)
Motor_Result_Drv.a=a_Drv;
Motor_Result_Drv.b=b_Drv;
Motor_Result_Drv.c=c_Drv;
Motor_Result_Drv.E_sim_real=E_sim_real_Drv;
Motor_Result_Drv.E_theory_real=E_theory_real_Drv;
Motor_Result_Drv.E_theory_real=E_theory_real_Drv;
data_save_file=strcat('..\..\+AppResult\+Data\+Model_Verification\+verified\+EV_Data\');
save(strcat(data_save_file,'Data_Motor_Verified_Drv.mat'), 'Motor_Result_Drv');


%% 制动部分
tic
str_dis = strcat('制动部分：正在计算，第',num2str(0),'代，请等待........');
disp(str_dis)
GA_Params_Brk.FieldD = [rep(GA_Params_Brk.PRECI,[1,GA_Params_Brk.NVAR]);values_limt;rep([1;0;1;1],[1,GA_Params_Brk.NVAR])];
GA_Params_Brk.Chrom = crtbp(GA_Params_Brk.NIND, GA_Params_Brk.NVAR*GA_Params_Brk.PRECI);                         % 初始种群
gen_Brk = 0;                                                 % 代数计数器
GA_Params_Brk.trace = zeros(GA_Params_Brk.MAXGEN, GA_Params_Brk.NVAR);                             % 追踪遗传算法结果
Motor_Parameters_Brk = bs2rv(GA_Params_Brk.Chrom, GA_Params_Brk.FieldD);                 % 计算初始种群的十进制转换 
ObjV_Brk =  Program.Model_Verification.Motor.Object_Motor(Motor_Parameters_Brk,Motor_Update_Brk);           % 计算目标函数值
while gen_Brk < GA_Params_Brk.MAXGEN
    clc
    str_dis = strcat('制动部分：正在计算，第',num2str(gen_Brk + 1),'代，请等待........');
    disp(str_dis)
    toc
    FitnV_Brk = ranking(ObjV_Brk);                               %分配适应度值 
    SelCh_Brk = select('sus',GA_Params_Brk.Chrom,FitnV_Brk,GA_Params_Brk.GGAP);              %选择
    SelCh_Brk = recombin('xovsp',SelCh_Brk,0.7);                 %重组
    SelCh_Brk = mut(SelCh_Brk);                                  %变异
    Motor_Parameters_Brk = bs2rv(SelCh_Brk,GA_Params_Brk.FieldD);              %子代十进制转换
    ObjVSel_Brk =  Program.Model_Verification.Motor.Object_Motor(Motor_Parameters_Brk,Motor_Update_Brk); 
    [GA_Params_Brk.Chrom,ObjV_Brk] = reins(GA_Params_Brk.Chrom,SelCh_Brk,1,1,ObjV_Brk,ObjVSel_Brk);  %重插入
    gen_Brk=gen_Brk+1;
    [Y, I]=min(ObjV_Brk);
    %Y,bs2rv(Chrom(I,:),FieldD)                         %输出每一次的最优解及其对应的自变量值
    GA_Params_Brk.trace(gen_Brk,1)=min(ObjV_Brk);                             %遗传算法性能跟踪
    GA_Params_Brk.trace(gen_Brk,2)=sum(ObjV_Brk)/length(ObjV_Brk);
%     trace(gen,3:5)=Motor_Parameters(I,:);                                %记下每代的最优值
%     trace(gen,6)=Y;                                                      %记下每代的最优值
end

% 理论能耗计算
for i = 1:length(Brake_rad)
    eff_Brk = interp2(Par_Motor_Static.w_EM_row,Par_Motor_Static.T_EM_col_2,Par_Motor_Static.eta_EM_map_2',Brake_rad(i),Brake_Trq(i),'nearest');
    Pem_theory_Brk(i) = eff_Brk * Brake_rad(i) * Brake_Trq(i)/9550;
end
Motor_Parameters_Brk = bs2rv(GA_Params_Brk.Chrom,GA_Params_Brk.FieldD);              %子代十进制转换

a_Brk = Motor_Parameters_Brk(I,1);
b_Brk = Motor_Parameters_Brk(I,2);
c_Brk = Motor_Parameters_Brk(I,3);
% Pem_theory(isnan(Pem_theory))=0;
E_sim_real_Brk = GA_Params_Brk.trace(end,2);
E_theory_real_Brk = sqrt(sum((Power_real_Brk_E - Pem_theory_Brk).^2) / length(Pem_theory_Brk));
% Result visualization
% (1) Gap between the leading vehicle and the following vehicle
figure('Name','Minimum object value for each generation','NumberTitle','off')  
subplot(2,1,1)
plot(GA_Params_Brk.trace(:,2),'-r*','LineWidth',1)
grid on
legend('Average object','Location','northeast')
xlabel('Iteration Number')
ylabel('Average Object')
subplot(2,1,2)
plot(GA_Params_Brk.trace(:,1),'-b*','LineWidth',1)
grid on
legend('Minimum object','Location','northeast')
xlabel('Iteration Number')
ylabel('Minimum Object')

figure('Name','simulation vs real(Brake Part)','NumberTitle','off')
P_E_sim_Brk = a_Brk .* Motor_Update_Brk.Power_Drv_Brk_M.^2 + b_Brk .* Motor_Update_Brk.Power_Drv_Brk_M + c_Brk;
plot(Motor_Update_Brk.Power_Drv_Brk_M,P_E_sim_Brk,'linewidth',2);
hold on
plot(Power_real_Brk_M,Power_real_Brk_E,'.r')
hold on
grid on
plot(Power_real_Brk_M,Pem_theory_Brk,'.k')
legend('模型输出电机功率','实测电机功率','理论计算电机功率')
fig_name = strcat('..\..\+AppResult\+Figure\+Model_Verification\Motor\','制动部分电机功率','.png');
saveas(gcf,fig_name);

figure('Name','simulation vs real','NumberTitle','off')
subplot(2,1,1)
plot(Motor_Update_Drv.Power_Drv_Brk_M,P_E_sim_Drv,'LineWidth',2);
hold on 
plot(Power_real_Drv_M,Power_real_Drv_E,'.r')
hold on
grid on
plot(Power_real_Drv_M,Pem_theory_Drv,'.k')
legend('模型输出电机功率','实测电机功率','理论计算电机功率')
title('驱动部分')
subplot(2,1,2)
plot(Motor_Update_Brk.Power_Drv_Brk_M,P_E_sim_Brk,'linewidth',2);
hold on
plot(Power_real_Brk_M,Power_real_Brk_E,'.r')
hold on
grid on
plot(Power_real_Brk_M,Pem_theory_Brk,'.k')
legend('模型输出电机功率','实测电机功率','理论计算电机功率')
title('制动部分')
fig_name = strcat('..\..\+AppResult\+Figure\+Model_Verification\Motor\','电机功率校核结果','.png');
saveas(gcf,fig_name);


Motor_Result_Brk.a=a_Brk;
Motor_Result_Brk.b=b_Brk;
Motor_Result_Brk.c=c_Brk;
Motor_Result_Brk.E_sim_real=E_sim_real_Drv;
Motor_Result_Brk.E_theory_real=E_theory_real_Drv;
Motor_Result_Brk.E_theory_real=E_theory_real_Drv;
data_save_file=strcat('..\..\+AppResult\+Data\+Model_Verification\+verified\+EV_Data\');
save(strcat(data_save_file,'Data_Motor_Verified_Brk.mat'), 'Motor_Result_Brk');