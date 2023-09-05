classdef DCF < handle
    properties
        FCS2DCF_P1
        FCS2DCF_P2
        P_FCS
        P_DCF
    end
    
    methods
        function obj = DCF(Par_DCF)
            obj.FCS2DCF_P1 = Par_DCF.FCS2DCF_P1;
            obj.FCS2DCF_P2 = Par_DCF.FCS2DCF_P2;
        end
        Cal_DCF(obj,FCS);
    end
end    
