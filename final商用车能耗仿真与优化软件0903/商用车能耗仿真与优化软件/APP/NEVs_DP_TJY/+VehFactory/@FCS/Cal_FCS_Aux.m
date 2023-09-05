function Cal_FCS_Aux(obj,P_FCS_K_1)
%% FCS Parameters
FCS_AUX_P1 = obj.FCS_AUX_P1;
FCS_AUX_P2 = obj.FCS_AUX_P2;
FCS_AUX_P3 = obj.FCS_AUX_P3;

%% Calculation
obj.P_FCS_Aux = (P_FCS_K_1 >0) .* (FCS_AUX_P1 .* P_FCS_K_1  .* P_FCS_K_1 + FCS_AUX_P2 .* P_FCS_K_1 + FCS_AUX_P3);

end

