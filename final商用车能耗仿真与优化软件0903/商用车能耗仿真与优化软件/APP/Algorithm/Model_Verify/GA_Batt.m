% clear
% close all
% clc
%% 动力电池参数辨识程序
data_file_path = strcat('../../+AppResult/+Data/+Model_Verification/+update/+EV_Data/Data_Batt_processed.mat');
load(data_file_path)

%% 数据可视化------------------------------------------------------
figure('Name','蓄电池数据','NumberTitle','off')
subplot(2,2,1)
plot(Batt_origin.SOC_Real,'-b','LineWidth',2)
grid on
xlabel('Time ')
ylabel('SOC (%)')
subplot(2,2,2)
plot(Batt_origin.Power,'-k','LineWidth',2)
grid on
xlabel('Time (0.01s)')
ylabel('Power (Kw)')
subplot(2,2,3)
plot(Batt_origin.Current,'--r','LineWidth',2)
grid on
xlabel('Time (0.01s)')
ylabel('Current (A)')
subplot(2,2,4)
plot(Batt_origin.Voltage,'-g','LineWidth',2)
grid on
xlabel('Time (0.01s)')
ylabel('Voltage (A)')

close all
%% 选取数据进行分析
Start_Index = 17;
End_Index = length(Batt_origin.SOC_Real)-17;
random = Start_Index:10:End_Index;
Power_real_Batt = Batt_origin.Power(random);
SOC_real = Batt_origin.SOC_Real(random)./100;
I = Batt_origin.Current(random);
U = Batt_origin.Voltage(random);
subplot(2,1,1)
plot(SOC_real,'-b','LineWidth',2)
subplot(2,1,2)
plot(Power_real_Batt,'-k','LineWidth',2)
close all

StaticParameters.static_parameters_EV63;

% voc_map=[2.695,3.215,3.259,3.287,3.289,3.292,3.267,3.329,3.329,3.330,3.449]*384/3.2;
% soc_map = 0:0.1:1;
% R_D_SOC=[0.54,0.54,0.54,0.52,0.57,0.62,0.6,0.59,0.67,0.72,0.8]*0.001*384/3.2;
% R_C_SOC=[0.54,0.54,0.54,0.52,0.57,0.62,0.6,0.59,0.67,0.72,0.8]*0.001*384/3.2;
Batt_Par.soc_map=Par_Batt_Static.soc_map;
Batt_Par.R_D_SOC=Par_Batt_Static.R_D_SOC;
Batt_Par.R_C_SOC=Par_Batt_Static.R_C_SOC;
Batt_Par.voc_map=Par_Batt_Static.voc_map;
Batt_Update.Power = Power_real_Batt;
Batt_Update.SOC = SOC_real;
Batt_Update.I = I;
Batt_Update.U = U;
Batt_Par.delta_h = 0.2;% 1s
Batt_Par.enta_col = 1;

%% 采用遗传算法，对电池的开路电压、充放电内阻值的辨识
% Uoc = a1 * SOC^3 + b1 * SOC^2 + c1 * SOC + d1，辨识4个参数
% Rdis = a2 * SOC^3 + b2 * SOC^2 + c2 * SOC + d2，辨识4个参数
% Rchg = a3 * SOC^3 + b3 * SOC^2 + c3 * SOC + d3，辨识4个参数
% Q_Ah = d4, 辨识1个参数

% a1的范围
values_limt(1,1) = 8;
values_limt(2,1) = 410;
% b1的范围
values_limt(1,2) = -683;
values_limt(2,2) = -72;
% c1的范围
values_limt(1,3) = 140;
values_limt(2,3) = 400;
% d1的范围
values_limt(1,4) = 260;
values_limt(2,4) = 330;

% a2的范围
values_limt(1,5) = 0;
values_limt(2,5) = 0.5;
% b2的范围
values_limt(1,6) = 0;
values_limt(2,6) = 0.5;
% c2的范围
values_limt(1,7) = 0;
values_limt(2,7) = 0.5;
% d2的范围
values_limt(1,8) = 0;
values_limt(2,8) = 1;

% a3的范围
values_limt(1,9) = 0;
values_limt(2,9) = 0.5;
% b3的范围
values_limt(1,10) = 0;
values_limt(2,10) = 0.5;
% c3的范围
values_limt(1,11) = 0;
values_limt(2,11) = 0.5;
% d3的范围
values_limt(1,12) = 0;
values_limt(2,12) = 1;

% d4的范围
values_limt(1,13) = 220;
values_limt(2,13) = 240;

% 定义遗传算法参数
tic
str_dis = strcat('正在计算，第',num2str(0),'代，请等待........');
disp(str_dis)
NIND = 50;               % 个体数目 20-200
MAXGEN = 2;              % 最大遗传代数
NVAR = 13;                % 变量数
PRECI = 10;              % 变量的二进制位数
GGAP = 0.9;              % 代沟 
FieldD = [rep(PRECI,[1,NVAR]);values_limt;rep([1;0;1;1],[1,NVAR])];
Chrom = crtbp(NIND, NVAR*PRECI);                         % 初始种群
gen = 0;                                                 % 代数计数器
trace = zeros(MAXGEN, NVAR);                             % 追踪遗传算法结果
Batt_Parameters = bs2rv(Chrom, FieldD);                 % 计算初始种群的十进制转换 
[ObjV,sim_result] =  Program.Model_Verification.Batt.Object_Battery_GA(Batt_Parameters,Batt_Par,Batt_Update);           % 计算目标函数值
while gen < MAXGEN
    clc
    str_dis = strcat('正在计算，第',num2str(gen + 1),'代，请等待........');
    disp(str_dis)
    toc
    FitnV = ranking(ObjV);                               %分配适应度值 
    SelCh = select('sus',Chrom,FitnV,GGAP);              %选择
    SelCh = recombin('xovsp',SelCh,0.8);                 %重组
    SelCh = mut(SelCh);                                  %变异
    Batt_Parameters = bs2rv(SelCh,FieldD);               %子代十进制转换
    [ObjVSel,sim_result] =  Program.Model_Verification.Batt.Object_Battery_GA(Batt_Parameters,Batt_Par,Batt_Update); 
    [Chrom,ObjV] = reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %重插入
    gen=gen+1;
    [Y, I]=min(ObjV);
    %Y,bs2rv(Chrom(I,:),FieldD)                         %输出每一次的最优解及其对应的自变量值
    trace(gen,1)=min(ObjV);                             %遗传算法性能跟踪
    trace(gen,2)=sum(ObjV)/length(ObjV);
%     trace(gen,3:5)=Motor_Parameters(I,:);             %记下每代的最优值
%     trace(gen,6)=Y;                                   %记下每代的最优值
end

%% 理论数据加载
Batt_Pars = Batt_Par;
Batt_Pars.Q_Ah = 230;
Batt_Pars.ess_voc = interp1(Batt_Par.soc_map,Batt_Par.voc_map,SOC_real(1),'linear','extrap');
% Batt_Pars.ess_r_dis = 0.152;
% Batt_Pars.ess_r_chg = 0.152;
Batt_Pars.Soc_Pre = SOC_real(1);   % 0.4
Batt_Pars.P_BT = Batt_Update.Power(1) * 1000;     % Unit:w
Battery_Par = Program.Model_Verification.Batt.Cal_Battery_GA(Batt_Pars);
result.I = Battery_Par.I;
result.U = Battery_Par.U;
result.SOC = Battery_Par.Soc_Current;

for power_index = 2:length(Batt_Update.Power)
    Batt_Pars.P_BT = Batt_Update.Power(power_index) * 1000;     % Unit:w
    Batt_Pars.Soc_Pre = Battery_Par.Soc_Current;
    Batt_Pars.ess_voc = interp1(Batt_Par.soc_map,Batt_Par.voc_map,Battery_Par.Soc_Current,'linear','extrap');
    % Batt_Pars.ess_r_dis = 0.152;
    % Batt_Pars.ess_r_chg = 0.152;
    Battery_Par = Program.Model_Verification.Batt.Cal_Battery_GA(Batt_Pars);
    result.I(power_index) = Battery_Par.I;
    result.U(power_index) = Battery_Par.U;
    result.SOC(power_index) = Battery_Par.Soc_Current;
end




%% Result visualization
% (1) Gap between the leading vehicle and the following vehicle
figure('Name','Minimum object value for each generation','NumberTitle','off')  
RMSE = trace(end,2);
subplot(2,1,1)
plot(trace(:,2),'-r*','LineWidth',1)
grid on
legend('Average object','Location','northeast')
xlabel('Iteration Number')
ylabel('Average Object')
subplot(2,1,2)
plot(trace(:,1),'-b*','LineWidth',1)
grid on
legend('Minimum object','Location','northeast')
xlabel('Iteration Number')
ylabel('Minimum Object')

Batt_Parameters = bs2rv(Chrom,FieldD);              %子代十进制转换
a1 = Batt_Parameters(I,1);
b1 = Batt_Parameters(I,2);
c1 = Batt_Parameters(I,3);
d1 = Batt_Parameters(I,4);
a2 = Batt_Parameters(I,5);
b2 = Batt_Parameters(I,6);
c2 = Batt_Parameters(I,7);
d2 = Batt_Parameters(I,8);
a3 = Batt_Parameters(I,9);
b3 = Batt_Parameters(I,10);
c3 = Batt_Parameters(I,11);
d3 = Batt_Parameters(I,12);
Q_Ah = Batt_Parameters(I,13);
SOC_1 = 0.1:0.01:0.8;
Uoc = a1 .* SOC_1.^3 + b1 .* SOC_1.^2 + c1 .* SOC_1 + d1;
Rdis = a2 .* SOC_1.^3 + b2 .* SOC_1.^2 + c2 .* SOC_1 + d2;
Rchg = a3 .* SOC_1.^3 + b3 .* SOC_1.^2 + c3 .* SOC_1 + d3;

E_theory_real = sqrt(sum((Batt_Update.SOC -  result.SOC).^2) / length( result.SOC));
E_sim_real = sqrt(sum((Batt_Update.SOC - sim_result.SOC).^2) / length(sim_result.SOC));

%% 校核结果保存为结构体Battery_Result
Battery_Result.a1=a1;
Battery_Result.b1=b1;
Battery_Result.c1=c1;
Battery_Result.d1=d1;

Battery_Result.a2=a2;
Battery_Result.b2=b2;
Battery_Result.c2=c2;
Battery_Result.d2=d2;

Battery_Result.a3=a3;
Battery_Result.b3=b3;
Battery_Result.c3=c3;
Battery_Result.d3=d3;
Battery_Result.Q_Ah=Q_Ah;
%% 结果图绘制
figure('Name','Batt Parameters','NumberTitle','off')
subplot(311)
plot(SOC_1,Uoc,'-b')
grid on
xlabel('SOC (%)')
ylabel('Uoc (v)')
subplot(312)
plot(SOC_1,Rdis,'-k')
grid on
xlabel('SOC (%)')
ylabel('Rdis (ohm)')
subplot(313)
plot(SOC_1,Rchg,'-r')
grid on
xlabel('SOC (%)')
ylabel('Rchg (ohm)')

figure('Name','simulation vs real','NumberTitle','off')
subplot(211)
plot(Batt_Update.SOC,'-r','linewidth',1.5)
grid on
hold on
plot(sim_result.SOC,'linewidth',1.5)
hold on
plot(result.SOC,'k','linewidth',1.5)
legend('实车SOC','模型输出SOC','理论SOC')
title('蓄电池模型校核')
xlabel('time (s)')
ylabel('SOC(%)')
subplot(212)
plot(Batt_Update.I,'-r','linewidth',1.5)
grid on
hold on
plot(sim_result.I,'linewidth',1.5)
legend('实车Current','模型输出Current')
title('蓄电池模型校核')
xlabel('time (s)')
ylabel('Current(A)')
fig_name = strcat('..\..\+AppResult\+Figure\+Model_Verification\Batt\','蓄电池校核','.png');
saveas(gcf,fig_name)
