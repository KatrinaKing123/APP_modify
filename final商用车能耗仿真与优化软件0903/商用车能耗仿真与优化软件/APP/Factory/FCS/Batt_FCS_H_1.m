%% 可选机型



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_FCS_H_1 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_FCS_H_1.E = 42; %KWH 随便写的

% 峰值放电功率

BATT_FCS_H_1.P_bat_max = 0;                  % 非动力电池
BATT_FCS_H_1.P_bat_min = -65;                   % 电池最大充电功率，单位：kw
BATT_FCS_H_1.P_bat_PFCE = 60;%燃料电池
BATT_FCS_H_1.name = 'BATT_FCS_H_1';

FCS{end+1} = BATT_FCS_H_1;

FCS_name.('BATT_FCS_H_1')='BATT_FCS_H_1';