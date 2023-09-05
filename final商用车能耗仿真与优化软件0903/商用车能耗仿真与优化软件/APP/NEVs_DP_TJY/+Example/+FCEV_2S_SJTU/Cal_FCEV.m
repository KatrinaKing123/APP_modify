function OutPut_K = Cal_FCEV_V2(P_Demand,Input_K,Grid,FCEV,Step) 
	%% The Kth Step
	SOC_K = Input_K.SOC_K_1_Grid;
	PF_K = Input_K.PF_K_1_Grid;
	J_K = Input_K.J_K_1_Grid;
    U_K = Grid.PF;
    U_K_Num = Grid.PF_Num;
    
% 	%% the (K+1)th Step
%     SOC_K_Min = min(SOC_K);
%     SOC_K_Max = max(SOC_K);
%     SOC_K_1_Min_1 = SOC_K_Min + Grid.Deta_SOC_Min;
%     SOC_K_1_Max_1 = SOC_K_Max + Grid.Deta_SOC_Max;
%     SOC_K_1_Min_2 = Grid.SOC_Min_List(Step + 1);
%     SOC_K_1_Max_2 = Grid.SOC_Max_List(Step + 1);
%     SOC_K_1_Max = min(SOC_K_1_Max_1,SOC_K_1_Max_2);
%     SOC_K_1_Min = max(SOC_K_1_Min_1,SOC_K_1_Min_2);
  
	%% Grid
	Row_Num = length(SOC_K);
    Col_Num = U_K_Num;
	SOC_K_Grid = repmat(SOC_K', 1, Col_Num);
	PF_K_Grid = repmat(PF_K', 1, Col_Num);
	J_K_Grid = repmat(J_K', 1, Col_Num);
	U_K_Grid = repmat(U_K, Row_Num, 1);
    
    %% Filter
    Deta_U_K = U_K_Grid - PF_K_Grid;
    Indexs = find((Deta_U_K <= FCEV.FCS.FCS_Rate_Max) & (Deta_U_K >= FCEV.FCS.FCS_Rate_Min));
    S_SOC_K_Grid = SOC_K_Grid(Indexs);
    S_U_K_Grid = U_K_Grid(Indexs);
    S_PF_K_Grid = PF_K_Grid(Indexs);
    S_J_K_Grid = J_K_Grid(Indexs);
    
    
    %% DCF
    S_U_DCF_K = S_U_K_Grid .* FCEV.DCF.FCS2DCF_P1 +  FCEV.DCF.FCS2DCF_P2;
    S_P_AUX_FCS = FCEV.FCS.FCS_AUX_P1 .* S_U_K_Grid .* S_U_K_Grid + FCEV.FCS.FCS_AUX_P2 .* S_U_K_Grid + FCEV.FCS.FCS_AUX_P3;

    %% Battery
    S_P_Bus_K = P_Demand + S_P_AUX_FCS;
    FCEV.Batt.SOC_K = S_SOC_K_Grid;
    FCEV.Batt.P_Batt_K = S_P_Bus_K - S_U_DCF_K;
    FCEV.Batt.Cal_SOC();
    S_SOC_K_1_Grid = FCEV.Batt.SOC_K_1;
    S_In_Batt = FCEV.Batt.In_Batt;
   
    %% Filter
    S_Indexs = S_In_Batt == 0;
    S_S_SOC_K_Grid =S_SOC_K_Grid(S_Indexs);
    S_S_SOC_K_1_Grid =S_SOC_K_1_Grid(S_Indexs);
    S_S_U_K_Grid = S_U_K_Grid(S_Indexs);
    S_S_PF_K_Grid = S_PF_K_Grid(S_Indexs);
    S_S_J_K_Grid = S_J_K_Grid(S_Indexs);
    Fuel_Grid = FCEV.FCS.FCS_H2_P1 .* S_S_U_K_Grid .* S_S_U_K_Grid +  FCEV.FCS.FCS_H2_P2 .* S_S_U_K_Grid +  FCEV.FCS.FCS_H2_P3;
    S_S_J_K_1_Grid = S_S_J_K_Grid + Fuel_Grid;

    %% Data Output
    OutPut_K.SOC_K_1_Grid = S_S_SOC_K_1_Grid';
    OutPut_K.PF_K_1_Grid = S_S_U_K_Grid';
    OutPut_K.J_K_1_Grid = S_S_J_K_1_Grid';
    OutPut_K.SOC_K_Grid = S_S_SOC_K_Grid';
    OutPut_K.PF_K_Grid = S_S_PF_K_Grid';
    OutPut_K.J_K_Grid = S_S_J_K_Grid';
end
