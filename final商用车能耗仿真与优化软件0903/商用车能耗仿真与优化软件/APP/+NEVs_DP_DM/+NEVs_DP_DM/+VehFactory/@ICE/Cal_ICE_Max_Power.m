function Cal_ICE_Max_Power(obj)
%% ICE Parameters
Speed = obj.Speed;
Trq_Max = obj.Trq_Max;

%% Calculation
obj.ICE_Max_Power = max(Trq_Max.*Speed);

end

