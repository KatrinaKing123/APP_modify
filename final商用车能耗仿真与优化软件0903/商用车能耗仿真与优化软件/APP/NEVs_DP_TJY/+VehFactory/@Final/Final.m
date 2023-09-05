classdef Final < handle
    properties
        Ratio
        Eff
        Tf
        Wf
    end
    
    methods
        function obj = Final(Par_Wheel)
            obj.Ratio = Par_Wheel.Ratio;
            obj.Eff = Par_Wheel.Eff;
        end
        Cal_Final(obj,Wheel);
    end
end    
