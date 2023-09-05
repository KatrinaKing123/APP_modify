function OutPut_Filter = SOC_Filter(OutPut_K,SOC_K_1)
    Grid_SOC = mean(diff(SOC_K_1));
    Deta_SOC = Grid_SOC /2;
    SOC_Grid_Down = SOC_K_1 - Deta_SOC;
    SOC_Grid_Up = SOC_K_1 + Deta_SOC;
    Num_SOC_Grid =  length(SOC_K_1);
    Counter = 1;
    for Index = 1:Num_SOC_Grid
        SOC_Down = SOC_Grid_Down(Index);
        SOC_Up = SOC_Grid_Up(Index);
        Sel_Index = find((OutPut_K.SOC_K_1_Grid < SOC_Up) & (OutPut_K.SOC_K_1_Grid >= SOC_Down));
        if ~isempty(Sel_Index)
            Sel_J = OutPut_K.J_K_1_Grid(Sel_Index);
            [Y,OPT_Index] = min(Sel_J);
            if length(Y) > 1
                disp('There is a waring....')
            end
            OPT_Index_Index = Sel_Index(OPT_Index);
%             OutPut_Filter.T_m_K_Grid(Counter) = OutPut_K.T_m_K_Grid(OPT_Index_Index);
%             OutPut_Filter.W_m_K_Grid(Counter) = OutPut_K.W_m_K_Grid(OPT_Index_Index);
            OutPut_Filter.T_m_Front_K_Grid(Counter) = OutPut_K.T_m_Front_K_Grid(OPT_Index_Index);
            OutPut_Filter.W_m_Front_K_Grid(Counter) = OutPut_K.W_m_Front_K_Grid(OPT_Index_Index);
            OutPut_Filter.T_m_Rear_K_Grid(Counter) = OutPut_K.T_m_Rear_K_Grid(OPT_Index_Index);
            OutPut_Filter.W_m_Rear_K_Grid(Counter) = OutPut_K.W_m_Rear_K_Grid(OPT_Index_Index);
            
            
            OutPut_Filter.SOC_K_Grid(Counter) = OutPut_K.SOC_K_Grid(OPT_Index_Index);
            OutPut_Filter.SOC_K_1_Grid(Counter) = OutPut_K.SOC_K_1_Grid(OPT_Index_Index);
            OutPut_Filter.G_K_Grid(Counter) = OutPut_K.G_K_Grid(OPT_Index_Index);
            OutPut_Filter.G_K_1_Grid(Counter) = OutPut_K.G_K_1_Grid(OPT_Index_Index);
            OutPut_Filter.P_em_K_Grid(Counter) = OutPut_K.P_em_K_Grid(OPT_Index_Index);
            OutPut_Filter.Pb_K_Grid(Counter) = OutPut_K.Pb_K_Grid(OPT_Index_Index);
            OutPut_Filter.J_K_1_Grid(Counter) = OutPut_K.J_K_1_Grid(OPT_Index_Index);
            OutPut_Filter.M_K_Grid(Counter) =   OutPut_K.M_K_Grid(OPT_Index_Index);
            OutPut_Filter.M_K_1_Grid(Counter) = OutPut_K.M_K_1_Grid(OPT_Index_Index);
            OutPut_Filter.Fuel_K_1_Grid(Counter) =   OutPut_K.Fuel_K_1_Grid(OPT_Index_Index);
            % Update
            Counter = Counter + 1;
        end
    end
    if Counter == 1
        OutPut_Filter = Example.EV_3S_SJTU.Init_Put_K_Struct();
    end
end






