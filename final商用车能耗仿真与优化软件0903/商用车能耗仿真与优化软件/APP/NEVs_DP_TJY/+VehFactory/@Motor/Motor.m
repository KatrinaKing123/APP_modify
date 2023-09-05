classdef Motor < handle
    properties
        Speed
        Trq_Max
        Trq_Min
        W_Row
        T_Col
        Eff_map
        Tm
        Wm
        In_Motor
        P_EM
        P_me_D
        Speed_D
        T_Map_D
        P_me_B
        Speed_B
        T_Map_B
        Min_Trq_K
        Max_Trq_K
    end
    
    methods
        function obj = Motor(Par_Motor) 
            obj.Speed = Par_Motor.Speed;
            obj.Trq_Max = Par_Motor.Trq_Max;
            obj.Trq_Min = Par_Motor.Trq_Min;
            obj.W_Row = Par_Motor.W_Row;
            obj.T_Col = Par_Motor.T_Col;
            obj.Eff_map = Par_Motor.Eff_map;
        end
        Cal_Motor(obj);
    end
end    
