function Cal_ICE(obj,Input_K)
%% ICE Parameters
Speed = obj.Speed;
Trq_Max = obj.Trq_Max;
W_Row = obj.W_Row;
T_Col = obj.T_Col;
Fuel_map = obj.Fuel_map;
Trq_Min = obj.Trq_Min;
Speed_Min = obj.Speed_Min;
Speed_Max = obj.Speed_Max;

T_ICE = Input_K.T_ICE;
W_ICE = Input_K.W_ICE;
ICE_Mode = Input_K.ICE_Mode;

%% Calculation
T_ICE_Max = interp1(Speed, Trq_Max, W_ICE, 'linear');
% ICE_Fuel = interp2(T_Col,W_Row,Fuel_map,T_ICE,W_ICE, 'nearest');
ICE_Fuel = interp2(T_Col,W_Row,Fuel_map,T_ICE,W_ICE, 'nearest');
In_ICE_T = (T_ICE > T_ICE_Max) | (T_ICE < Trq_Min); % ICE Work
In_ICE_W = (W_ICE > Speed_Max) | (W_ICE < Speed_Min);  % ICE Work
In_ICE_Fuel = isnan(ICE_Fuel);
In_ICE_T_W = (In_ICE_T | In_ICE_W | In_ICE_Fuel);

%% Update
% ICE_T_W_Index = (ICE_Mode == 1) .* (T_ICE <= 0) & (1 - In_ICE_W);
% In_ICE_T_W(ICE_T_W_Index) = 0;
% ICE_Fuel(ICE_T_W_Index) = 0;

%% Output
obj.In_ICE = In_ICE_T_W;
obj.Fuel_K = ICE_Fuel;

end

