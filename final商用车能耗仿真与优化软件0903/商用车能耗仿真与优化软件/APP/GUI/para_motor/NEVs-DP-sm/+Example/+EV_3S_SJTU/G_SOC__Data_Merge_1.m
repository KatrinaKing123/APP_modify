function OutPut_K = G_SOC__Data_Merge_1(Out_Put_K,PHEV)
    i=1;
    OutPut_K.T_m_Front_K_Grid = Out_Put_K.CS_K{i}.T_m_Front_K_Grid;   
    OutPut_K.W_m_Front_K_Grid = Out_Put_K.CS_K{i}.W_m_Front_K_Grid;   
    OutPut_K.T_m_Rear_K_Grid = Out_Put_K.CS_K{i}.T_m_Rear_K_Grid;    
    OutPut_K.W_m_Rear_K_Grid = Out_Put_K.CS_K{i}.W_m_Rear_K_Grid;   
    
    OutPut_K.SOC_K_Grid = Out_Put_K.CS_K{i}.SOC_K_Grid;    
    OutPut_K.SOC_K_1_Grid = Out_Put_K.CS_K{i}.SOC_K_1_Grid; 
    OutPut_K.G_K_Grid = Out_Put_K.CS_K{i}.G_K_Grid;       
    OutPut_K.G_K_1_Grid = Out_Put_K.CS_K{i}.G_K_1_Grid;      
    OutPut_K.P_em_K_Grid = Out_Put_K.CS_K{i}.P_em_K_Grid;  
    OutPut_K.Pb_K_Grid = Out_Put_K.CS_K{i}.Pb_K_Grid;       
    OutPut_K.J_K_1_Grid = Out_Put_K.CS_K{i}.J_K_1_Grid;     
    OutPut_K.M_K_1_Grid = Out_Put_K.CS_K{i}.M_K_1_Grid;    
    OutPut_K.M_K_Grid = Out_Put_K.CS_K{i}.M_K_Grid;       
    OutPut_K.Fuel_K_1_Grid = Out_Put_K.CS_K{i}.Fuel_K_1_Grid; 
    
   for j = (2:1:PHEV.Num_U_G_K)
    OutPut_K.T_m_Front_K_Grid = cat(2,OutPut_K.T_m_Front_K_Grid, Out_Put_K.CS_K{j}.T_m_Front_K_Grid);   
    OutPut_K.W_m_Front_K_Grid = cat(2,OutPut_K.W_m_Front_K_Grid, Out_Put_K.CS_K{j}.W_m_Front_K_Grid);   
    OutPut_K.T_m_Rear_K_Grid = cat(2,OutPut_K.T_m_Rear_K_Grid, Out_Put_K.CS_K{j}.T_m_Rear_K_Grid);    
    OutPut_K.W_m_Rear_K_Grid = cat(2,OutPut_K.W_m_Rear_K_Grid, Out_Put_K.CS_K{j}.W_m_Rear_K_Grid);   
    
    OutPut_K.SOC_K_Grid = cat(2,OutPut_K.SOC_K_Grid, Out_Put_K.CS_K{j}.SOC_K_Grid);    
    OutPut_K.SOC_K_1_Grid = cat(2,OutPut_K.SOC_K_1_Grid, Out_Put_K.CS_K{j}.SOC_K_1_Grid); 
    OutPut_K.G_K_Grid = cat(2,OutPut_K.G_K_Grid, Out_Put_K.CS_K{j}.G_K_Grid);       
    OutPut_K.G_K_1_Grid = cat(2,OutPut_K.G_K_1_Grid, Out_Put_K.CS_K{j}.G_K_1_Grid);      
    OutPut_K.P_em_K_Grid = cat(2,OutPut_K.P_em_K_Grid, Out_Put_K.CS_K{j}.P_em_K_Grid);  
    OutPut_K.Pb_K_Grid = cat(2,OutPut_K.Pb_K_Grid, Out_Put_K.CS_K{j}.Pb_K_Grid);       
    OutPut_K.J_K_1_Grid = cat(2,OutPut_K.J_K_1_Grid, Out_Put_K.CS_K{j}.J_K_1_Grid);     
    OutPut_K.M_K_1_Grid = cat(2,OutPut_K.M_K_1_Grid, Out_Put_K.CS_K{j}.M_K_1_Grid);    
    OutPut_K.M_K_Grid = cat(2,OutPut_K.M_K_Grid, Out_Put_K.CS_K{j}.M_K_Grid);       
    OutPut_K.Fuel_K_1_Grid = cat(2,OutPut_K.Fuel_K_1_Grid, Out_Put_K.CS_K{j}.Fuel_K_1_Grid); 
     
    
   end

    
end