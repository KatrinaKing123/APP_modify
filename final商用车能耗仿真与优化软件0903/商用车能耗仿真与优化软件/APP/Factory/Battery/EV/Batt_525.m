%% 可选机型

% 《EV31C1-22MY_52.5kWh三元锂电池_SDT_153Ah_Input Data of BMS Calibration_V6.4_CATL _20200826》

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_525 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_525.E = 52.5; %KWH

% 峰值放电功率

BATT_525.P_bat_max = 208;                  % 电池最大放电功率，单位：kw
BATT_525.P_bat_min = -103;                 % 电池最大充电功率，单位：kw

BATT_525.name = 'BATT_525';


%% 用于计算DP
BATT_525.ESS_SOC = 0.1:.1:0.9;
% BATT_525.ESS_SOC = 0:0.05:1;
% BATT_525.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
BATT_525.ESS_VOC = fliplr([4.125 

3.997 

3.884 

3.780 

3.676 

3.632 

3.602 
3.551 
3.473 
]') * 95.946;
% BATT_525.ESS_R_D = fliplr([0.259286 0.247857 0.235714 0.227143 0.223571 0.221429 0.22 0.217143 0.212143]);
BATT_525.ESS_R_D = fliplr([0.63
0.62
0.61
0.60
0.60
0.60
0.61
0.80
1.00
]') * 10^(-3) * 95.945;
BATT_525.ESS_R_C = fliplr([0.67
0.65
0.65
0.65
0.64
0.64
0.64
0.68
0.71
]')* 10^(-3) * 95.945;
% BATT_525.Q_Ah = 40;
BATT_525.Q_Ah = 153;
BATT_525.Col_Eff = 1;    
BATT_525.Ts = 1;
% BATT_525.SOC_Max = 0.90;
BATT_525.SOC_Max = 0.975;
% BATT_525.SOC_Min = 0.20;
BATT_525.SOC_Min = 0.05;
% BATT_525.P_Batt_Max = 100000;
BATT_525.P_Batt_Max = 208000;
% BATT_525.P_Batt_Min = -20000;
BATT_525.P_Batt_Min = -10300;
% BATT_525.I_Max = 2000;
BATT_525.I_Max = 775;
% BATT_525.I_Min = -2000;
BATT_525.I_Min = -320;


if Choose_model == 1
    Batt{end+1} = BATT_525;
else
    Batt{1,1} = BATT_525;
end

Batt_name.('BATT_525')='BATT_525';