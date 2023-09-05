function Current_K = Cal_Battery_Current(SOC_List,Par_Batt)
    %% Calculate Current
    Current_K.I_K = zeros(1,length(SOC_List));
    Current_K.C_K = zeros(1,length(SOC_List));
    for Index = 1 : length(SOC_List) - 1
        SOC_K = SOC_List(Index);
        SOC_K_1 = SOC_List(Index + 1);
        Deta_SOC_K = SOC_K_1 - SOC_K;
        Col_Eff = (Deta_SOC_K > 0) * Par_Batt.Col_Eff + (Deta_SOC_K <= 0) / Par_Batt.Col_Eff;
        Current_K.I_K(Index) = -3600 * Par_Batt.Q_Ah * Deta_SOC_K / Col_Eff;
        Current_K.C_K(Index) = abs(Current_K.I_K(Index)) / Par_Batt.Q_Ah;
    end
end