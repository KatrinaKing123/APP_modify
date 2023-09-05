function Cal_SOC(obj)
%% Battery Parameters
ESS_SOC = obj.ESS_SOC; %SOC值
ESS_VOC = obj.ESS_VOC; %开路电压
ESS_R_D = obj.ESS_R_D; %放电电阻
ESS_R_C = obj.ESS_R_C; %充电电阻
Q_Ah = obj.Q_Ah; %电池容量
Col_Eff = obj.Col_Eff; %电池充放电效率
Ts = obj.Ts; 
SOC_Max = obj.SOC_Max;
SOC_Min = obj.SOC_Min;
P_Batt_Max = obj.P_Batt_Max; %最大功率，指放电
P_Batt_Min = obj.P_Batt_Min; %最小功率，指充电
I_Max = obj.I_Max; %最大电流，放电，正
I_Min = obj.I_Min; %最小电流，充电，负
SOC_K = obj.SOC_K; 
P_Batt_K = obj.P_Batt_K;

%% Calculation
R_D = interp1(ESS_SOC, ESS_R_D, SOC_K, 'linear');
R_C = interp1(ESS_SOC, ESS_R_C, SOC_K, 'linear');
VOC = interp1(ESS_SOC, ESS_VOC, SOC_K, 'linear');
% 线性拟合数据
R = (P_Batt_K >= 0) .* R_D + (P_Batt_K < 0) .* R_C;
% 统一充放电电阻
I_K = (VOC - sqrt(VOC .* VOC - 4 .* R .* P_Batt_K)) ./ (2 .* R);
Col_EFF = (I_K >= 0) .* Col_Eff + (I_K < 0) ./ Col_Eff;
SOC_K_1 = SOC_K - (I_K.* Ts ./ (3600 .* Q_Ah .* Col_EFF));

%% Invalue
In_Nan = isnan(SOC_K_1);
In_Pb = (P_Batt_K > P_Batt_Max) | (P_Batt_K < P_Batt_Min);
In_SOC = (SOC_K_1 > SOC_Max) | (SOC_K_1 < SOC_Min);
In_I = (I_K > I_Max) | (I_K < I_Min);
In_Batt = (In_Pb | In_SOC | In_I | In_Nan);

%% Data Output
obj.SOC_K_1 = SOC_K_1;
obj.In_Batt = In_Batt;

end