function Cal_P_FCS_By_P_Batt_P_Demand_Idle(obj, DCF, P_Batt, P_Demand)
%% FCS Parameters
FCS_H2_P1 = obj.FCS_H2_P1;
FCS_H2_P2 = obj.FCS_H2_P2;
FCS_H2_P3 = obj.FCS_H2_P3;
FCS_AUX_P1 = obj.FCS_AUX_P1;
FCS_AUX_P2 = obj.FCS_AUX_P2;
FCS_AUX_P3  = obj.FCS_AUX_P3;
% FCS_P_Min = obj.FCS_P_Min;
FCS_P_Idle = obj.FCS_P_Idle;
FCS_P_Max = obj.FCS_P_Max;
% Ts = obj.Ts;
FCS_Rate_Max = obj.FCS_Rate_Max;
FCS_Rate_Min = obj.FCS_Rate_Min;
FCS2DCF_P1 = DCF.FCS2DCF_P1;
FCS2DCF_P2 = DCF.FCS2DCF_P2;
PF_K = obj.PF_K;

%% Calculate H2 Consumption and PF_K_1
a = FCS_AUX_P1;
b = FCS_AUX_P2 - FCS2DCF_P1;
c = FCS_AUX_P3 - FCS2DCF_P2 + P_Demand - P_Batt;
b24ac = b .* b - 4 .* a .* c;
U_K = (-b - sqrt(b24ac)) ./ (2 .* a);
PF_K_1 = U_K;
Deta_PF_K = PF_K_1 - PF_K;
obj.H2 = FCS_H2_P1 .* PF_K_1  .* PF_K_1 + FCS_H2_P2 .* PF_K_1 + FCS_H2_P3;
obj.PF_K_1 = PF_K_1;

%% Invalue Value
In_abc = (b24ac < 0);
In_FCS_P_Limit = ((PF_K_1 > FCS_P_Max) | (PF_K_1 < FCS_P_Idle));
In_FCS_Deta_P_Limit = ((Deta_PF_K > FCS_Rate_Max) | (Deta_PF_K < FCS_Rate_Min));
obj.In_FCS = (In_abc | In_FCS_P_Limit | In_FCS_Deta_P_Limit);

end
