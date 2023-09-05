classdef Batt < handle
    properties
        ESS_SOC
        ESS_VOC
        ESS_R_D
        ESS_R_C
        Q_Ah
        Col_Eff
        Ts
        SOC_Max
        SOC_Min
        P_Batt_Max
        P_Batt_Min
        I_Max
        I_Min
        Deta_SOC_Min
        Deta_SOC_Max
        SOC_K
        SOC_K_1
        P_Batt_K
        In_Batt
    end
    
    methods
        function obj = Batt(Par_Batt)
            obj.ESS_SOC = Par_Batt.ESS_SOC;
            obj.ESS_VOC = Par_Batt.ESS_VOC;
            obj.ESS_R_D = Par_Batt.ESS_R_D;
            obj.ESS_R_C = Par_Batt.ESS_R_C;
            obj.Q_Ah = Par_Batt.Q_Ah;
            obj.Col_Eff = Par_Batt.Col_Eff;
            obj.Ts = Par_Batt.Ts;
            obj.SOC_Max = Par_Batt.SOC_Max;
            obj.SOC_Min = Par_Batt.SOC_Min;
            obj.P_Batt_Max = Par_Batt.P_Batt_Max;
            obj.P_Batt_Min = Par_Batt.P_Batt_Min;
            obj.I_Max = Par_Batt.I_Max;
            obj.I_Min = Par_Batt.I_Min;
        end
        Cal_SOC(obj);
        Cal_SOC_R(obj);
        Cal_P_Batt_By_SOC(obj);
    end
end










