function OutPut_K = Cal_EV_Stop(PHEV,Input_K,Cost) 
   %% State variables of the kth step
    SOC_K = Input_K.SOC_K_1_Grid;
    G_K = Input_K.G_K_1_Grid;
    M_K = Input_K.M_K_1_Grid;
    J_K = Input_K.J_K_1_Grid;
    % Fuel_K = Input_K.Fuel_K_1_Grid;
    
    %% Grid 
    Row_Num = 1;   
    Col_Num = length(SOC_K);
    SOC_K_Grid = repmat(SOC_K,Row_Num,1);
    G_K_Grid = repmat(G_K,Row_Num,1);
    M_K_Grid = repmat(M_K,Row_Num,1);
    J_K_Grid = repmat(J_K,Row_Num,1);
    % Fuel_K_Grid = repmat(Fuel_K,Row_Num,1);
    G_K_1_Grid = ones(1,Col_Num);
    M_K_1_Grid = PHEV.Mode.Stop .* ones(1,Col_Num);
    
    %% Invalid value of the control variable 
    Deta_G_K_Grid = G_K_1_Grid - G_K_Grid;
    In_G = ((Deta_G_K_Grid > 1) | (Deta_G_K_Grid < -1));
    
    %% SOC calculation
    PHEV.Batt.SOC_K = SOC_K_Grid;
    PHEV.Batt.P_Batt_K = PHEV.Paux;
    PHEV.Batt.Cal_SOC();
    SOC_K_1_Grid = PHEV.Batt.SOC_K_1;
    In_Batt = PHEV.Batt.In_Batt;
    Fuel_K_Grid = PHEV.Paux / 1000;                     % kW

    %% Cost Function
    F_Cost =  Cost.G .* (abs(G_K_1_Grid - G_K_Grid) >0) +  Cost.M .* (abs(M_K_1_Grid - M_K_Grid) > 0);
    J_K_1_Grid = J_K_Grid + F_Cost + Fuel_K_Grid;    
    In_Value = (In_G|In_Batt);
    Index_J_K = find(In_Value == 0);
    
    %%  Data output
    [Row_Num, Col_Num] = size(J_K_1_Grid(Index_J_K));
    OutPut_K.T_m_K_Grid = zeros(Row_Num, Col_Num);
    OutPut_K.W_m_K_Grid = zeros(Row_Num, Col_Num);
    OutPut_K.SOC_K_Grid = SOC_K(Index_J_K);
    OutPut_K.SOC_K_1_Grid = SOC_K_1_Grid(Index_J_K);
    OutPut_K.G_K_Grid = G_K_Grid(Index_J_K);
    OutPut_K.G_K_1_Grid = ones(Row_Num, Col_Num);
    OutPut_K.P_em_K_Grid = zeros(Row_Num, Col_Num);
    OutPut_K.Pb_K_Grid = zeros(Row_Num, Col_Num) + PHEV.Paux;
    OutPut_K.J_K_1_Grid = J_K_1_Grid(Index_J_K);
    OutPut_K.M_K_Grid =   M_K_Grid(Index_J_K);
    OutPut_K.M_K_1_Grid = PHEV.Mode.Stop .* ones(Row_Num, Col_Num);
    OutPut_K.Fuel_K_1_Grid = Fuel_K_Grid .* ones(Row_Num, Col_Num);
    
end



