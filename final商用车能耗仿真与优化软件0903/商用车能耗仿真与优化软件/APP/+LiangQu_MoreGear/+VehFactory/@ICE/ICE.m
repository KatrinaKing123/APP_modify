classdef ICE < handle
    properties
        Speed
        Trq_Max
        W_Row
        T_Col
        Fuel_map
        Trq_Min
        Speed_Min
        Speed_Max
        In_ICE
        W_ICE
        ICE_Max_Power
        Fuel_K
    end
    methods
        function obj = ICE(Par_ICE)
            obj.Speed = Par_ICE.Speed;
            obj.Trq_Max = Par_ICE.Trq_Max;
            obj.W_Row = Par_ICE.W_Row;
            obj.T_Col = Par_ICE.T_Col;
            obj.Fuel_map = Par_ICE.Fuel_map;
            obj.Trq_Min = Par_ICE.Trq_Min;
            obj.Speed_Min = Par_ICE.Speed_Min;
            obj.Speed_Max = Par_ICE.Speed_Max;
        end
        Cal_ICE(obj,Wheel);
        Cal_ICE_Max_Power(obj);
    end
end    
