%% 可选机型

% 《EV31D1项目_磷酸铁锂_动力电池总成电芯参数表_125AH_EV31_41.86Kwh20191103》

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
BATT_4186 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 电量
BATT_4186.E = 41.86; %KWH

% 峰值放电功率

BATT_4186.P_bat_max = 87.4;                  % 电池最大放电功率，单位：kw
BATT_4186.P_bat_min = -83.7;

BATT_4186.name = 'BATT_4186';

if Choose_model == 1
    Batt{end+1} = BATT_4186;
else
    Batt{1,1} = BATT_4186;
end

Batt_name.('BATT_4186')='BATT_4186';