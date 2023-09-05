function  Cal_Motor_T_Limit_By_W(obj)
%% Motor Parameters
Speed = obj.Speed;
Trq_Max = obj.Trq_Max;
Trq_Min = obj.Trq_Min;
Wm = obj.Wm;

%% Calculation
obj.Min_Trq_K = interp1(Speed, Trq_Min, Wm, 'linear');
obj.Max_Trq_K = interp1(Speed, Trq_Max, Wm, 'linear');
end
