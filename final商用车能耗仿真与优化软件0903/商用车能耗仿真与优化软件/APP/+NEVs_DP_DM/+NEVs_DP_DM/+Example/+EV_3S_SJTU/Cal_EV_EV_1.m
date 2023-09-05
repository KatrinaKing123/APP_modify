% function OutPut_K = Cal_EV_EV(EV,T_F_K,W_F_K,Input_K,Cost)
function OutPut_K = Cal_EV_EV_1(EV,T_W_K,W_W_K,Input_K)
   %% State variables of the kth step
    SOC_K = Input_K.SOC_K_1_Grid;
    J_K = Input_K.J_K_1_Grid; 
    G_K = Input_K.G_K_1_Grid;
    M_K = Input_K.M_K_1_Grid;
%     Fuel_K = Input_K.Fuel_K_1_Grid;

%     %% Grid 
%     Row_Num = length(EV.GearBox.Index);
%     Col_Num = length(SOC_K);
%     SOC_K_Grid = repmat(SOC_K,Row_Num,1);
%     J_K_Grid = repmat(J_K,Row_Num,1);
%     G_K_Grid = repmat(G_K,Row_Num,1);
%     M_K_Grid = repmat(M_K,Row_Num,1);
%     M_K_1_Grid = EV.Mode.EV .* ones(Row_Num,Col_Num);
%     T_F_K_Grid = repmat(T_F_K,Row_Num,Col_Num);
%     W_F_K_Grid = repmat(W_F_K,Row_Num,Col_Num);
%     U_K_Grid = repmat(EV.GearBox.Index',1,Col_Num);
%     if (Col_Num < 2)
%         U_K_Ratio_Grid = EV.GearBox.Ratio(U_K_Grid)';
%     else
%         U_K_Ratio_Grid = EV.GearBox.Ratio(U_K_Grid);
%     end
%     T_M_K_Grid = ((T_F_K_Grid >0 ) ./ EV.GearBox.Eff + (T_F_K_Grid <0 ) .* EV.GearBox.Eff) .* T_F_K_Grid ./ U_K_Ratio_Grid;
%     W_M_K_Grid = W_F_K_Grid .* U_K_Ratio_Grid;
%     
  %% Grid 
    Row_Num = length(EV.U_G);%行数是转矩分配系数
    Col_Num = length(SOC_K); %列数是SOC值
    SOC_K_Grid = repmat(SOC_K,Row_Num,1);
    J_K_Grid = repmat(J_K,Row_Num,1);
    G_K_Grid = repmat(G_K,Row_Num,1);
    M_K_Grid = repmat(M_K,Row_Num,1);
%     M_K_1_Grid = EV.Mode.EV .* ones(Row_Num,Col_Num);
    T_W_K_Grid = repmat(T_W_K,Row_Num,Col_Num);
    W_W_K_Grid = repmat(W_W_K,Row_Num,Col_Num);
    U_K_Grid = repmat(EV.U_G',1,Col_Num);
    one=ones(Row_Num,Col_Num);
   
       
  
    T_M_Front_K_Grid = ((T_W_K_Grid >=0 ) ./ EV.Finala.Eff + (T_W_K_Grid <0 ) .* EV.Finala.Eff) .* T_W_K_Grid ./EV.Finala.Ratio.* U_K_Grid;
    %=0好像不需要被剔除
    T_M_Rear_K_Grid = ((T_W_K_Grid >=0 ) ./ EV.Finalb.Eff + (T_W_K_Grid <0 ) .* EV.Finalb.Eff) .* T_W_K_Grid ./EV.Finalb.Ratio.* (one - U_K_Grid);
    W_M_Front_K_Grid = W_W_K_Grid .* EV.Finala.Ratio;
    W_M_Rear_K_Grid = W_W_K_Grid .* EV.Finalb.Ratio;
    %% The control variable filter
    Deta_G_K_Grid = U_K_Grid - G_K_Grid;
    Index_G = find((Deta_G_K_Grid <= 0.2)&(Deta_G_K_Grid >= -0.2));
    %限定每一步转矩分配系数变化的最大值
    S_SOC_K_Grid = SOC_K_Grid(Index_G);
    S_T_M_Front_K_Grid = T_M_Front_K_Grid(Index_G);
    S_T_M_Rear_K_Grid = T_M_Rear_K_Grid(Index_G);
    S_W_M_Front_K_Grid = W_M_Front_K_Grid(Index_G);
    S_W_M_Rear_K_Grid = W_M_Rear_K_Grid(Index_G);
    S_G_K_1_Grid = U_K_Grid(Index_G);
%     S_M_K_1_Grid = M_K_1_Grid(Index_G);
    S_M_K_Grid = M_K_Grid(Index_G);
    S_G_K_Grid = G_K_Grid(Index_G);
    S_J_K_Grid = J_K_Grid(Index_G);
       %% Motor calculation
    EV.Motor1.Tm = S_T_M_Front_K_Grid;
    EV.Motor2.Tm = S_T_M_Rear_K_Grid;
    EV.Motor1.Wm = S_W_M_Front_K_Grid;
    EV.Motor2.Wm = S_W_M_Rear_K_Grid;
    EV.Motor1.Cal_Motor()
    EV.Motor2.Cal_Motor()
%     S_T_M_Front_K_Grid_Real =  EV.Motor1.T_m;
%     S_T_M_Rear_K_Grid_Real =  EV.Motor2.T_m;
    %制动时电机制动力限制
    S_P_em_Front_K_Grid = EV.Motor1.P_EM;
    S_P_em_Rear_K_Grid = EV.Motor2.P_EM;
    S_P_em_K_Grid =  S_P_em_Front_K_Grid + S_P_em_Rear_K_Grid;
    
    S_Pb_K_Grid = S_P_em_K_Grid + EV.Paux;
%     In_Motor1 = EV.Motor1.In_Motor;
%     In_Motor2 = EV.Motor2.In_Motor;
 %% 电池充电最大功率对于电机扭矩的限制
if(min(S_Pb_K_Grid) >= 0)
    S_T_M_Front_K_Grid_Real = EV.Motor1.T_m;
    S_T_M_Rear_K_Grid_Real = EV.Motor2.T_m;
else
    S_Pb_K_Grid_Real = (S_Pb_K_Grid >= 0).*S_Pb_K_Grid + (S_Pb_K_Grid < 0).*max(S_Pb_K_Grid, EV.Batt.P_Batt_Min);
    S_P_em_K_Grid_Real = S_Pb_K_Grid_Real - EV.Paux;
    proportion = S_P_em_K_Grid_Real./S_P_em_K_Grid;%电池功率若超出，前后电机功率按同一比例削减;因为有附加单元，要算电机功率
    S_P_em_Front_K_Grid = S_P_em_Front_K_Grid.*proportion;%需要逆推出充电时受到限制后的电机实际扭矩
    S_P_em_Rear_K_Grid = S_P_em_Rear_K_Grid.*proportion;%前面算电机扭矩已经将扭矩限制到电机最小扭矩（负）了，现在扭矩不会更小（负）

    S_T_M_Front_K_Grid_Real = (S_P_em_Front_K_Grid./EV.Motor1.EM_Eff./S_W_M_Front_K_Grid);
    
    S_T_M_Rear_K_Grid_Real =  (S_P_em_Rear_K_Grid./EV.Motor2.EM_Eff./S_W_M_Rear_K_Grid);
    S_Pb_K_Grid = S_Pb_K_Grid_Real;
end
    %% The I/f/ECE filter
    G_car = EV.VehBody.Gravity.*EV.VehBody.M_F;
    y1=G_car./EV.VehBody.hg.*sqrt(EV.VehBody.b.*EV.VehBody.b + 4.*EV.VehBody.hg.*EV.VehBody.L.*abs(S_T_M_Front_K_Grid_Real)./G_car);
    y = 0.5.*(y1 - G_car.*EV.VehBody.b./EV.VehBody.hg - 2.* abs(S_T_M_Front_K_Grid_Real));
    
    e1 = EV.VehBody.hg.*(abs(S_T_M_Front_K_Grid_Real) + abs(S_T_M_Rear_K_Grid_Real)).^2./G_car./EV.VehBody.L;
    e2 = (abs(S_T_M_Front_K_Grid_Real) + abs(S_T_M_Rear_K_Grid_Real)).*((EV.VehBody.b + 0.07.*EV.VehBody.hg)./EV.VehBody.L);
    e3 = 0.07.*EV.VehBody.b.*G_car./EV.VehBody.L - 0.85.*abs(S_T_M_Front_K_Grid_Real);
    e =e1 +e2 +e3;
    
    z = (EV.VehBody.L - EV.VehBody.hg.*EV.VehBody.Coefficient)./(EV.VehBody.hg.*EV.VehBody.Coefficient).*abs(S_T_M_Front_K_Grid_Real) - G_car.*EV.VehBody.b./EV.VehBody.hg;
    
    Index_positive = ((S_T_M_Front_K_Grid_Real>=0)&(S_T_M_Rear_K_Grid_Real>=0));
    Index_negative = (((S_T_M_Front_K_Grid_Real<=0)&(S_T_M_Rear_K_Grid_Real<=0))&(abs(S_T_M_Rear_K_Grid_Real) <= y)&(e>=0)&(abs(S_T_M_Rear_K_Grid_Real) >= z));
    Index_E = find(Index_positive|Index_negative);
    
    E_SOC_K_Grid = S_SOC_K_Grid(Index_E);
    E_T_M_Front_K_Grid = S_T_M_Front_K_Grid_Real(Index_E);
    E_T_M_Rear_K_Grid = S_T_M_Rear_K_Grid_Real(Index_E);
    E_W_M_Front_K_Grid = S_W_M_Front_K_Grid(Index_E);
    E_W_M_Rear_K_Grid = S_W_M_Rear_K_Grid(Index_E);
    E_G_K_1_Grid = S_G_K_1_Grid(Index_E);
%     E_M_K_1_Grid = S_M_K_1_Grid(Index_E);
    E_M_K_Grid = S_M_K_Grid(Index_E);
    E_G_K_Grid = S_G_K_Grid(Index_E);
    E_J_K_Grid = S_J_K_Grid(Index_E);
 
    E_P_em_K_Grid = S_P_em_K_Grid(Index_E);
    E_Pb_K_Grid = S_Pb_K_Grid(Index_E);
    %% SOC calculation
    EV.Batt.SOC_K = E_SOC_K_Grid;
    EV.Batt.P_Batt_K = E_Pb_K_Grid;
    EV.Batt.Cal_SOC();
    E_SOC_K_1_Grid = EV.Batt.SOC_K_1;
    In_Batt = EV.Batt.In_Batt;
    E_Fuel_K_1_Grid = E_Pb_K_Grid / 1000;  % kW

    
    
    %% Cost Function
%   F_Cost =Cost.G   .* (abs(S_G_K_1_Grid   - S_G_K_Grid) > 0) + Cost.M   .* (abs(S_M_K_1_Grid   - S_M_K_Grid) > 0);
%   S_J_K_1_Grid = S_J_K_Grid + F_Cost + S_Fuel_K_1_Grid;
    E_J_K_1_Grid = E_J_K_Grid + E_Fuel_K_1_Grid;
    %% Invalid value 
    EV.Motor1.Tm = E_T_M_Front_K_Grid;
    EV.Motor2.Tm = E_T_M_Rear_K_Grid;
    EV.Motor1.Wm = E_W_M_Front_K_Grid;
    EV.Motor2.Wm = E_W_M_Rear_K_Grid;
    EV.Motor1.Cal_Motor()
    EV.Motor2.Cal_Motor()
    In_Motor1 = EV.Motor1.In_Motor;
    In_Motor2 = EV.Motor2.In_Motor;
    %放在这里才计算无效点，是因为要保证不同变量网格数量要一样
    In_Value = In_Motor1 | In_Motor2 | In_Batt;
    Indexs = find(In_Value == 0);
    
    %%  Data output
    [Row_Num, Col_Num] = size(SOC_K_Grid(Indexs));
    OutPut_K.T_m_Front_K_Grid = E_T_M_Front_K_Grid(Indexs);
    OutPut_K.T_m_Rear_K_Grid = E_T_M_Rear_K_Grid(Indexs);
    OutPut_K.W_m_Front_K_Grid = E_W_M_Front_K_Grid(Indexs);
    OutPut_K.W_m_Rear_K_Grid = E_W_M_Rear_K_Grid(Indexs);
    OutPut_K.SOC_K_Grid = E_SOC_K_Grid(Indexs);
    OutPut_K.SOC_K_1_Grid = E_SOC_K_1_Grid(Indexs);
    OutPut_K.G_K_Grid = E_G_K_Grid(Indexs);
    OutPut_K.G_K_1_Grid = E_G_K_1_Grid(Indexs);
    OutPut_K.P_em_K_Grid = E_P_em_K_Grid(Indexs);
    OutPut_K.Pb_K_Grid = E_Pb_K_Grid(Indexs);
    OutPut_K.J_K_1_Grid = E_J_K_1_Grid(Indexs);
    OutPut_K.M_K_Grid = E_M_K_Grid(Indexs);
    OutPut_K.M_K_1_Grid = EV.Mode.EV .* ones(Row_Num, Col_Num);
    OutPut_K.Fuel_K_1_Grid = E_Fuel_K_1_Grid(Indexs);
end