function Cal_Brake(obj,VehBody)
% Beta = obj.Beta;
 Brake_Speed_Limit = obj.Brake_Speed_Limit;
 Elec_Brake_Dec_Limit = obj.Elec_Brake_Dec_Limit;
 Ft = VehBody.Ft;
 Speed = 3.6 * VehBody.Velocity;
 Acceleration = VehBody.Acceleration;

%% Control strategy of braking force distribution
% F_Brake_Front = Beta .* Ft;
% F_Brake_Rear = (1 - Beta) * Ft; 
% F_Brake_Electric = 0;
F_Electric = Ft;
 if ((Ft < 0) && (Speed <= Brake_Speed_Limit) && (Acceleration <= Elec_Brake_Dec_Limit))
      F_Electric = 0;
 end
%大于阈值才电机制动
obj.F_t = (Ft >= 0) * Ft + (Ft < 0) * F_Electric;
% obj.F_brake = Ft - obj.F_t;
obj.Velocity = VehBody.Velocity;
obj.Acceleration = VehBody.Acceleration;
end

