battery1_s=struct;
battery1_s.ESS_SOC = 0.1:.1:0.9;
battery1_s.ESS_VOC = fliplr([360.5256 360.234 358.6572 356.616 356.1084 355.8816 355.104 352.1556 349.4124]); 
battery1_s.ESS_R_C = [0.054, 0.054, 0.052, 0.057, 0.062, 0.06, 0.059, 0.069, 0.073];
battery1_s.ESS_R_D = battery1_s.ESS_R_C;
battery1_s.Q_Ah = 230;
battery1_s.Col_Eff = 1;    
battery1_s.SOC_Max = 1;
battery1_s.SOC_Min = 0.04;
battery1_s.P_Batt_Max = 150000;
battery1_s.P_Batt_Min = -154000;
battery1_s.I_Max = 250;
battery1_s.I_Min = -200;

