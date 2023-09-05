function OutPut_K = Cal_EV_EV(EV,T_F_K,W_F_K,Input_K,Cost)
   %% State variables of the kth step
    SOC_K = Input_K.SOC_K_1_Grid;
    J_K = Input_K.J_K_1_Grid; 
    G_K = Input_K.G_K_1_Grid;
    M_K = Input_K.M_K_1_Grid;
    Fuel_K = Input_K.Fuel_K_1_Grid;

    %% Grid 
    Row_Num = length(EV.GearBox.Index);
    Col_Num = length(SOC_K);
    SOC_K_Grid = repmat(SOC_K,Row_Num,1);
    J_K_Grid = repmat(J_K,Row_Num,1);
    G_K_Grid = repmat(G_K,Row_Num,1);
    M_K_Grid = repmat(M_K,Row_Num,1);
    M_K_1_Grid = EV.Mode.EV .* ones(Row_Num,Col_Num);
    T_F_K_Grid = repmat(T_F_K,Row_Num,Col_Num);
    W_F_K_Grid = repmat(W_F_K,Row_Num,Col_Num);
    U_K_Grid = repmat(EV.GearBox.Index',1,Col_Num);
    if (Col_Num < 2)
        U_K_Ratio_Grid = EV.GearBox.Ratio(U_K_Grid)';
    else
        U_K_Ratio_Grid = EV.GearBox.Ratio(U_K_Grid);
    end
    T_M_K_Grid = ((T_F_K_Grid >0 ) ./ EV.GearBox.Eff + (T_F_K_Grid <0 ) .* EV.GearBox.Eff) .* T_F_K_Grid ./ U_K_Ratio_Grid;
    W_M_K_Grid = W_F_K_Grid .* U_K_Ratio_Grid;
    
    %% The control variable filter
    Deta_G_K_Grid = U_K_Grid - G_K_Grid;
    Index_G = find((Deta_G_K_Grid <= 1)&(Deta_G_K_Grid >= -1));
    S_SOC_K_Grid = SOC_K_Grid(Index_G);
    S_T_M_K_Grid = T_M_K_Grid(Index_G);
    S_W_M_K_Grid = W_M_K_Grid(Index_G);
    S_G_K_1_Grid = U_K_Grid(Index_G);
    S_M_K_1_Grid = M_K_1_Grid(Index_G);
    S_M_K_Grid = M_K_Grid(Index_G);
    S_G_K_Grid = G_K_Grid(Index_G);
    S_J_K_Grid = J_K_Grid(Index_G);
    
    %% Motor calculation
    EV.Motor.Tm = S_T_M_K_Grid;
    EV.Motor.Wm = S_W_M_K_Grid;
    EV.Motor.Cal_Motor()
    S_P_em_K_Grid = EV.Motor.P_EM;
    S_Pb_K_Grid = S_P_em_K_Grid + EV.Paux;
    In_Motor = EV.Motor.In_Motor;
    
    %% SOC calculation
    EV.Batt.SOC_K = S_SOC_K_Grid;
    EV.Batt.P_Batt_K = S_Pb_K_Grid;
    EV.Batt.Cal_SOC();
    S_SOC_K_1_Grid = EV.Batt.SOC_K_1;
    In_Batt = EV.Batt.In_Batt;
    S_Fuel_K_1_Grid = S_Pb_K_Grid / 1000;              % kW

    %% Cost Function
    F_Cost =Cost.G   .* (abs(S_G_K_1_Grid   - S_G_K_Grid) > 0) + Cost.M   .* (abs(S_M_K_1_Grid   - S_M_K_Grid) > 0);
    S_J_K_1_Grid = S_J_K_Grid + F_Cost + S_Fuel_K_1_Grid;

    %% Invalid value 
    In_Value = In_Motor | In_Batt;
    Indexs = find(In_Value == 0);
    
    %%  Data output
    [Row_Num, Col_Num] = size(S_SOC_K_Grid(Indexs));
    OutPut_K.T_m_K_Grid = S_T_M_K_Grid(Indexs);
    OutPut_K.W_m_K_Grid = S_W_M_K_Grid(Indexs);
    OutPut_K.SOC_K_Grid = S_SOC_K_Grid(Indexs);
    OutPut_K.SOC_K_1_Grid = S_SOC_K_1_Grid(Indexs);
    OutPut_K.G_K_Grid = S_G_K_Grid(Indexs);
    OutPut_K.G_K_1_Grid = S_G_K_1_Grid(Indexs);
    OutPut_K.P_em_K_Grid = S_P_em_K_Grid(Indexs);
    OutPut_K.Pb_K_Grid = S_Pb_K_Grid(Indexs);
    OutPut_K.J_K_1_Grid = S_J_K_1_Grid(Indexs);
    OutPut_K.M_K_Grid = S_M_K_Grid(Indexs);
    OutPut_K.M_K_1_Grid = EV.Mode.EV .* ones(Row_Num, Col_Num);
    OutPut_K.Fuel_K_1_Grid = S_Fuel_K_1_Grid(Indexs);
end