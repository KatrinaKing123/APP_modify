classdef GearBox < handle
    properties
        Index
        Ratio
        Eff
        Tg
        Wg
    end
    
    methods
        function obj = GearBox(Par_GearBox)
            obj.Index = Par_GearBox.Index;
            obj.Ratio = Par_GearBox.Ratio;
            obj.Eff = Par_GearBox.Eff;
        end
        Cal_GearBox(obj,Final,T_G);
    end
end    
