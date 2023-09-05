function [Fuel_K, In_ICE] = Cal_ICE(Par_ICE)
%% ICE Parameters
Speed = Par_ICE.Speed;
Trq_Max = Par_ICE.Trq_Max;
W_Row = Par_ICE.W_Row;
T_Col = Par_ICE.T_Col;
Fuel_map = Par_ICE.Fuel_map;
Trq_Min = Par_ICE.Trq_Min;
Speed_Min = Par_ICE.Speed_Min;
Speed_Max = Par_ICE.Speed_Max;
T_ICE = Par_ICE.T_ICE;
W_ICE = Par_ICE.W_ICE;

%% Calculation
T_ICE_Max = interp1(Speed, Trq_Max, W_ICE, 'linear');
ICE_Fuel = interp2(T_Col,W_Row,Fuel_map,T_ICE,W_ICE, 'nearest');
In_ICE_T = (T_ICE > T_ICE_Max) | (T_ICE < Trq_Min); 
In_ICE_W = (W_ICE > Speed_Max) | (W_ICE < Speed_Min); 
In_ICE_Fuel = isnan(ICE_Fuel);
ICE_Fuel(isnan(ICE_Fuel)) = 500000;
In_ICE = (In_ICE_T | In_ICE_W | In_ICE_Fuel);
Fuel_K = ICE_Fuel;

end

