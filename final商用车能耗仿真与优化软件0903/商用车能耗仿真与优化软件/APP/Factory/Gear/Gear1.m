%% Gearbox Parameters，也可用于dp计算
GEAR1 = struct;
GEAR1.Index = [1 2 3];                                       % Drive ratio of main decelerator
GEAR1.Ratio = [2.5, 1.8, 0.7];                                          % Efficiency
GEAR1.Eff = 1;
GEAR1.name = 'Gear1';

%% 汇总

if Choose_model == 1
    Gear{end+1} = GEAR1;
else
    Gear{1,1} = GEAR1;
end

Gear_name.('GEAR1')='GEAR1'; 