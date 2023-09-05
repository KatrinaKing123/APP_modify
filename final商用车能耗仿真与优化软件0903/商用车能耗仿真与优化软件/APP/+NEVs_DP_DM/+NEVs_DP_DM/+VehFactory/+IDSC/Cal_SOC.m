function [SOC_K_1,In_Batt] = Cal_SOC(Par_Batt,Input_K)
%% Battery Parameters
ESS_SOC = Par_Batt.ESS_SOC;
ESS_VOC = Par_Batt.ESS_VOC;
ESS_R_D = Par_Batt.ESS_R_D;
ESS_R_C = Par_Batt.ESS_R_C;
Q_Ah = Par_Batt.Q_Ah;
Col_Eff = Par_Batt.Col_Eff;
Ts = Par_Batt.Ts;
SOC_Max = Par_Batt.SOC_Max;
SOC_Min = Par_Batt.SOC_Min;
P_Batt_Max = Par_Batt.P_Batt_Max;
P_Batt_Min = Par_Batt.P_Batt_Min;
I_Max = Par_Batt.I_Max;
I_Min = Par_Batt.I_Min;
SOC_K = Input_K.SOC_K;
P_Batt_K = Input_K.P_Batt_K;

%% Calculation
R_D = interp1(ESS_SOC, ESS_R_D, SOC_K, 'linear');
R_C = interp1(ESS_SOC, ESS_R_C, SOC_K, 'linear');
VOC = interp1(ESS_SOC, ESS_VOC, SOC_K, 'linear');
R = (P_Batt_K >= 0) .* R_D + (P_Batt_K < 0) .* R_C;
I_K = (VOC - sqrt(VOC .* VOC - 4 .* R .* P_Batt_K)) ./ (2 .* R);
Col_EFF = (I_K >= 0) .* Col_Eff + (I_K < 0) ./ Col_Eff;
SOC_K_1 = SOC_K - (I_K.* Ts ./ (3600 .* Q_Ah .* Col_EFF));

%% Invalue
In_NaN =  isnan(SOC_K_1);
SOC_K_1(isnan(SOC_K_1)) = 1;
In_Pb = (P_Batt_K > P_Batt_Max) | (P_Batt_K < P_Batt_Min);
In_SOC = (SOC_K_1 > SOC_Max) | (SOC_K_1 < SOC_Min);
In_I = (I_K > I_Max) | (I_K < I_Min);
In_Batt = (In_Pb | In_SOC | In_I | In_NaN);

end