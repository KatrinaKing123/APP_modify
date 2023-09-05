function G_SOC_Filter = G_SOC_Filter(OutPut_K,SOC_K_1)
    %% Gear == 1
    G_Index = OutPut_K.G_K_1_Grid == 1;
    S_OutPut_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
    G_SOC.CS_1_K = LiangQu_MoreGear.Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);

    %% Gear == 2
    G_Index = OutPut_K.G_K_1_Grid == 2;
    S_OutPut_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
    G_SOC.CS_2_K = LiangQu_MoreGear.Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);

    %% Gear == 3
    G_Index = OutPut_K.G_K_1_Grid == 3;
    S_OutPut_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
    G_SOC.CS_3_K = LiangQu_MoreGear.Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);

    %% Gear == 4
    G_Index = OutPut_K.G_K_1_Grid == 4;
    S_OutPut_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
    G_SOC.CS_4_K = LiangQu_MoreGear.Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);

    %% Gear == 5
    G_Index = OutPut_K.G_K_1_Grid == 5;
    S_OutPut_K = LiangQu_MoreGear.Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
    G_SOC.CS_5_K = LiangQu_MoreGear.Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);

    %% Merge
    G_SOC_Filter = LiangQu_MoreGear.Example.EV_3S_SJTU.G_SOC__Data_Merge(G_SOC);

end






