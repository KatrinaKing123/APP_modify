%% Parallel Hybrid Electric Vehicle Parameters 
% Authors    : Wei Zhou, Lin Yang, Yishan Cai, Tianxing Ying
% Date        : 2018-03-20 21:21:40
% Organization: Shanghai JiaoTong University

%% Simulation Step Time
Ts = 1;                                                                    % Unit: s

%% Vehicle Parameters
Par_Veh.Gravity = 9.81;                                             % Gravitational acceleration, Unit: m/s^2
Par_Veh.Air_Density =1.2;                                          % Air Density, Unit: kg/m^3
Par_Veh.M_F = 1800;                                                 % Weight, Unit: kg      
Par_Veh.Cd = 0.31;                                                    % Air Resistance Coefficient
Par_Veh.A_F = 2.18;                                                   % Windward Area, Unit: m^2
Par_Veh.Mu = 0.0086;                                                % Rolling Resistance Coefficient
Par_Veh.Grade = 0;                                                    % Rotation Coefficient
Par_Veh.mt2m_f = 0.03;
Par_Veh.L = 2.700;                                                      % Front and back axis length, Unit: m
Par_Veh.a = 1.244;                                                      % Center line distance of the center of mass to the center of the front axis, Unit: m
Par_Veh.b = Par_Veh.L - Par_Veh.a ;                           % Center line distance of the center of mass to the center of the rear axle, Unit: m
Par_Veh.hg = 0.196;                                                    % Centroid Height, Unit: m
Par_Veh.Coefficient = 0.8;                                           % Road adhesion coefficient

%% Brake Parameters
Par_Brake.Beta = (Par_Veh.Coefficient * Par_Veh.hg + Par_Veh.b) / Par_Veh.L; % Braking force distribution
Par_Brake.Brake_Speed_Limit = 10;                                            % When Speed is lower than 10 km/h, mechanical braking 
Par_Brake.Elec_Brake_Dec_Limit = -2;                                         % When Dec is lower than -2 m/s^2, mechanical braking 

%% Wheel Parameters  
Par_Wheel.R = 0.316;                                           % Wheel Radius, Unit: m

%% Final Parameters
Par_Final.Ratio = 4.875;                                       % Drive ratio of main decelerator
Par_Final.Eff = 0.97;                                            % Efficiency

%% Gearbox Parameters
Par_Gear.Index = [1 2 3 4 5];                                % Drive ratio of main decelerator
Par_Gear.Ratio = [6.9 4.13 2.45 1.49 1.00];             % Efficiency
Par_Gear.Eff = 0.97;

%% Motor Parameters
Speed = [0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000]*(2*pi/60);             % Unit: rad/s
Torq_Max = [210 210 210 210 206 170 130 118 100 90 80 71 68 61 53 52 50];                                                            % Unit: Nm
Torq_Min = -Torq_Max;                                                                                                                                            % Unit: Nm
W_Row = Speed;  
T_Col_Drive = [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220];                             
Eff_map_Drive = 0.01001*[...
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
T_Col = [-fliplr(T_Col_Drive),T_Col_Drive(2:end)];
Row_Num = length(T_Col);
Col_Num = length(W_Row);
Eff_map = zeros(Row_Num,Col_Num);
for Row_Index = 1:length(T_Col_Drive)
    Eff_map(Row_Index,:) = Eff_map_Drive(length(T_Col_Drive) - Row_Index + 1,:);
end
for Row_Index = (length(T_Col_Drive) + 1) : Row_Num
    Eff_map(Row_Index,:) = Eff_map_Drive(Row_Index - length(T_Col_Drive) + 1,:);
end
Eff_map_Update = zeros(Row_Num,Col_Num);
Eff_map_Update(Eff_map_Update == 0) = NaN;
for Col_Index = 1 : Col_Num
    for Row_Index = 1 : Row_Num
        Current_T = T_Col(Row_Index);
        Current_W = Speed(Col_Index);
        T_Max = interp1(Speed,Torq_Max,Current_W);
        T_Min = interp1(Speed,Torq_Min,Current_W);
        if (Current_T >= T_Min) && (Current_T <= T_Max)
            Eff_map_Update(Row_Index,Col_Index) = Eff_map(Row_Index,Col_Index);
        end
    end
end
Par_Motor.Speed = Speed;
Par_Motor.W_Row = Speed;
Par_Motor.T_Col = T_Col;
Par_Motor.Trq_Min = Torq_Min;
Par_Motor.Trq_Max = Torq_Max;
Par_Motor.Eff_map = Eff_map_Update';

%% Battery Parameters
Par_Batt.ESS_SOC = 0.1:.1:0.9;
Par_Batt.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
Par_Batt.ESS_R_D = fliplr([0.259286 0.247857 0.235714 0.227143 0.223571 0.221429 0.22 0.217143 0.212143]);
Par_Batt.ESS_R_C = fliplr([0.235333 0.228333 0.222667 0.217667 0.219333 0.224667 0.232 0.242 0.270333]);
Par_Batt.Q_Ah = 16;
Par_Batt.Col_Eff = 1;    
Par_Batt.Ts = Ts;
Par_Batt.SOC_Max = 0.65;
Par_Batt.SOC_Min = 0.55;
Par_Batt.P_Batt_Max = 75000;
Par_Batt.P_Batt_Min = -35000;
Par_Batt.I_Max = 200;
Par_Batt.I_Min = -200;

%% ICE Parameters
Par_ICE.Speed =[500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000]*2*pi/60;   
Par_ICE.T_Col =[7.42857142857143,14.8571428571429,22.2857142857143,29.7142857142857,37.1428571428571,44.5714285714286,52,59.4285714285714,66.8571428571429,74.2857142857143,81.7142857142857];  
Par_ICE.W_Row = Par_ICE.Speed;
Par_ICE.Trq_Max = [53.4857142857143,63.8857142857143,69.8285714285714,75.4000000000000,78.7428571428572,77.2571428571429,75.7714285714286,76.1428571428571,78.7428571428572,78.3714285714286,76.5142857142857,72.0571428571429];
Par_ICE.Fuel_map = [...    % g/s
    0.0638429403626065,0.0923844901717715,0.116043932776737,0.138201188549642,0.159607350906516,0.196035381584003,0.220821464313015,0.270393629771039,0.270393629771039,0.300437366412265,0.330481103053492;...
    0.127685880725213,0.168244925190869,0.210681703196601,0.256873948282487,0.296681899332112,0.358271559446626,0.412725832108850,0.474691038931379,0.540787259542078,0.600874732824529,0.660962206106984;...
    0.191528821087819,0.254620668034395,0.324472355725246,0.383057642175638,0.439389648377938,0.493468374332147,0.557574197390363,0.617398787977205,0.709783278148975,0.901312099236795,0.991443309160474;...
    0.247860827290119,0.330481103053492,0.419110126145110,0.501730401908483,0.574586463263458,0.648944711450492,0.715040932061191,0.817189636641361,0.932858022710083,1.09659638740477,1.32192441221397;...
    0.291048698711882,0.398079510496252,0.501354855200469,0.593363798664225,0.694761409828363,0.771748484971508,0.893801165076487,1.02148704580170,1.14917292652692,1.33319081345443,1.65240551526746;...
    0.326725635973338,0.457415890362674,0.584726224379871,0.698516876908515,0.822447290553577,0.959897385687186,1.08833435982843,1.22578445496204,1.37900751183230,1.62236177862623,1.98288661832095;...
    0.341747504293952,0.496848294704285,0.630918469465756,0.820194010305485,1.01209837810132,1.17193105703264,1.32492878587809,1.45111247977124,1.63250153974265,1.91904367795835,2.31336772137444;...
    0.435634181297785,0.594865985496285,0.794957271526855,1.01547829847346,1.17921666316814,1.37900751183230,1.53523494236668,1.69446674656518,1.97387349732858,2.22323651145076,2.64384882442794;...
    0.506988055820699,0.736822641126083,0.989640684962000,1.18973197099257,1.37731755164623,1.57166297304416,1.78628791667492,2.02795222328279,2.30578167787253,2.58563908468556,2.97432992748143;...
    0.713538745229131,0.961399572519251,1.18297213024829,1.38952281965673,1.59607350906516,1.78009139599267,2.06888681445646,2.32838958969506,2.65661741250046,2.96681899332112,3.30481103053492;...
    0.867512895515416,1.17320791583989,1.44998583964720,1.67719159799647,1.87961127361674,2.03245878377898,2.40011901092599,2.70994504503863,3.01150905157494,3.32546609947576,3.63529213358841;...
    0.946377704198635,1.32492878587809,1.62236177862623,1.87472916641253,2.09555063072555,2.35242457900804,2.61831164828289,2.95630368549669,3.28528260171812,3.60524839694718,3.96577323664190];
[T,W] = meshgrid(Par_ICE.T_Col,Par_ICE.Speed);
Par_ICE.Fuel_Den = 0.749*1000;    % (g/l), density of the fuel 
Par_ICE.Fuel_lhv = 42.6*1000;     % (J/g), lower heating value of the fuel
Par_ICE.Eff_Map = T.*W ./ (Par_ICE.Fuel_lhv .* Par_ICE.Fuel_map);
Par_ICE.Trq_Min = min(Par_ICE.T_Col);
Par_ICE.Speed_Min = min(Par_ICE.Speed);
Par_ICE.Speed_Max = max(Par_ICE.Speed);

%% Other Parameters
Paux = 1000;



