function EV = Cal_EV_Model(velocity,Index_Start, Index_End,Para)
%%  Load  driving cycle
% load(Data_Path.Cycle_Data_Path)
Cyc_Velocity =     velocity(Index_Start : Index_End)'/3.6;      % Unit: m/s
Cyc_Acceleration = [diff(Cyc_Velocity),0];                            % Unit: m/s^2

%% Vehicle Dynamics Model Design
% (1) Parameter Initialization
EV.VehBody  = VehFactory.VehBody(Para.Par_Veh);
EV.Brake    = VehFactory.Brake(Para.Par_Brake);
EV.Wheel    = VehFactory.Wheel(Para.Par_Wheel);
EV.Finala   = VehFactory.Final(Para.Par_Finala);
EV.Finalb   = VehFactory.Final(Para.Par_Finalb);
% EV.GearBox  = VehFactory.GearBox(Par_Gear);
EV.Motor1    = VehFactory.Motor(Para.Par_Motor1);
EV.Motor2    = VehFactory.Motor(Para.Par_Motor2);
EV.Batt     = VehFactory.Batt(Para.Par_Batt);
EV.Distance = sum(Cyc_Velocity);
EV.Paux = Para.Paux;

% (2) Calculation Step by Step
EV.Cycle_Num = length(Cyc_Velocity);
% EV.Result.P_Drive_Demand = zeros(1,EV.Cycle_Num);
% EV.Result.Tf = zeros(1,EV.Cycle_Num);
% EV.Result.Wf = zeros(1,EV.Cycle_Num);
EV.Result.Tw = zeros(1,EV.Cycle_Num);
EV.Result.Ww = zeros(1,EV.Cycle_Num);
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
    EV.Wheel.Cal_Wheel(EV.Brake)%得到F_t，Ft包括未制动时的主减速器输入端需要的牵引力和制动时需要的总的制动力
    % (4) Cal_Final
%     EV.Final.Cal_Final(EV.Wheel)

    %% Save Data
%     EV.Result.Tf(Step) = EV.Final.Tf;
%     EV.Result.Wf(Step) = EV.Final.Wf;
    EV.Result.Tw(Step) = EV.Wheel.Tw;
    EV.Result.Ww(Step) = EV.Wheel.Ww;
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
EV.Batt.Deta_SOC_Max = max(EV.Batt.SOC_K_1 - EV.Batt.SOC_K);

end






