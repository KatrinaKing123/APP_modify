%% 可选机型



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_FCS_power_1 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_FCS_power_1.E = 12.95; %

% 峰值放电功率

BATT_FCS_power_1.P_bat_max = 249;                  % 电池最大放电功率，单位：kw随便写的，见附表-2s功率
BATT_FCS_power_1.P_bat_min = -65;                   % 电池最大充电功率，单位：kw
BATT_FCS_power_1.P_bat_PFCE = 0;%非燃料电池
BATT_FCS_power_1.name = 'BATT_FCS_power_1';

Batt{end+1} = BATT_FCS_power_1;

Batt_name.('BATT_FCS_power_1')='BATT_FCS_power_1';