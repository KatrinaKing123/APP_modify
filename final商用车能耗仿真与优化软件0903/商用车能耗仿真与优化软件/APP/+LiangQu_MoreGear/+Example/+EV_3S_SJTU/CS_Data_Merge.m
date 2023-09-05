function OutPut_K = CS_Data_Merge(Out_Put_K)
    OutPut_K.T_m_K_Grid    = [Out_Put_K.CS_1_K.T_m_K_Grid,     Out_Put_K.CS_2_K.T_m_K_Grid];
    OutPut_K.W_m_K_Grid    = [Out_Put_K.CS_1_K.W_m_K_Grid,     Out_Put_K.CS_2_K.W_m_K_Grid];
    OutPut_K.SOC_K_Grid    = [Out_Put_K.CS_1_K.SOC_K_Grid,     Out_Put_K.CS_2_K.SOC_K_Grid];
    OutPut_K.SOC_K_1_Grid  = [Out_Put_K.CS_1_K.SOC_K_1_Grid,   Out_Put_K.CS_2_K.SOC_K_1_Grid];
    OutPut_K.G_K_Grid      = [Out_Put_K.CS_1_K.G_K_Grid,       Out_Put_K.CS_2_K.G_K_Grid];
    OutPut_K.G_K_1_Grid    = [Out_Put_K.CS_1_K.G_K_1_Grid,     Out_Put_K.CS_2_K.G_K_1_Grid];
    OutPut_K.P_em_K_Grid   = [Out_Put_K.CS_1_K.P_em_K_Grid,    Out_Put_K.CS_2_K.P_em_K_Grid];
    OutPut_K.Pb_K_Grid     = [Out_Put_K.CS_1_K.Pb_K_Grid,      Out_Put_K.CS_2_K.Pb_K_Grid];
    OutPut_K.J_K_1_Grid    = [Out_Put_K.CS_1_K.J_K_1_Grid,     Out_Put_K.CS_2_K.J_K_1_Grid];
    OutPut_K.M_K_1_Grid    = [Out_Put_K.CS_1_K.M_K_1_Grid,     Out_Put_K.CS_2_K.M_K_1_Grid];
    OutPut_K.M_K_Grid      = [Out_Put_K.CS_1_K.M_K_Grid,       Out_Put_K.CS_2_K.M_K_Grid];
    OutPut_K.Fuel_K_1_Grid = [Out_Put_K.CS_1_K.Fuel_K_1_Grid,  Out_Put_K.CS_2_K.Fuel_K_1_Grid];
end