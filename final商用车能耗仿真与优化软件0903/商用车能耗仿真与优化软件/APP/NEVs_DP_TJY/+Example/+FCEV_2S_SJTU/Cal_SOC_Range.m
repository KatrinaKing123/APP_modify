function FCEV = Cal_SOC_Range(Cyc_Velocity,SOC_Init, SOC_End_Deta)
%%  Load  driving cycle
% load(Cycle_Data_Path)
% Cyc_Velocity =     velocity(Index_Start : Index_End)'/3.6;      % Unit: m/s
Cyc_Acceleration = [diff(Cyc_Velocity);0];                            % Unit: m/s^2

%% Load Vehicle Parameter
VehParameters.FCEV_Par; 

%% Vehicle Dynamics Model Design
% (1) Parameter Initialization
FCEV.VehBody  =VehFactory.VehBody(Par_Veh);
FCEV.Brake    =VehFactory.Brake(Par_Brake);
FCEV.Wheel    =VehFactory.Wheel(Par_Wheel);
FCEV.Final    =VehFactory.Final(Par_Final);
FCEV.Motor    =VehFactory.Motor(Par_Motor);
FCEV.Batt     =VehFactory.Batt(Par_Batt);
FCEV.DCF      =VehFactory.DCF(Par_DCF);
FCEV.FCS      =VehFactory.FCS(Par_FCS);
FCEV.Paux     = Paux;
FCEV.Distance = sum(Cyc_Velocity);

% (2) Calculation Step by Step
FCEV.Cycle_Num = length(Cyc_Velocity);
FCEV.Result.P_Demand = zeros(1,FCEV.Cycle_Num);

for Step = 1 : FCEV.Cycle_Num
    %% Data Input
    FCEV.VehBody.Velocity = Cyc_Velocity(Step);
    FCEV.VehBody.Acceleration = Cyc_Acceleration(Step);
    
    %% Calculate  
    % (1) Cal_VehBody
    FCEV.VehBody.Cal_VehBody()
    % (2) Cal_Brake
    FCEV.Brake.Cal_Brake(FCEV.VehBody)
    % (3) Cal_Wheel
    FCEV.Wheel.Cal_Wheel(FCEV.Brake)
    % (4) Cal_Final
    FCEV.Final.Cal_Final(FCEV.Wheel)
    % (5) Cal_Motor
    FCEV.Motor.Tm = FCEV.Final.Tf;
    FCEV.Motor.Wm = FCEV.Final.Wf;
    FCEV.Motor.Cal_Motor()

    %% Save Data
    FCEV.Result.P_Demand(Step) = FCEV.Motor.P_EM + FCEV.Paux;
end

%% Determinate the maximum and minimum variation of SOC
% (1) Minimum
FCEV.Batt.P_Batt_K = FCEV.Batt.P_Batt_Max;
FCEV.Batt.SOC_K = FCEV.Batt.ESS_SOC;
FCEV.Batt.Cal_SOC();
FCEV.Batt.Deta_SOC_Min = min(FCEV.Batt.SOC_K_1 - FCEV.Batt.SOC_K);
% (2) Maxmim
FCEV.Batt.P_Batt_K = FCEV.Batt.P_Batt_Min;
FCEV.Batt.SOC_K = FCEV.Batt.ESS_SOC;
FCEV.Batt.Cal_SOC();
FCEV.Batt.Deta_SOC_Max = min(FCEV.Batt.SOC_K_1 - FCEV.Batt.SOC_K);

%% Determinate SOC range
FCEV.SOC_Init = SOC_Init;
FCEV.SOC_End = SOC_Init;
FCEV.SOC_End_Deta = SOC_End_Deta;
% (1) Calculat the maximun and minimum powerof battery
a = FCEV.FCS.FCS_AUX_P1;
b = FCEV.FCS.FCS_AUX_P2 - FCEV.DCF.FCS2DCF_P1;
c = FCEV.Result.P_Demand + FCEV.FCS.FCS_AUX_P3 - FCEV.DCF.FCS2DCF_P2;
Symm_Axis = - b / (2 * a);
if Symm_Axis > FCEV.FCS.FCS_P_Max
    P_Batt_Min_FCS = a .* FCEV.FCS.FCS_P_Max  .* FCEV.FCS.FCS_P_Max  + b .* FCEV.FCS.FCS_P_Max  + c;
    P_Batt_Max_FCS = a .* FCEV.FCS.FCS_P_Idle .* FCEV.FCS.FCS_P_Idle + b .* FCEV.FCS.FCS_P_Idle + c;
end
P_Batt_Max = min(P_Batt_Max_FCS,FCEV.Batt.P_Batt_Max);
P_Batt_Min = max(P_Batt_Min_FCS,FCEV.Batt.P_Batt_Min);
% (2) SOC Range
List_SOC_UP_S = zeros(1,FCEV.Cycle_Num);
List_SOC_Down_S = zeros(1,FCEV.Cycle_Num);
List_SOC_UP_R = zeros(1,FCEV.Cycle_Num);
List_SOC_Down_R = zeros(1,FCEV.Cycle_Num);
FCEV.Batt.SOC_K = FCEV.SOC_Init;
for Step = 1 : FCEV.Cycle_Num
    List_SOC_UP_S(Step) = FCEV.Batt.SOC_K;
    FCEV.Batt.P_Batt_K = P_Batt_Min(Step);
    FCEV.Batt.Cal_SOC()
    FCEV.Batt.SOC_K = (FCEV.Batt.SOC_K_1 >  FCEV.Batt.SOC_Max) .* FCEV.Batt.SOC_Max + ...
                      (FCEV.Batt.SOC_K_1 <= FCEV.Batt.SOC_Max) .* FCEV.Batt.SOC_K_1; 
end
FCEV.Batt.SOC_K = FCEV.SOC_Init;
for Step = 1 : FCEV.Cycle_Num
    List_SOC_Down_S(Step) = FCEV.Batt.SOC_K;
    FCEV.Batt.P_Batt_K = P_Batt_Max(Step);
    FCEV.Batt.Cal_SOC()
    FCEV.Batt.SOC_K = (FCEV.Batt.SOC_K_1 <  FCEV.Batt.SOC_Min) .* FCEV.Batt.SOC_Min + ...
                      (FCEV.Batt.SOC_K_1 >= FCEV.Batt.SOC_Min) .* FCEV.Batt.SOC_K_1; 
end
FCEV.Batt.SOC_K_1 = FCEV.SOC_End + FCEV.SOC_End_Deta / 2;
for Step = FCEV.Cycle_Num : -1 : 1
    List_SOC_UP_R(Step) = FCEV.Batt.SOC_K_1;
    FCEV.Batt.P_Batt_K = P_Batt_Max(Step);
    FCEV.Batt.Cal_SOC_R()
    FCEV.Batt.SOC_K_1 = (FCEV.Batt.SOC_K <  FCEV.Batt.SOC_Min) .* FCEV.Batt.SOC_Min + ...
                        (FCEV.Batt.SOC_K >= FCEV.Batt.SOC_Min) .* FCEV.Batt.SOC_K;
end
FCEV.Batt.SOC_K_1 = FCEV.SOC_End - FCEV.SOC_End_Deta / 2;
for Step = FCEV.Cycle_Num : -1 : 1
    List_SOC_Down_R(Step) = FCEV.Batt.SOC_K_1;
    FCEV.Batt.P_Batt_K = P_Batt_Min(Step);
    FCEV.Batt.Cal_SOC_R()
    FCEV.Batt.SOC_K_1 = (FCEV.Batt.SOC_K >  FCEV.Batt.SOC_Max) .* FCEV.Batt.SOC_Max + ...
                        (FCEV.Batt.SOC_K <= FCEV.Batt.SOC_Max) .* FCEV.Batt.SOC_K; 
end
% FCEV.Result.SOC_Limt_Up = min(List_SOC_UP_S,List_SOC_UP_R);
% FCEV.Result.SOC_Limt_Down = max(List_SOC_Down_S,List_SOC_Down_R);
FCEV.Result.SOC_Limt_Up = min(List_SOC_UP_S,List_SOC_UP_R);
FCEV.Result.SOC_Limt_Down = max(List_SOC_Down_S,List_SOC_Down_R);
end



