%% Electric Vehicle Parameters 
% Authors    : Wei Zhou, Lin Yang, Yishan Cai, Tianxing Ying
% Date        : 2018-03-20 21:21:40
% Organization: Shanghai JiaoTong University

%% Simulation Step Time
Ts = 1;                                                                    % Unit: s
Para=struct;
%% Vehicle Parameters
Para.Par_Veh.Gravity = gravity_acc;                                                    % Gravitational acceleration, Unit: m/s^2
Para.Par_Veh.Air_Density =air_density;                                                  % Air Density, Unit: kg/m^3
Para.Par_Veh.M_F = m_calcu;                                                        % Weight, Unit: kg      
Para.Par_Veh.Cd = wind_coeff;                                                         % Air Resistance Coefficient
Para.Par_Veh.A_F = wind_area;                                                        % Windward Area, Unit: m^2
Para.Par_Veh.Mu = rolling_coeff;                                                       % Rolling Resistance Coefficient
Para.Par_Veh.Grade = slope;                                                         % Rotation Coefficient
Para.Par_Veh.mt2m_f = rotation_converse_coeff-1;
Para.Par_Veh.L = wheel_base;                                                         % Front and back axis length, Unit: m
Para.Par_Veh.a = forward_distance;                                                         % Center line distance of the center of mass to the center of the front axis, Unit: m
Para.Par_Veh.b = Para.Par_Veh.L - Para.Par_Veh.a ;                                        % Center line distance of the center of mass to the center of the rear axle, Unit: m
Para.Par_Veh.hg = hg_calcu;                                                        % Centroid Height, Unit: m
Para.Par_Veh.Coefficient = adhesion_coeff;                                                 % Road adhesion coefficient

%% Brake Parameters
% Par_Brake.Beta = (Par_Veh.Coefficient * Par_Veh.hg + Par_Veh.b) / Par_Veh.L; % Braking force distribution
Para.Par_Brake.Brake_Speed_Limit = 10;                                            % When Speed is lower than 10 km/h, mechanical braking 
Para.Par_Brake.Elec_Brake_Dec_Limit = -2;                                         % When Dec is lower than -2 m/s^2, mechanical braking 

%% Wheel Parameters  
Para.Par_Wheel.R = radius_wheel;                                           % Wheel Radius, Unit: m

%% Final Parameters
Para.Par_Finala.Ratio = final_front_ratio;     % Drive ratio of main decelerator
Para.Par_Finalb.Ratio = final_rear_ratio;      
Para.Par_Finala.Eff = final_front_eff;                                          % Efficiency
Para.Par_Finalb.Eff = final_rear_eff;    
%% Gearbox Parameters 
% Par_Gear.Index = [1 2 3 4 5];                                       % Drive ratio of main decelerator
% Par_Gear.Ratio = [6.9 4.13 2.45 1.49 1.00];                                          % Efficiency
% Par_Gear.Eff = 0.97;

%% Motor Parameters
% str1=strcat(Front_Motor_name(1:end-2),'_s');
% Speed1 = eval(str1).mc_map_spd *(2*pi/60); 
Speed1 = Motor_front{1,1}.mc_map_spd *(2*pi/60); 

% T_col1=eval(str1).mc_map_trq;
T_col1=Motor_front{1,1}.mc_map_trq;

% Torq_Max1 = eval(str1).mc_max_trq_dr; 
Torq_Max1 = Motor_front{1,1}.mc_max_trq_dr;     

% Torq_Min1 = eval(str1).mc_max_gen_trq;  
Torq_Min1 = Motor_front{1,1}.mc_max_gen_trq;
% Speed1_max=eval(str1).mc_max_spd_dr;
% Speed1_min=eval(str1).mc_max_spd_br;

Speed1_max=Motor_front{1,1}.mc_max_spd_dr;
Speed1_min=Motor_front{1,1}.mc_max_spd_br;


% Eff_map_1=eval(str1).mc_eff_map';
Eff_map_1=Motor_front{1,1}.mc_eff_map';

if Speed1_min(1)~=0
    Speed1_min=[0,Speed1_min];
    Torq_Min1=[Torq_Min1(1),Torq_Min1];
end
if Speed1_max(1)~=0
    Speed1_max=[0,Speed1_max];
    Torq_Max1=[Torq_Max1(1),Torq_Max1];
end


% str2=strcat(Rear_Motor_name(1:end-2),'_s');
% Speed2 = eval(str2).mc_map_spd *(2*pi/60);
Speed2 = Motor_rear{1,1}.mc_map_spd*(2*pi/60);

% T_col2 = eval(str2).mc_map_trq;
T_col2 = Motor_rear{1,1}.mc_map_trq;

% Torq_Max2 = eval(str2).mc_max_trq_dr;     
Torq_Max2 = Motor_rear{1,1}.mc_max_trq_dr;     

% Torq_Min2 = Motor_rear.mc_max_gen_trq; 
Torq_Min2 = Motor_rear{1,1}.mc_max_gen_trq; 

% Speed2_max=eval(str2).mc_max_spd_dr;
% Speed2_min=eval(str2).mc_max_spd_br;

Speed2_max=Motor_rear{1,1}.mc_max_spd_dr;
Speed2_min=Motor_rear{1,1}.mc_max_spd_br;

% Eff_map_2=eval(str2).mc_eff_map';
Eff_map_2 = Motor_rear{1,1}.mc_eff_map';
if Speed2_min(1)~=0
    Speed2_min=[0,Speed2_min];
    Torq_Min2=[Torq_Min2(1),Torq_Min2];
end
if Speed2_max(1)~=0
    Speed2_max=[0,Speed2_max];
    Torq_Max2=[Torq_Max2(1),Torq_Max2];
end



Para.Par_Motor1.Speed = Speed1;
Para.Par_Motor1.W_Row = Speed1;
Para.Par_Motor1.T_Col = T_col1;
Para.Par_Motor1.Trq_Min = Torq_Min1;
Para.Par_Motor1.Trq_Max = Torq_Max1;
Para.Par_Motor1.speed_min=Speed1_min;
Para.Par_Motor1.speed_max=Speed1_max;
Para.Par_Motor1.Eff_map = Eff_map_1;


Para.Par_Motor2.Speed = Speed2;
Para.Par_Motor2.W_Row = Speed2;
Para.Par_Motor2.T_Col = T_col2;
Para.Par_Motor2.Trq_Min = Torq_Min2;
Para.Par_Motor2.Trq_Max = Torq_Max2;
Para.Par_Motor2.speed_min=Speed2_min;
Para.Par_Motor2.speed_max=Speed2_max;
Para.Par_Motor2.Eff_map = Eff_map_2;
%% Battery Parameters
% str3=strcat(battery_name(1:end-2),'_s');
% Para.Par_Batt.ESS_SOC = eval(str3).ESS_SOC;
Para.Par_Batt.ESS_SOC = Batt{1,1}.ESS_SOC;

% Para.Par_Batt.ESS_VOC = eval(str3).ESS_VOC;
Para.Par_Batt.ESS_VOC = Batt{1,1}.ESS_VOC;

% Para.Par_Batt.ESS_R_C = eval(str3).ESS_R_C;
Para.Par_Batt.ESS_R_C = Batt{1,1}.ESS_R_C;

% Para.Par_Batt.ESS_R_D = eval(str3).ESS_R_D;
Para.Par_Batt.ESS_R_D = Batt{1,1}.ESS_R_D;

% Para.Par_Batt.Q_Ah = eval(str3).Q_Ah;
Para.Par_Batt.Q_Ah = Batt{1,1}.Q_Ah;

% Para.Par_Batt.Col_Eff = eval(str3).Col_Eff;    
Para.Par_Batt.Col_Eff = Batt{1,1}.Col_Eff;    

Para.Par_Batt.Ts = 1;
% Para.Par_Batt.SOC_Max = eval(str3).SOC_Max;
Para.Par_Batt.SOC_Max =  Batt{1,1}.SOC_Max;

% Para.Par_Batt.SOC_Min = eval(str3).SOC_Min;
Para.Par_Batt.SOC_Min = Batt{1,1}.SOC_Min;

% Para.Par_Batt.P_Batt_Max = eval(str3).P_Batt_Max;
Para.Par_Batt.P_Batt_Max = Batt{1,1}.P_Batt_Max;

% Para.Par_Batt.P_Batt_Min = eval(str3).P_Batt_Min;
Para.Par_Batt.P_Batt_Min = Batt{1,1}.P_Batt_Min;

% Para.Par_Batt.I_Max = eval(str3).I_Max;
Para.Par_Batt.I_Max = Batt{1,1}.I_Max;

% Para.Par_Batt.I_Min = eval(str3).I_Min;
Para.Par_Batt.I_Min = Batt{1,1}.I_Min;


%% Other Parameters
Para.Paux = p_auxiliary;
