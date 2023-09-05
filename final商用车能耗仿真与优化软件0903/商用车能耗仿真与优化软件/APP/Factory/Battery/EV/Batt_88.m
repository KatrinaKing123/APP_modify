%% 可选机型

% 《EV63-24MY_EV65项目_88kWh电芯参数表1213》

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_88 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_88.E = 88; %KWH

% 峰值放电功率

BATT_88.P_bat_max = 170;                  % 电池最大放电功率，单位：kw
BATT_88.P_bat_min = -150;                 % 电池最大充电功率，单位：kw

BATT_88.name = 'BATT_88';

%% 用于DP计算
BATT_88.ESS_SOC = 0.1:.1:0.9;
% Par_Batt.ESS_SOC = 0:0.05:1;
% Par_Batt.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
BATT_88.ESS_VOC = fliplr([3.33001 3.32901	3.32901	3.32702	3.29202	3.28901	3.28701	3.25901	3.21501
])*384/3.2; % 开路电压：放电
% Par_Batt.ESS_R_D = fliplr([0.259286 0.247857 0.235714 0.227143 0.223571 0.221429 0.22 0.217143 0.212143]);
BATT_88.ESS_R_D = [0.54
0.54
0.52
0.57
0.62
0.6
0.59
0.67
0.73
]' * 10^(-3) * 384/3.2; % 电池放电内阻
BATT_88.ESS_R_C = BATT_88.ESS_R_D; %电池充电内阻

BATT_88.Q_Ah = 230;
BATT_88.Col_Eff = 1;    
BATT_88.Ts = 1;
BATT_88.SOC_Max = 1;
BATT_88.SOC_Min = 0.04;
% Par_Batt.P_Batt_Max = 100000;
BATT_88.P_Batt_Max = 170000;
% Par_Batt.P_Batt_Min = -20000;
BATT_88.P_Batt_Min = -150000;
% Par_Batt.I_Max = 2000;
BATT_88.I_Max = 500;
% Par_Batt.I_Min = -2000;
BATT_88.I_Min = -500;

%% 汇总
if Choose_model == 1
    Batt{end+1} = BATT_88;
else
    Batt{1,1} = BATT_88;
end

Batt_name.('BATT_88')='BATT_88';