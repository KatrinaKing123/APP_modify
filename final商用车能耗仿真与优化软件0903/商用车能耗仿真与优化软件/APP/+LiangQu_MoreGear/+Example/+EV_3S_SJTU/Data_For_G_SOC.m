function S_OutPut_K = Data_For_G_SOC(OutPut_K_G,G_Index)
	S_OutPut_K.T_m_K_Grid = OutPut_K_G.T_m_K_Grid(G_Index);
	S_OutPut_K.W_m_K_Grid = OutPut_K_G.W_m_K_Grid(G_Index);
	S_OutPut_K.SOC_K_Grid = OutPut_K_G.SOC_K_Grid(G_Index);
	S_OutPut_K.SOC_K_1_Grid = OutPut_K_G.SOC_K_1_Grid(G_Index);
	S_OutPut_K.G_K_Grid = OutPut_K_G.G_K_Grid(G_Index);
	S_OutPut_K.G_K_1_Grid = OutPut_K_G.G_K_1_Grid(G_Index);
	S_OutPut_K.P_em_K_Grid = OutPut_K_G.P_em_K_Grid(G_Index);
	S_OutPut_K.Pb_K_Grid = OutPut_K_G.Pb_K_Grid(G_Index);
	S_OutPut_K.J_K_1_Grid = OutPut_K_G.J_K_1_Grid(G_Index);
	S_OutPut_K.M_K_Grid = OutPut_K_G.M_K_Grid(G_Index);
	S_OutPut_K.M_K_1_Grid = OutPut_K_G.M_K_1_Grid(G_Index);
	S_OutPut_K.Fuel_K_1_Grid = OutPut_K_G.Fuel_K_1_Grid(G_Index);
end
