function Cal_Wheel(obj,Brake)
%% Wheel Parameters
R = obj.R;

%% Traction Force 
F_t = Brake.F_t;
Velocity = Brake.Velocity;

%% Calculation of Traction Force  
obj.Tw = F_t * R;
obj.Ww = Velocity / R;
end
