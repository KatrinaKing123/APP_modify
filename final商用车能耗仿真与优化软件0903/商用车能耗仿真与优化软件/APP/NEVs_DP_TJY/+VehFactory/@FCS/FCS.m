classdef FCS < handle
    properties
        FCS_H2_P1
        FCS_H2_P2
        FCS_H2_P3
        FCS_AUX_P1
        FCS_AUX_P2
        FCS_AUX_P3
        FCS_P_Min
        FCS_P_Idle
        FCS_P_Max
        Ts
        FCS_Rate_Max
        FCS_Rate_Max_Down
        FCS_Rate_Min_Up
        FCS_Rate_Min 
        % P_FCS
        P_FCS_Aux
        H2
        In_FCS
        PF_K
        PF_K_1
    end
    methods
        function obj = FCS(Par_FCS)
            obj.FCS_H2_P1 = Par_FCS.FCS_H2_P1;
            obj.FCS_H2_P2 = Par_FCS.FCS_H2_P2;
            obj.FCS_H2_P3 = Par_FCS.FCS_H2_P3;
            obj.FCS_AUX_P1 = Par_FCS.FCS_AUX_P1;
            obj.FCS_AUX_P2 = Par_FCS.FCS_AUX_P2;
            obj.FCS_AUX_P3 = Par_FCS.FCS_AUX_P3;
            obj.FCS_P_Min = Par_FCS.FCS_P_Min;
            obj.FCS_P_Idle = Par_FCS.FCS_P_Idle;
            obj.FCS_P_Max = Par_FCS.FCS_P_Max;
            obj.Ts = Par_FCS.Ts; 
            obj.FCS_Rate_Max = Par_FCS.FCS_Rate_Max;
            obj.FCS_Rate_Max_Down = Par_FCS.FCS_Rate_Max_Down;
            obj.FCS_Rate_Min_Up = Par_FCS.FCS_Rate_Min_Up;
            obj.FCS_Rate_Min = Par_FCS.FCS_Rate_Min;
        end
        Cal_FCS_Aux_H2(obj,P_FCS_K_1);
        Cal_FCS_Aux(obj,P_FCS_K_1);
        Cal_Inval_CS_FCS_Open(obj, P_FCS_K, P_FCS_K_1);
        Cal_Inval_CS_FCS(obj, P_FCS_K, P_FCS_K_1);
        
        
    end
end    
