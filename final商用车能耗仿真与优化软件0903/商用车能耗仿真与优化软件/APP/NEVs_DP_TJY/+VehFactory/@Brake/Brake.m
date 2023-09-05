classdef Brake < handle
    properties
        Beta  
        Brake_Speed_Limit
        Elec_Brake_Dec_Limit
        F_t
        F_brake
        Velocity
    end
    
    methods
        function obj = Brake(Par_Veh)
            obj.Beta = Par_Veh.Beta;
            obj.Brake_Speed_Limit = Par_Veh.Brake_Speed_Limit;
            obj.Elec_Brake_Dec_Limit = Par_Veh.Elec_Brake_Dec_Limit;
        end
        Cal_Brake(obj,VehBody);
    end
end    
