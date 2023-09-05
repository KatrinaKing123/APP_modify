function Cal_VehBody(obj)
%% Vehicle Parameters
M_F = obj.M_F;
Gravity = obj.Gravity;
Cd = obj.Cd;
Air_Density = obj.Air_Density;
A_F = obj.A_F;
Mu = obj.Mu;
mt2m_f = obj.mt2m_f;
Velocity = obj.Velocity;   
Acceleration = obj.Acceleration;
Grade = obj.Grade;

%% Calculation of Traction Force 
Fr = (Velocity > 0) * Mu * M_F * Gravity * cos(Grade);
Fw = 0.5 * Air_Density * Cd * A_F * power(Velocity,2);
Fi = M_F * Gravity * sin(Grade);
Fa = (1 + mt2m_f) * M_F * Acceleration;   
obj.Ft = Fr + Fw + Fi + Fa;

end