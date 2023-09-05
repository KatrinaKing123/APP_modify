function OutPut_Filter = SOC_Filter(OutPut_K,Grid,Step)
    Step         = Step + 1;
    SOC_Grid_Num = ceil(( Grid.SOC_Max_List(Step) - Grid.SOC_Min_List(Step)) / Grid.Deta_SOC) + 1;
    SOC_K_Grid   = linspace(Grid.SOC_Min_List(Step), Grid.SOC_Max_List(Step),SOC_Grid_Num);
    Counter      = 1;
    for Index = 1 : SOC_Grid_Num
        SOC_Down      = SOC_K_Grid(Index) - Grid.Deta_SOC / 2;
        SOC_Up        = SOC_K_Grid(Index) + Grid.Deta_SOC / 2;
        SOC_Index     = find((OutPut_K.SOC_K_1_Grid <= SOC_Up) & (OutPut_K.SOC_K_1_Grid >= SOC_Down));
        if ~isempty(SOC_Index)
            J_SOC         = OutPut_K.J_K_1_Grid(SOC_Index);
            [Y,OPT_Index] = min(J_SOC);
            if length(Y) > 1
                disp('There is a waring, in OutPut_Filter ength(Y) > 1....')
            end
            OPT_Index_Index                     = SOC_Index(OPT_Index);
            OutPut_Filter.SOC_K_Grid(Counter)   = OutPut_K.SOC_K_Grid(OPT_Index_Index);
            OutPut_Filter.PF_K_Grid(Counter)    = OutPut_K.PF_K_Grid(OPT_Index_Index);
            OutPut_Filter.J_K_Grid(Counter)     = OutPut_K.J_K_Grid(OPT_Index_Index);
            OutPut_Filter.SOC_K_1_Grid(Counter) = OutPut_K.SOC_K_1_Grid(OPT_Index_Index);
            OutPut_Filter.PF_K_1_Grid(Counter)  = OutPut_K.PF_K_1_Grid(OPT_Index_Index);
            OutPut_Filter.J_K_1_Grid(Counter)   = OutPut_K.J_K_1_Grid(OPT_Index_Index);
            Counter = Counter + 1;
        end
    end
	if Counter == 1
        disp('There is an warning in soc_filter!');
    end
end






