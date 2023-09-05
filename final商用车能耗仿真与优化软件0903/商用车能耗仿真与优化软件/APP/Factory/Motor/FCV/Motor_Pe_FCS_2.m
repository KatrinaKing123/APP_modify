%% 燃料电池用电机
Motor_PE_FCS_2 = struct;
%% Motor Parameters
n100=[0 500	1000	1500	2000	2500	3000	3500	4000	4500	5000	5500	6000	6500	7000	7500	8000	8500	9000	9500	10000	10500	11000	11500	12000];
T100=0.8* [310 310	310	310	310	310	310	310	310	276	243	214	186	162	139	121	107	98	90	85	76	73	69	66	64];
% i0=12.336;
% r0=0.346;
V100=n100*0.377*r0/i0;
Motor_PE_FCS_2.mc_map_spd = [0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11500];       % Unit: rpm

Motor_PE_FCS_2.mc_map_trq = [-215 -200 -180 -160 -140 -120 -100 -80 -60 -40 -20 ...
                    0 20 40 60 80 100 120 140 160 180 200 215];                               % Unit: Nm

% Motor_PE_FCS_2.mc_max_spd_dr = Motor_PE_FCS_2.mc_map_spd;
% Motor_PE_FCS_2.mc_max_trq_dr = [200 200 200 175.2 131.4 105.1 87.6 75.1 65.7 58.4 52.4 50.5]*1.075;

Motor_PE_FCS_2.mc_max_spd_dr =n100;
Motor_PE_FCS_2.mc_max_trq_dr =T100;
Motor_PE_FCS_2.mc_P_dr=0.8*[0
16 
32 
49 
65 
81 
97 
114 
130 
130 
127 
123 
117 
110 
102 
95 
90 
87 
85 
85 
80 
80 
80 
80 
80]';

Motor_PE_FCS_2.mc_max_spd_br = Motor_PE_FCS_2.mc_max_spd_dr;
Motor_PE_FCS_2.mc_max_gen_trq = -1 * Motor_PE_FCS_2.mc_max_trq_dr;                                % Unit: Nm

                           
Motor_PE_FCS_2.mc_eff_map = [...
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


Motor_PE_FCS_2.name = 'Motor_PE_FCS_2';

% 峰值功率
% Motor_PE_FCS_2.mc_max_P = 0.8*130; % kw                                        %%
Motor_PE_FCS_2.mc_max_P = interp1(Motor_PE_FCS_2.mc_max_spd_dr, Motor_PE_FCS_2.mc_P_dr, Vi*i0/r0/0.377) ;

% 额定功率
Motor_PE_FCS_2.mc_PE = 65; % KW                                             %%% 

% 峰值扭矩
Motor_PE_FCS_2.mc_max_trq_dr_value = 310; % Nm

Motor{end+1} = Motor_PE_FCS_2;

Motor_name.('Motor_PE_FCS_2')='Motor_PE_FCS_2';