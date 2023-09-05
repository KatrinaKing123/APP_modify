%% Electric Vehicle Parameters 
% Authors    : Wei Zhou, Lin Yang, Yishan Cai, Tianxing Ying
% Date        : 2018-03-20 21:21:40
% Organization: Shanghai JiaoTong University

%% Simulation Step Time
Ts = 1;                                                                    % Unit: s

%% Vehicle Parameters
Par_Veh.Gravity = 9.81;                                                    % Gravitational acceleration, Unit: m/s^2
Par_Veh.Air_Density =1.2;                                                  % Air Density, Unit: kg/m^3
Par_Veh.M_F = 1800;                                                        % Weight, Unit: kg      
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
% Par_Brake.Beta = (Par_Veh.Coefficient * Par_Veh.hg + Par_Veh.b) / Par_Veh.L; % Braking force distribution
Par_Brake.Brake_Speed_Limit = 10;                                            % When Speed is lower than 10 km/h, mechanical braking 
Par_Brake.Elec_Brake_Dec_Limit = -2;                                         % When Dec is lower than -2 m/s^2, mechanical braking 

%% Wheel Parameters  
Par_Wheel.R = 0.316;                                           % Wheel Radius, Unit: m

%% Final Parameters
Par_Finala.Ratio = 4.875;     % Drive ratio of main decelerator
Par_Finalb.Ratio = 4.875;      
Par_Finala.Eff = 0.97;                                          % Efficiency
Par_Finalb.Eff = 0.97;    
%% Gearbox Parameters 
% Par_Gear.Index = [1 2 3 4 5];                                       % Drive ratio of main decelerator
% Par_Gear.Ratio = [6.9 4.13 2.45 1.49 1.00];                                          % Efficiency
% Par_Gear.Eff = 0.97;

%% Motor Parameters
Scale1 = 1;
Speed1 = [0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000]*(2*pi/60); % Unit: rad/s
% 电机转速换算为角速度
Torq_Max1 = [210 210 210 210 206 170 130 118 100 90 80 71 68 61 53 52 50] / Scale1;     % Unit: Nm
Torq_Min1 = -Torq_Max1;                                           % Unit: Nm
%最大力矩（正）和最小力矩（负）
W_Row1 = Speed1;  
T_Col_Drive1 = [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220] / Scale1;                             
Eff_map_Drive1 = 0.01001*[...
      70    75    78    77    73    72    70    68    66    65    60    59    58    55    52    50    49   48	47	46	45	44	43
      70    80    88    88.1  87    85.9  82    81    79    76    74    73    72    70    68    65    63   62	61	60	59	59.5	58	
      70    80    88.1  89    88.5  88.2  87.6  86.1  84.4  82.8  82    80.7  80    79    76    75    73   72.5   72    71    70.2  70    69
      70    80    88.1  90    90.1  90    89    88.2  87.9  86.8  86    85.3  84    82.7  82    81    80.2 80     79    78    76    75    74
      70    80    88    90    92    92    90    89.6  88.7  88.3  88    87.2  86.5  86    85    84    83   82     81    80.9  80.6  80.3  80.2
      70    80    88    89.5  90.2  92    91    90    89.5  89    88.7  88.2  87.7  87    86.5  86.1  85.9 84     83    82    82    81.9  81.8
      70    80    88    89.8  90.3  91    92    91    90.1  89.7  89    88.5  88.2  87.7  87.2  86.8  86.2 86     85.5  85.4  85    85    85     
      70    80    87.9  89.8  90.3  91    92    91    90.1  89.7  89.2  88.8  88.2  87.8  87.3  87    86.8 86.3   86    85.8  85    84    84
      70    80    86.5  89    90    91.2  92    90.2  89.7  89.6  89    88.7  88.5  88    87.7  87    87   86.8   86.2  86    85.8  85.6  85
      70    78    85    88    89    89.9  90.1  90    89.2  89    88.7  88.5  88    88    88    88    88   88	88	88	88	88	88	
      70    78    85    88    88.5  89    89.6  89.5  89.4  89    88.7  88.3  88.2  88    88    88    88   88	88	88	88	88	88		
      70    77    82    86.5  88.2  88.8  89    89    89    89    89    89    89    89    88    88    88   88	88	88	88	88	88  	
      70    76    82    86.1  88.1  88.5  88.8  89    89    89    89    89    89    89    89    88    88   88	88	88	88	88	88
      70    75	  81	86		88		88.4	88.6	88.6	89		89		89		89		88		88		88		88	88   88	88	88	88	88	88
      70	74		80.5	85.9	87.8	88.3	88.5	88.5	89		89		89		89		89		88		88		88	88   88	88	88	88	88	88
      70    73		80.2	85.8	87.6	88.2	88.4	89		89		89		89		89		89		89		88		88	88   88	88	88	88	88	88
   	  70	72.5	80		85.7	87		88.1	88.2	88.2	89		89		89		89		89		89		88		88	88   88	88	88	88	88	88]';
%Eff_map_Drive最后为23（行）×17（列）
T_Col1 = [-fliplr(T_Col_Drive1),T_Col_Drive1(2:end)];
%通过翻转，T_Col为[-220:10:220];
Row_Num1 = length(T_Col1);
%行数（纵轴）为力矩
Col_Num1 = length(W_Row1);
%列数（横轴）为转速（角速度）
Eff_map1 = zeros(Row_Num1,Col_Num1);%先赋0
for Row_Index1 = 1:length(T_Col_Drive1)
    Eff_map1(Row_Index1,:) = Eff_map_Drive1(length(T_Col_Drive1) - Row_Index1 + 1,:);
end
%Eff_map的1到23行，比如第一行，应该是最大扭矩，对应转置后的Eff_map_Drive的第23行
for Row_Index1 = (length(T_Col_Drive1) + 1) : Row_Num1
    Eff_map1(Row_Index1,:) = Eff_map_Drive1(Row_Index1 - length(T_Col_Drive1) + 1,:);
end
%Eff_map的24到45行，比如第24行，应该是最小扭矩，对应转置后的Eff_map_Drive的第2行（第1行是0）
Eff_map_Update1 = zeros(Row_Num1,Col_Num1);
Eff_map_Update1(Eff_map_Update1 == 0) = NaN;
%需要将扭矩超过最大值的点剔除
for Col_Index1 = 1 : Col_Num1
    for Row_Index1 = 1 : Row_Num1
        Current_T1 = T_Col1(Row_Index1);
        Current_W1 = Speed1(Col_Index1);
        T_Max1 = interp1(Speed1,Torq_Max1,Current_W1);
        T_Min1 = interp1(Speed1,Torq_Min1,Current_W1);
        %没有看出插值的意义是什么
        if (Current_T1 >= T_Min1) && (Current_T1 <= T_Max1)
            Eff_map_Update1(Row_Index1,Col_Index1) = Eff_map1(Row_Index1,Col_Index1);
        end
    end
end

Scale2 = 1;
Speed2 = [0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000]*(2*pi/60); % Unit: rad/s
Torq_Max2 = [210 210 210 210 206 170 130 118 100 90 80 71 68 61 53 52 50] / Scale2;     % Unit: Nm
Torq_Min2 = -Torq_Max2;                                           % Unit: Nm
W_Row2 = Speed2;  
T_Col_Drive2 = [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220] / Scale2;                             
Eff_map_Drive2 = 0.01001*[...
      70    75    78    77    73    72    70    68    66    65    60    59    58    55    52    50    49   48	47	46	45	44	43
      70    80    88    88.1  87    85.9  82    81    79    76    74    73    72    70    68    65    63   62	61	60	59	59.5	58	
      70    80    88.1  89    88.5  88.2  87.6  86.1  84.4  82.8  82    80.7  80    79    76    75    73   72.5   72    71    70.2  70    69
      70    80    88.1  90    90.1  90    89    88.2  87.9  86.8  86    85.3  84    82.7  82    81    80.2 80     79    78    76    75    74
      70    80    88    90    92    92    90    89.6  88.7  88.3  88    87.2  86.5  86    85    84    83   82     81    80.9  80.6  80.3  80.2
      70    80    88    89.5  90.2  92    91    90    89.5  89    88.7  88.2  87.7  87    86.5  86.1  85.9 84     83    82    82    81.9  81.8
      70    80    88    89.8  90.3  91    92    91    90.1  89.7  89    88.5  88.2  87.7  87.2  86.8  86.2 86     85.5  85.4  85    85    85     
      70    80    87.9  89.8  90.3  91    92    91    90.1  89.7  89.2  88.8  88.2  87.8  87.3  87    86.8 86.3   86    85.8  85    84    84
      70    80    86.5  89    90    91.2  92    90.2  89.7  89.6  89    88.7  88.5  88    87.7  87    87   86.8   86.2  86    85.8  85.6  85
      70    78    85    88    89    89.9  90.1  90    89.2  89    88.7  88.5  88    88    88    88    88   88	88	88	88	88	88	
      70    78    85    88    88.5  89    89.6  89.5  89.4  89    88.7  88.3  88.2  88    88    88    88   88	88	88	88	88	88		
      70    77    82    86.5  88.2  88.8  89    89    89    89    89    89    89    89    88    88    88   88	88	88	88	88	88  	
      70    76    82    86.1  88.1  88.5  88.8  89    89    89    89    89    89    89    89    88    88   88	88	88	88	88	88
      70    75	  81	86		88		88.4	88.6	88.6	89		89		89		89		88		88		88		88	88   88	88	88	88	88	88
      70	74		80.5	85.9	87.8	88.3	88.5	88.5	89		89		89		89		89		88		88		88	88   88	88	88	88	88	88
      70    73		80.2	85.8	87.6	88.2	88.4	89		89		89		89		89		89		89		88		88	88   88	88	88	88	88	88
   	  70	72.5	80		85.7	87		88.1	88.2	88.2	89		89		89		89		89		89		88		88	88   88	88	88	88	88	88]';
T_Col2 = [-fliplr(T_Col_Drive2),T_Col_Drive2(2:end)];
Row_Num2 = length(T_Col2);
Col_Num2 = length(W_Row2);
Eff_map2 = zeros(Row_Num2,Col_Num2);
for Row_Index2 = 1:length(T_Col_Drive2)
    Eff_map2(Row_Index2,:) = Eff_map_Drive2(length(T_Col_Drive2) - Row_Index2 + 1,:);
end
for Row_Index2 = (length(T_Col_Drive2) + 1) : Row_Num2
    Eff_map2(Row_Index2,:) = Eff_map_Drive2(Row_Index2 - length(T_Col_Drive2) + 1,:);
end
Eff_map_Update2 = zeros(Row_Num2,Col_Num2);
Eff_map_Update2(Eff_map_Update2 == 0) = NaN;
for Col_Index2 = 1 : Col_Num2
    for Row_Index2 = 1 : Row_Num2
        Current_T2 = T_Col2(Row_Index2);
        Current_W2 = Speed2(Col_Index2);
        T_Max2 = interp1(Speed2,Torq_Max2,Current_W2);
        T_Min2 = interp1(Speed2,Torq_Min2,Current_W2);
        if (Current_T2 >= T_Min2) && (Current_T2 <= T_Max2)
            Eff_map_Update2(Row_Index2,Col_Index2) = Eff_map2(Row_Index2,Col_Index2);
        end
    end
end

Par_Motor1.Speed = Speed1;
Par_Motor1.W_Row = Speed1;
Par_Motor1.T_Col = T_Col1;
Par_Motor1.Trq_Min = Torq_Min1;
Par_Motor1.Trq_Max = Torq_Max1;
Par_Motor1.Eff_map = Eff_map_Update1';%又转置回去？

Par_Motor2.Speed = Speed2;
Par_Motor2.W_Row = Speed2;
Par_Motor2.T_Col = T_Col2;
Par_Motor2.Trq_Min = Torq_Min2;
Par_Motor2.Trq_Max = Torq_Max2;
Par_Motor2.Eff_map = Eff_map_Update2';
%% Battery Parameters
Par_Batt.ESS_SOC = 0.1:.1:0.9;
Par_Batt.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
Par_Batt.ESS_R_D = fliplr([0.259286 0.247857 0.235714 0.227143 0.223571 0.221429 0.22 0.217143 0.212143]);
Par_Batt.ESS_R_C = fliplr([0.235333 0.228333 0.222667 0.217667 0.219333 0.224667 0.232 0.242 0.270333]);
Par_Batt.Q_Ah = 40;
Par_Batt.Col_Eff = 1;    
Par_Batt.Ts = Ts;
Par_Batt.SOC_Max = 0.90;
Par_Batt.SOC_Min = 0.20;
Par_Batt.P_Batt_Max = 75000;
Par_Batt.P_Batt_Min = -35000;
Par_Batt.I_Max = 200;
Par_Batt.I_Min = -200;

%% Other Parameters
Paux = 1000;

