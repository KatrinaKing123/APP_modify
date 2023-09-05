%% 可选机型

% 《EV31C1-23MY项目_动力电池总成电芯参数表_150AH_EV31_50.23Kwh20191103》

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_5023 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_5023.E = 50.23; %KWH

% 峰值放电功率

BATT_5023.P_bat_max = 87.4;                  % 电池最大放电功率，单位：kw
BATT_5023.P_bat_min = -100.5;                % 电池最大充电功率，单位：kw

BATT_5023.name = 'BATT_5023';

if Choose_model == 1
    Batt{end+1} = BATT_5023;
else
    Batt{1,1} = BATT_5023;
end

Batt_name.('BATT_5023')='BATT_5023';