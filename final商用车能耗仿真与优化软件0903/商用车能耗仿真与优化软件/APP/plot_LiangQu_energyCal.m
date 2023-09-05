%% plot 能耗仿真图
%% 能耗累积图
Energy_cumul_cal=[];
for i = 1:length(energy_seq)
%     Energy_cumul_ori(i) = sum(Power_matlab_1(1:i))/3600;
    Energy_cumul_cal(i) = sum(energy_seq(1:i))/3600;
end
figure()
plot(Energy_cumul_cal,'b','LineStyle','-','LineWidth',1)
% hold on
% plot(Energy_cumul_ori,'r','LineStyle','--','LineWidth',1)
xlabel("时间/s")
ylabel("能耗累积/(kwh)")
% legend("计算能耗","原始能耗")
title("能耗累积")
axis([0 length(Energy_cumul_cal) 0 max(Energy_cumul_cal)]);

%% 电池电压曲线
figure()
plot(V_seq,'r','LineStyle','-','LineWidth',1)
title('电池电压')
xlabel('时间/s')
ylabel('电池电压/V')
% axis([0 12215 320 355]);
%% 电池电流曲线
figure()
plot(I_seq,'r','LineStyle','-','LineWidth',1)
title('电池电流')
xlabel('时间/s')
ylabel('电池电流/A')
% axis([0 12215 -180 180 ]);
%% 电池SOC曲线
figure()
plot(soc_seq,'r','LineStyle','-','LineWidth',1)
title('电池SOC')
xlabel('时间/s')
ylabel('SOC')

%% 电机工作图
% 电机转矩曲线
figure()
plot(T_Motor_seq,'r','LineStyle','-','LineWidth',1)
title('电机转矩（Nm）')
xlabel('时间/s')
ylabel('转矩/Nm')
% axis([0 12215 -150 250]);
% 电机转速曲线
plot(W_Motor_seq,'r','LineStyle','-','LineWidth',1)
title('电机转速（rpm）')
xlabel('时间/s')
ylabel('转速/rpm')
% axis([0 12215 0 16000]);
% 效率map
% W_external_extra = [W_external,14000,14500,15000,15500,16000];
W_external_extra = Motor{1,1}.mc_max_spd_dr; %  外特性查表转速（驱动）单位：rpm
% T_external_Max_extra = [T_external_Max,68, 65,62,59,56];
T_external_Max_extra = Motor{1,1}.mc_max_trq_dr; % 外特性查表转矩（驱动）单位：Nm
% T_external_Min_extra = [T_external_Min,-68, -65,-62,-59,-56];
T_external_Min_extra = -T_external_Max_extra;
figure()
[c,h]=contourf(Motor{1,1}.mc_map_spd, Motor{1,1}.mc_map_trq, (Motor{1,1}.mc_eff_map)');
set(h,'showtext','on')%显示等高线的值


hold on
% [c,h]=contourf(W_Row,-T_Col,Eff_map_Drive)
% set(h,'showtext','on')%显示等高线的值
hold on
plot(W_external_extra,T_external_Max_extra,'r','LineStyle','-','LineWidth',1 )
hold on
plot(W_external_extra,T_external_Min_extra,'r','LineStyle','-','LineWidth',1 )
hold on

for i = 1:(length(W_Motor_seq))
    text(W_Motor_seq(i),T_Motor_seq(i),'+','color','r')
    hold on
end

title("电机工作点分布")
xlabel('转速/rpm')
ylabel('转矩/Nm')
