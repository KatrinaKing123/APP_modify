%% Fuel Cell Electric Vehicle Parameters 
% Authors    : Wei Zhou, Lin Yang, Yishan Cai, Tianxing Ying
% Date        : 2018-03-20 21:21:40
% Organization: Shanghai JiaoTong University

%% Simulation Step Time
Ts = 1;                                                                    % Unit: s

%% Vehicle Parameters
Par_Veh.Gravity = 9.81;                                                    % Gravitational acceleration, Unit: m/s^2
Par_Veh.Air_Density =1.2;                                                  % Air Density, Unit: kg/m^3
Par_Veh.M_F = 2000;                                                        % Weight, Unit: kg      
Par_Veh.Cd = 0.31;                                                         % Air Resistance Coefficient
Par_Veh.A_F = 2.18;                                                        % Windward Area, Unit: m^2
Par_Veh.Mu = 0.0086;                                                       % Rolling Resistance Coefficient
Par_Veh.Grade = 0;                                                         % Rotation Coefficient
Par_Veh.mt2m_f = 0.03;
Par_Veh.L = 2.700;                                                         % Front and back axis length, Unit: m
Par_Veh.a = 1.244;                                                         % Center line distance of the center of mass to the center of the front axis, Unit: m
Par_Veh.b = Par_Veh.L - Par_Veh.a ;                                        % Center line distance of the center of mass to the center of the rear axle, Unit: m
Par_Veh.hg = 0.196;                                                        % Centroid Height, Unit: m
Par_Veh.Coefficient = 0.8;                                                 % Road adhesion coefficient

%% Brake Parameters
Par_Brake.Beta = (Par_Veh.Coefficient * Par_Veh.hg + Par_Veh.b) / Par_Veh.L; % Braking force distribution
Par_Brake.Brake_Speed_Limit = 10;                                            % When Speed is lower than 10 km/h, mechanical braking 
Par_Brake.Elec_Brake_Dec_Limit = -2;                                         % When Dec is lower than -2 m/s^2, mechanical braking 

%% Wheel Parameters  
Par_Wheel.R = 0.316;                                           % Wheel Radius, Unit: m

%% Final Parameters
Par_Final.Ratio = 8.928;                                       % Drive ratio of main decelerator
Par_Final.Eff = 0.97;                                          % Efficiency

%% Motor Parameters
Par_Motor.Speed = [0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11500]*(2*pi/60);       % Unit: rad/s
Par_Motor.Trq_Max = [200 200 200 175.2 131.4 105.1 87.6 75.1 65.7 58.4 52.4 50.5]*1.075;        % Unit: Nm
Par_Motor.Trq_Min = -Par_Motor.Trq_Max;                                                         % Unit: Nm
Par_Motor.W_Row = [0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11500]*(2*pi/60);  
Par_Motor.T_Col = [-215 -200 -180 -160 -140 -120 -100 -80 -60 -40 -20 ...
                    0 20 40 60 80 100 120 140 160 180 200 215];                             
Par_Motor.Eff_map = [...
0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7
0.78	0.78	0.78	0.79	0.8	0.81	0.82	0.82	0.82	0.81	0.77	0.7	0.77	0.81	0.82	0.82	0.82	0.81	0.8	0.79	0.78	0.78	0.78
0.85	0.85	0.86	0.86	0.86	0.87	0.88	0.87	0.86	0.85	0.82	0.7	0.82	0.85	0.86	0.87	0.88	0.87	0.86	0.86	0.86	0.85	0.85
0.86	0.86	0.87	0.88	0.89	0.9	0.9	0.9	0.9	0.89	0.87	0.7	0.87	0.89	0.9	0.9	0.9	0.9	0.89	0.88	0.87	0.86	0.86
0.81	0.81	0.82	0.85	0.87	0.88	0.9	0.91	0.91	0.91	0.88	0.7	0.88	0.91	0.91	0.91	0.9	0.88	0.87	0.85	0.82	0.81	0.81
0.82	0.82	0.82	0.82	0.82	0.85	0.87	0.9	0.91	0.91	0.89	0.7	0.89	0.91	0.91	0.9	0.87	0.85	0.82	0.82	0.82	0.82	0.82
0.79	0.79	0.79	0.79	0.78	0.79	0.82	0.86	0.9	0.91	0.9	0.7	0.9	0.91	0.9	0.86	0.82	0.79	0.78	0.79	0.79	0.79	0.79
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.88	0.91	0.91	0.7	0.91	0.91	0.88	0.8	0.78	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.9	0.92	0.7	0.92	0.9	0.8	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.88	0.92	0.7	0.92	0.88	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.92	0.7	0.92	0.8	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.92	0.7	0.92	0.2	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78
];

%% Battery Parameters
Par_Batt.ESS_SOC = 0.1:.1:0.9;
Par_Batt.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
Par_Batt.ESS_R_D = fliplr([0.259286 0.247857 0.235714 0.227143 0.223571 0.221429 0.22 0.217143 0.212143]);
Par_Batt.ESS_R_C = fliplr([0.235333 0.228333 0.222667 0.217667 0.219333 0.224667 0.232 0.242 0.270333]);
Par_Batt.Q_Ah = 16;
Par_Batt.Col_Eff = 0.95;% 0.95;    
Par_Batt.Ts = Ts;
Par_Batt.SOC_Max = 0.65;
Par_Batt.SOC_Min = 0.55;
Par_Batt.P_Batt_Max = 75000;
Par_Batt.P_Batt_Min = -35000;
Par_Batt.I_Max = 200;
Par_Batt.I_Min = -200;


%% DCF Parameters
% FCS_Power = [6.198 9.054 11.849 17.414 22.836 28.203 33.321 38.228 42.664 44.892] * 1000;     % w
% FCS_H2_Eff = 0.98 * [66.92 65.17 63.96 62.67 61.63 60.90 59.96 58.96 57.58 57.02] / 100;     
% FCS_DCF_Eff = [0.91   0.9257	 0.9467	 0.954	 0.952	0.9533	0.9609	0.9529	0.951   0.96];
% FCS_AUX = [0.7 1 1.3 1.9 2.4 3.4 4.6 5.4 6.3 6.9] * 1000;                                      % w
Par_DCF.FCS2DCF_P1 = 0.9623;
Par_DCF.FCS2DCF_P2 = -247.1;

%% FCS Parameters
Par_FCS.FCS_H2_P1 = 5.403e-11;
Par_FCS.FCS_H2_P2 = 1.24e-05;
Par_FCS.FCS_H2_P3 = 0.001794;
Par_FCS.FCS_AUX_P1 = 2.151e-06;
Par_FCS.FCS_AUX_P2 = 0.04946;
Par_FCS.FCS_AUX_P3 = 347.2;
Par_FCS.FCS_P_Min = 0;
Par_FCS.FCS_P_Idle = 5000;             % w
Par_FCS.FCS_P_Max = 44892;             % w
Par_FCS.Ts = Ts;                       % s
Par_FCS.FCS_Rate_Max = 1500;           % w
Par_FCS.FCS_Rate_Max_Down = 1000;      % w
Par_FCS.FCS_Rate_Min_Up = -3000;       % w
Par_FCS.FCS_Rate_Min = -3600;          % w
Par_FCS.G2J = 1.43 * 10^5;              % 1.43¡Á10^8J/kg

%% Other Parameters
Paux = 1000;











