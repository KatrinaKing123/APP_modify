function EV = Cal_EV_Model(Index_Start, Index_End, velocity, Gear, Motor, Batt)
%%  Load  driving cycle
% load(Data_Path.Cycle_Data_Path)
Cyc_Velocity =     velocity(Index_Start : Index_End)'/3.6;      % Unit: m/s
Cyc_Acceleration = [diff(Cyc_Velocity),0];                            % Unit: m/s^2

%% 赋值全局变量
global gravity_acc
global m_calcu
global wind_coeff
global wind_area
global rolling_coeff
global rotation_converse_coeff
global wheel_base
global forward_distance
global hg_calcu
global radius_wheel
global final_ratio
global final_eff
global air_density
global slope
global adhesion_coeff

%% Load Vehicle Parameter 
LiangQu_MoreGear.VehParameters.EV_Par; 

%% Vehicle Dynamics Model Design
% (1) Parameter Initialization
EV.VehBody  = LiangQu_MoreGear.VehFactory.VehBody(Par_Veh);
EV.Brake    = LiangQu_MoreGear.VehFactory.Brake(Par_Brake);
EV.Wheel    = LiangQu_MoreGear.VehFactory.Wheel(Par_Wheel);
EV.Final    = LiangQu_MoreGear.VehFactory.Final(Par_Final);
EV.GearBox  = LiangQu_MoreGear.VehFactory.GearBox(Par_Gear);
EV.Motor    = LiangQu_MoreGear.VehFactory.Motor(Par_Motor);
EV.Batt     = LiangQu_MoreGear.VehFactory.Batt(Par_Batt);
EV.Distance = sum(Cyc_Velocity);
EV.Paux = Paux;

% (2) Calculation Step by Step
EV.Cycle_Num = length(Cyc_Velocity);
EV.Result.P_Drive_Demand = zeros(1,EV.Cycle_Num);
EV.Result.Tf = zeros(1,EV.Cycle_Num);
EV.Result.Wf = zeros(1,EV.Cycle_Num);
EV.Result.Velocity = zeros(1,EV.Cycle_Num);
EV.Result.Acceleration = zeros(1,EV.Cycle_Num);
for Step = 1 : EV.Cycle_Num
    %% Data Input
    EV.VehBody.Velocity = Cyc_Velocity(Step);
    EV.VehBody.Acceleration = Cyc_Acceleration(Step);
    
    %% Calculate 
    % (1) Cal_VehBody
    EV.VehBody.Cal_VehBody()
    % (2) Cal_Brake
    EV.Brake.Cal_Brake(EV.VehBody)
    % (3) Cal_Wheel
    EV.Wheel.Cal_Wheel(EV.Brake)
    % (4) Cal_Final
    EV.Final.Cal_Final(EV.Wheel)

    %% Save Data
    EV.Result.Tf(Step) = EV.Final.Tf;
    EV.Result.Wf(Step) = EV.Final.Wf;
    EV.Result.Velocity(Step) = Cyc_Velocity(Step);
    EV.Result.Acceleration(Step) = Cyc_Acceleration(Step);

end
%% Determinate the maximum and minimum variation of SOC
% (1) Minimum
EV.Batt.P_Batt_K = EV.Batt.P_Batt_Max;
EV.Batt.SOC_K = EV.Batt.ESS_SOC;
EV.Batt.Cal_SOC();
EV.Batt.Deta_SOC_Min = min(EV.Batt.SOC_K_1 - EV.Batt.SOC_K);
% (2) Maxmim
EV.Batt.P_Batt_K = EV.Batt.P_Batt_Min;
EV.Batt.SOC_K = EV.Batt.ESS_SOC;
EV.Batt.Cal_SOC();
EV.Batt.Deta_SOC_Max = min(EV.Batt.SOC_K_1 - EV.Batt.SOC_K);

end






