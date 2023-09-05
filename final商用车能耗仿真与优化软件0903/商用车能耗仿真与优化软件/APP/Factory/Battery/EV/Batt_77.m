%% 可选机型

% 《EV63-24MY_EV65项目_77kWh电芯参数表 1213》

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_77 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_77.E = 77; %KWH

% 峰值放电功率

BATT_77.P_bat_max = 150;                  % 电池最大放电功率，单位：kw
BATT_77.P_bat_min = -154;                  % 电池最大充电功率，单位：kw


BATT_77.name = 'BATT_77';



%% 用于DP计算
BATT_77.ESS_SOC = 0.1:.1:0.9;
% Par_Batt.ESS_SOC = 0:0.05:1;
% Par_Batt.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
BATT_77.ESS_VOC = fliplr([3.33001	3.32901	3.32901	3.32702	3.29202	3.28901	3.28701	3.25901	3.21501]) * 332.8 / 3.2; % 开路电压：放电
% Par_Batt.ESS_R_D = fliplr([0.259286 0.247857 0.235714 0.227143 0.223571 0.221429 0.22 0.217143 0.212143]);
BATT_77.ESS_R_D = [0.54
0.54
0.52
0.57
0.62
0.6
0.59
0.67
0.73
]' * 10^(-3) * 332.8 / 3.2; % 电池放电内阻
BATT_77.ESS_R_C = BATT_77.ESS_R_D; %电池充电内阻

BATT_77.Q_Ah = 230;
BATT_77.Col_Eff = 1;    
BATT_77.Ts = 1;
BATT_77.SOC_Max = 1;
BATT_77.SOC_Min = 0.04;
% Par_Batt.P_Batt_Max = 100000;
BATT_77.P_Batt_Max = 150000;
% Par_Batt.P_Batt_Min = -20000;
BATT_77.P_Batt_Min = -135000;
% Par_Batt.I_Max = 2000;
BATT_77.I_Max = 460;
% Par_Batt.I_Min = -2000;
BATT_77.I_Min = -200;

%% 汇总

Batt_name.('BATT_77')='BATT_77';

if Choose_model == 1
    Batt{end+1} = BATT_77;
else
    Batt{1,1} = BATT_77;
end



