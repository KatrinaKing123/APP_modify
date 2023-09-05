classdef VehBody < handle
    properties
        M_F
        Gravity
        Cd
        Air_Density
        A_F
        Mu
        mt2m_f
        Velocity
        Acceleration
        Grade
        Ft
    end
    methods
        function obj = VehBody(Par_Veh)
            obj.M_F = Par_Veh.M_F;
            obj.Gravity = Par_Veh.Gravity;
            obj.Cd = Par_Veh.Cd;
            obj.Air_Density = Par_Veh.Air_Density;
            obj.A_F = Par_Veh.A_F;
            obj.Mu = Par_Veh.Mu;
            obj.mt2m_f= Par_Veh.mt2m_f;
            obj.Grade = Par_Veh.Grade;  
        end
        Cal_VehBody(obj);
    end
end    
