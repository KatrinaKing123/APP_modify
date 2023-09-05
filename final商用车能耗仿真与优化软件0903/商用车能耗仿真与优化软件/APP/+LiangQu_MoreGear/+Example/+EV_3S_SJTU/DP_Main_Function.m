function Out_Put_K = DP_Main_Function(PHEV,SOC_K_1,Input_K,Cost,Step)
   %% Initialization
    Out_Put_K.CS_1_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Init_Put_K_Struct();
    Out_Put_K.CS_2_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Init_Put_K_Struct();
    
    %% Vehicle velocity and accleration
    Velocity = PHEV.Result.Velocity(Step);
    Acceleration = PHEV.Result.Acceleration(Step);
	T_F_K = PHEV.Result.Tf(Step);
	W_F_K = PHEV.Result.Wf(Step);
    
   %% Calcution
    if (Acceleration == 0) && (Velocity == 0)
       %% Work Mode 1 : SM
        OutPut_CS_1_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Cal_EV_Stop(PHEV,Input_K,Cost);
        OutPut_CS_1_K_Filter = LiangQu_MoreGear.Example.EV_3S_SJTU.SOC_Filter(OutPut_CS_1_K,SOC_K_1);
        Out_Put_K.CS_1_K = OutPut_CS_1_K_Filter;  
        
    else
       %% Work Mode 2 : EM
        OutPut_CS_2_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Cal_EV_EV(PHEV,T_F_K,W_F_K,Input_K,Cost);
        OutPut_CS_2_K_Filter = LiangQu_MoreGear.Example.EV_3S_SJTU.G_SOC_Filter(OutPut_CS_2_K,SOC_K_1);
        Out_Put_K.CS_2_K = OutPut_CS_2_K_Filter;
        Out_Put_K.OutPut_CS_2_K = OutPut_CS_2_K;
    end  
    
end


