function Cal_DCF(obj,FCS)
%%  Parameters
FCS2DCF_P1 = obj.FCS2DCF_P1;
FCS2DCF_P2 = obj.FCS2DCF_P2;
P_FCS = FCS.P_FCS;

%% Calculate
obj.P_DCF = (P_FCS >0) .* (FCS2DCF_P1 .* P_FCS + FCS2DCF_P2);

end

