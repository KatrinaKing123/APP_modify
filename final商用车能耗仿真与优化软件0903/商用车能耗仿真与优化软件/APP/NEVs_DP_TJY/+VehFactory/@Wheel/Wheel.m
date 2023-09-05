classdef Wheel < handle
    properties
        R
        Tw
        Ww
    end
    methods
        function obj = Wheel(Par_Wheel)
            obj.R = Par_Wheel.R;
        end
        Cal_Wheel(obj,Brake);
    end
end    