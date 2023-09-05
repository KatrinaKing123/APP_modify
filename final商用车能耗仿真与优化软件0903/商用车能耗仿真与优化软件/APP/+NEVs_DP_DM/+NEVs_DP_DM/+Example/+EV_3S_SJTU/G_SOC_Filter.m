function G_SOC_Filter = G_SOC_Filter(OutPut_K,SOC_K_1,PHEV)
%     %% Gear == 1
%     G_Index = OutPut_K.G_K_1_Grid == 1;
%     S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%     G_SOC.CS_1_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
% 
%     %% Gear == 2
%     G_Index = OutPut_K.G_K_1_Grid == 2;
%     S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%     G_SOC.CS_2_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
% 
%     %% Gear == 3
%     G_Index = OutPut_K.G_K_1_Grid == 3;
%     S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%     G_SOC.CS_3_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
% 
%     %% Gear == 4
%     G_Index = OutPut_K.G_K_1_Grid == 4;
%     S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%     G_SOC.CS_4_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
% 
%     %% Gear == 5
%     G_Index = OutPut_K.G_K_1_Grid == 5;
%     S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%     G_SOC.CS_5_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
% 
%     %% Merge
%     G_SOC_Filter = Example.EV_3S_SJTU.G_SOC__Data_Merge(G_SOC);
% 
% end


U_G = PHEV.U_G;
G_SOC.CS_K =cell(1,PHEV.Num_U_G_K);

for i = U_G
     G_Index = OutPut_K.G_K_1_Grid == i;
     S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
     
     G_SOC.CS_K{U_G==i} = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
end
     
     
%  G_Index = OutPut_K.G_K_1_Grid == 0;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_1_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
% 
%  G_Index = OutPut_K.G_K_1_Grid == 0.1;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_2_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.2;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_3_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.3;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_4_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.4;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_5_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.5;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_6_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.6;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_7_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.7;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_8_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.8;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_9_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 0.9;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_10_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
%  
%  G_Index = OutPut_K.G_K_1_Grid == 1;
%  S_OutPut_K = Example.EV_3S_SJTU.Data_For_G_SOC(OutPut_K,G_Index);
%  G_SOC.CS_11_K = Example.EV_3S_SJTU.SOC_Filter(S_OutPut_K,SOC_K_1);
 
 G_SOC_Filter = Example.EV_3S_SJTU.G_SOC__Data_Merge_1(G_SOC,PHEV);

end



