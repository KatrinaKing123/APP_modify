%% 电机可选机型

% MILA项目_90kW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
Motor_PE_60 = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mc_map_spd = [0 1500 2200 3000 4500 6000 7500 9000];
Motor_PE_60.mc_map_spd = [0 1000	1500	2000	2500	3000	3500	4000	4500	5000	5500	6000	6500	7000	7500	8000	8500	9000	9500	10000	10500	11000	11500	12000	12500	13000	13500	14000	14500	15000
];
% w_EM_row = mc_map_spd *(2*pi/60);
% mc_map_trq=[-125 -105 -95 -85 -75 -65 -55 -45 -30 -15 -5 ...
% 	0 5 15 30 45 55 65 75 85 95 105 125];
% mc_map_trq=[-125 -105 -95 -85 -75 -65 -55 -45 -30 -15 -5 ...
%  	0 5 15 30 45 55 65 75 85 95 105 125]

Motor_PE_60.mc_map_trq = fliplr([240
230
220
210
200
190
180
170
160
150
140
130
120
110
100
90
80
70
60
50
40
30
20
10
-10
-20
-30
-40
-50
-60
-70
-80
-90
-100
-110
-120
-130
-140
-150
-160
-170
-180
-190
-200
-210
-220
-230
-240
]');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mc_eff_map =[...
% 0.32	0.37	0.4	0.46	0.49	0.51	0.50	0.49	0.48	0.45	0.40	0.1	0.40	0.45	0.48	0.49	0.50	0.51	0.49	0.46	0.40	0.37	0.32    % 0
% 0.707	0.71	0.74	0.74	0.75	0.754	0.76	0.755	0.75	0.72	0.62	0.1	0.62	0.72	0.75	0.755	0.76	0.754	0.75	0.74	0.74	0.71	0.707   % 1500
% 0.707	0.71	0.74	0.74	0.75	0.754	0.76	0.755	0.75	0.72	0.62	0.1	0.62	0.72	0.75	0.755	0.76	0.754	0.75	0.74	0.74	0.71	0.707   % 2200
% 0.707	0.82	0.83	0.834	0.844	0.842	0.842	0.843	0.83	0.785	0.70	0.1	0.70	0.785	0.83	0.843	0.842	0.842	0.844	0.834	0.83	0.822	0.707   % 3000
% 0.707	0.82	0.83	0.834	0.844	0.803	0.84	0.847	0.855	0.817	0.71	0.1	0.71	0.817	0.855	0.847	0.84	0.803	0.844	0.834	0.83	0.822	0.707   % 4500
% 0.707	0.82	0.83	0.834	0.844	0.803	0.84	0.741	0.84	0.84	0.74	0.1	0.74	0.84	0.84	0.741 0.84	0.803	0.844	0.834 0.83	0.822	0.707   % 6000
% 0.707	0.82	0.83	0.834	0.844	0.803	0.84	0.741	0.825	0.825	0.76	0.1	0.76	0.825	0.825	0.741	0.84	0.803	0.844	0.834	0.83	0.822	0.707   % 7500
% 0.707	0.82	0.83	0.834	0.844	0.803	0.84	0.741	0.825	0.825	0.76	0.1	0.76	0.825	0.825	0.741	0.84	0.803	0.844	0.834	0.83	0.822	0.707]; % 9000

Motor_PE_60.mc_eff_map = 0.01 * [...
54.19 	66.73 	72.75 	79.26 	81.35 	83.42 	85.13 	86.19 	87.35 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
59.44 	69.00 	74.33 	78.55 	82.47 	84.50 	86.09 	87.08 	88.26 	88.85 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
54.91 	67.22 	75.47 	79.54 	83.30 	85.24 	86.72 	87.69 	88.86 	87.97 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
56.73 	68.66 	76.55 	80.59 	84.06 	85.92 	87.36 	88.28 	89.37 	89.30 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
58.47 	70.00 	77.69 	81.54 	84.86 	86.61 	87.99 	88.83 	89.87 	90.16 	89.24 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
60.31 	71.40 	78.74 	82.48 	85.60 	87.29 	88.58 	89.39 	90.42 	90.82 	89.68 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
61.93 	72.61 	79.73 	83.30 	86.28 	87.90 	89.14 	89.89 	90.77 	91.29 	91.09 	89.65 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
63.70 	73.86 	80.63 	84.03 	86.89 	88.41 	89.59 	90.34 	91.18 	91.85 	91.73 	90.77 	89.33 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
65.13 	74.93 	81.47 	84.73 	87.44 	88.90 	90.02 	90.72 	91.56 	92.21 	92.26 	91.85 	90.45 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
66.53 	75.94 	82.26 	85.36 	87.95 	89.36 	90.42 	91.07 	91.87 	92.47 	92.71 	92.64 	91.81 	89.97 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
67.92 	76.97 	83.00 	86.03 	88.39 	89.76 	90.76 	91.38 	92.18 	92.69 	93.15 	93.17 	92.53 	91.39 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
69.12 	77.84 	83.63 	86.56 	88.83 	90.13 	91.05 	91.68 	92.46 	92.94 	93.48 	93.53 	93.27 	92.67 	90.48 	90.62 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
70.22 	78.65 	84.30 	87.08 	89.23 	90.44 	91.37 	91.95 	92.72 	93.18 	93.67 	93.80 	93.73 	93.40 	92.66 	91.07 	90.67 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
71.45 	79.49 	84.93 	87.52 	89.60 	90.77 	91.64 	92.20 	92.89 	93.35 	93.82 	94.21 	94.05 	94.08 	93.49 	93.08 	91.76 	90.70 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
72.77 	80.37 	85.47 	87.98 	90.01 	91.09 	91.91 	92.44 	93.10 	93.51 	94.02 	94.39 	94.42 	94.44 	94.28 	93.84 	93.22 	92.26 	91.07 	90.09 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
73.82 	81.14 	86.01 	88.45 	90.35 	91.41 	92.14 	92.71 	93.40 	93.75 	94.09 	94.46 	94.71 	94.75 	94.59 	94.42 	93.97 	93.51 	93.02 	92.09 	91.29 	nan	nan	nan	nan	nan	nan	nan	nan	nan
75.00 	81.96 	86.61 	88.92 	90.73 	91.67 	92.40 	92.87 	93.53 	93.95 	94.23 	94.69 	94.93 	95.05 	94.76 	94.73 	94.45 	94.19 	93.87 	93.33 	92.72 	91.52 	90.97 	91.19 	nan	nan	nan	nan	nan	nan
76.37 	82.86 	87.25 	89.34 	91.03 	91.98 	92.63 	93.14 	93.69 	93.97 	94.39 	94.82 	94.93 	95.25 	94.94 	94.99 	94.78 	94.44 	94.43 	94.25 	93.64 	93.31 	92.91 	92.45 	91.29 	90.63 	89.97 	nan	nan	nan
77.60 	83.70 	87.79 	89.81 	91.35 	92.15 	92.81 	93.29 	93.75 	94.09 	94.40 	94.87 	95.16 	95.24 	95.18 	95.17 	94.94 	95.11 	94.64 	94.36 	94.17 	93.98 	93.69 	93.22 	93.17 	92.56 	91.53 	90.45 	90.15 	89.88 
79.12 	84.65 	88.44 	90.19 	91.56 	92.43 	92.95 	93.47 	93.74 	94.10 	94.49 	94.77 	95.02 	95.23 	95.35 	95.11 	95.10 	94.99 	94.92 	94.84 	94.51 	94.30 	94.23 	93.86 	93.72 	93.34 	93.40 	92.88 	92.25 	91.22 
80.49 	85.57 	89.03 	90.65 	91.85 	92.65 	93.10 	93.37 	93.80 	94.01 	94.38 	94.72 	94.82 	95.25 	95.28 	95.08 	95.10 	94.91 	94.89 	94.88 	94.42 	94.29 	94.15 	93.72 	93.50 	93.30 	93.02 	93.02 	92.93 	92.50 
82.86 	87.01 	89.80 	91.16 	92.03 	92.72 	93.16 	93.65 	93.75 	94.05 	94.34 	94.57 	94.48 	94.79 	94.88 	94.50 	94.85 	94.92 	94.56 	94.27 	94.08 	93.90 	93.82 	93.57 	93.41 	92.82 	92.66 	92.53 	92.21 	92.76 
84.92 	88.37 	90.63 	91.81 	92.23 	92.85 	92.75 	93.43 	93.21 	93.61 	93.75 	93.99 	93.99 	94.17 	94.55 	93.49 	93.92 	93.95 	93.81 	93.12 	93.00 	92.93 	92.63 	91.49 	91.86 	92.02 	91.06 	91.08 	90.81 	90.00 
90.87 	91.57 	91.70 	92.28 	91.27 	91.99 	91.80 	91.65 	91.13 	91.70 	92.33 	92.39 	91.96 	91.81 	92.76 	90.14 	91.05 	90.44 	89.83 	89.10 	88.10 	89.28 	88.78 	85.73 	87.00 	86.62 	85.86 	83.66 	84.59 	83.52 
90.87 	91.57 	91.70 	92.28 	91.27 	91.99 	91.80 	91.65 	91.13 	91.70 	92.33 	92.39 	91.96 	91.81 	92.76 	90.14 	91.05 	90.44 	89.83 	89.10 	88.10 	89.28 	88.78 	85.73 	87.00 	86.62 	85.86 	83.66 	84.59 	83.52 
84.92 	88.37 	90.63 	91.81 	92.23 	92.85 	92.75 	93.43 	93.21 	93.61 	93.75 	93.99 	93.99 	94.17 	94.55 	93.49 	93.92 	93.95 	93.81 	93.12 	93.00 	92.93 	92.63 	91.49 	91.86 	92.02 	91.06 	91.08 	90.81 	90.00 
82.86 	87.01 	89.80 	91.16 	92.03 	92.72 	93.16 	93.65 	93.75 	94.05 	94.34 	94.57 	94.48 	94.79 	94.88 	94.50 	94.85 	94.92 	94.56 	94.27 	94.08 	93.90 	93.82 	93.57 	93.41 	92.82 	92.66 	92.53 	92.21 	92.76 
80.49 	85.57 	89.03 	90.65 	91.85 	92.65 	93.10 	93.37 	93.80 	94.01 	94.38 	94.72 	94.82 	95.25 	95.28 	95.08 	95.10 	94.91 	94.89 	94.88 	94.42 	94.29 	94.15 	93.72 	93.50 	93.30 	93.02 	93.02 	92.93 	92.50 
79.12 	84.65 	88.44 	90.19 	91.56 	92.43 	92.95 	93.47 	93.74 	94.10 	94.49 	94.77 	95.02 	95.23 	95.35 	95.11 	95.10 	94.99 	94.92 	94.84 	94.51 	94.30 	94.23 	93.86 	93.72 	93.34 	93.40 	92.88 	92.25 	91.22 
77.60 	83.70 	87.79 	89.81 	91.35 	92.15 	92.81 	93.29 	93.75 	94.09 	94.40 	94.87 	95.16 	95.24 	95.18 	95.17 	94.94 	95.11 	94.64 	94.36 	94.17 	93.98 	93.69 	93.22 	93.17 	92.56 	91.53 	90.45 	90.15 	89.88 
76.37 	82.86 	87.25 	89.34 	91.03 	91.98 	92.63 	93.14 	93.69 	93.97 	94.39 	94.82 	94.93 	95.25 	94.94 	94.99 	94.78 	94.44 	94.43 	94.25 	93.64 	93.31 	92.91 	92.45 	91.29 	90.63 	89.97 	nan	nan	nan
75.00 	81.96 	86.61 	88.92 	90.73 	91.67 	92.40 	92.87 	93.53 	93.95 	94.23 	94.69 	94.93 	95.05 	94.76 	94.73 	94.45 	94.19 	93.87 	93.33 	92.72 	91.52 	90.97 	91.19 	nan	nan	nan	nan	nan	nan
73.82 	81.14 	86.01 	88.45 	90.35 	91.41 	92.14 	92.71 	93.40 	93.75 	94.09 	94.46 	94.71 	94.75 	94.59 	94.42 	93.97 	93.51 	93.02 	92.09 	91.29 	nan	nan	nan	nan	nan	nan	nan	nan	nan
72.77 	80.37 	85.47 	87.98 	90.01 	91.09 	91.91 	92.44 	93.10 	93.51 	94.02 	94.39 	94.42 	94.44 	94.28 	93.84 	93.22 	92.26 	91.07 	90.09 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
71.45 	79.49 	84.93 	87.52 	89.60 	90.77 	91.64 	92.20 	92.89 	93.35 	93.82 	94.21 	94.05 	94.08 	93.49 	93.08 	91.76 	90.70 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
70.22 	78.65 	84.30 	87.08 	89.23 	90.44 	91.37 	91.95 	92.72 	93.18 	93.67 	93.80 	93.73 	93.40 	92.66 	91.07 	90.67 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
69.12 	77.84 	83.63 	86.56 	88.83 	90.13 	91.05 	91.68 	92.46 	92.94 	93.48 	93.53 	93.27 	92.67 	90.48 	90.62 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
67.92 	76.97 	83.00 	86.03 	88.39 	89.76 	90.76 	91.38 	92.18 	92.69 	93.15 	93.17 	92.53 	91.39 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
66.53 	75.94 	82.26 	85.36 	87.95 	89.36 	90.42 	91.07 	91.87 	92.47 	92.71 	92.64 	91.81 	89.97 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
65.13 	74.93 	81.47 	84.73 	87.44 	88.90 	90.02 	90.72 	91.56 	92.21 	92.26 	91.85 	90.45 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
63.70 	73.86 	80.63 	84.03 	86.89 	88.41 	89.59 	90.34 	91.18 	91.85 	91.73 	90.77 	89.33 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
61.93 	72.61 	79.73 	83.30 	86.28 	87.90 	89.14 	89.89 	90.77 	91.29 	91.09 	89.65 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
60.31 	71.40 	78.74 	82.48 	85.60 	87.29 	88.58 	89.39 	90.42 	90.82 	89.68 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
58.47 	70.00 	77.69 	81.54 	84.86 	86.61 	87.99 	88.83 	89.87 	90.16 	89.24 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
56.73 	68.66 	76.55 	80.59 	84.06 	85.92 	87.36 	88.28 	89.37 	89.30 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
54.91 	67.22 	75.47 	79.54 	83.30 	85.24 	86.72 	87.69 	88.86 	87.97 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
59.44 	69.00 	74.33 	78.55 	82.47 	84.50 	86.09 	87.08 	88.26 	88.85 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
54.19 	66.73 	72.75 	79.26 	81.35 	83.42 	85.13 	86.19 	87.35 	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan
]';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Motor_PE_60.mc_max_spd_dr = [0
1000 
1500 
2000 
2500 
3000 
3500 
4000 
4500 
5000 
5500 
6000 
6500 
7000 
7500 
8000 
8500 
9000 
9500 
10000 
10500 
11000 
11500 
12000 
12500 
13000 
13500 
14000 
14500 
15000 
]';
% mc_max_trq=[124 124  124  92   62    45   35   28]; % (N*m)
Motor_PE_60.mc_max_trq_dr = [240
240 
236 
235 
235 
234 
233 
232 
234 
226 
209 
186 
168 
152 
141 
127 
119 
110 
103 
97 
90 
86 
81 
77 
72 
68 
66 
63 
61 
58 
]'; %Nm

Motor_PE_60.mc_max_spd_br = [1000 
1500 
2000 
2500 
3000 
3500 
4000 
4500 
5000 
5500 
6000 
6500 
7000 
7500 
8000 
8500 
9000 
9500 
10000 
10500 
11000 
11500 
12000 
12500 
13000 
13500 
14000 
14500 
15000 
]'; %rpm
% mc_max_gen_trq=-1*[124 124  124  92   62    45   35   28]; % (N*m), estimate
Motor_PE_60.mc_max_gen_trq=-1*[240 
236 
235 
235 
234 
233 
232 
234 
226 
209 
186 
168 
152 
141 
127 
119 
110 
103 
97 
90 
86 
81 
77 
72 
68 
66 
63 
61 
58 
]'; %Nm
% mc_overtrq_factor=1; % (--), estimated

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mc_mass = 58;
Motor_PE_60.name = 'Motor_Pe_60';

% 峰值功率
Motor_PE_60.mc_max_P = 120; % kw

% 额定功率
Motor_PE_60.mc_PE = 60; % KW

% 峰值扭矩
Motor_PE_60.mc_max_trq_dr_value = 240; % Nm

Motor_name.('Motor_PE_60')='Motor_PE_60';

%% 用于DP计算的
Motor_PE_60.Speed = [0 1000	1500	2000	2500	3000	3500	4000	4500	5000	5500	6000	6500	7000	7500	8000	8500	9000	9500	10000	10500	11000	11500	12000	12500	13000	13500	14000	14500	15000
]*(2*pi/60);
Motor_PE_60.W_Row = Motor_PE_60.Speed;

Motor_PE_60.T_Col = fliplr([240 230 220 210 200 190 180 170 160 150 140 130 120 110 100 90 80 70 60 50 40 30 20 10 -10 -20 -30 -40 -50 -60 -70 -80 -90 -100 -110 -120 -130 -140 ...
        -150 -160 -170 -180 -190 -200 -210 -220 -230 -240]);
Motor_PE_60.Trq_Max = Motor_PE_60.mc_max_trq_dr; 
Motor_PE_60.Trq_Min = Motor_PE_60.Trq_Max * -1;

Motor_PE_60.Eff_map = Motor_PE_60.mc_eff_map';

if Choose_model == 1
    Motor{end+1} = Motor_PE_60;
else
    Motor{1,1} = Motor_PE_60;
end

