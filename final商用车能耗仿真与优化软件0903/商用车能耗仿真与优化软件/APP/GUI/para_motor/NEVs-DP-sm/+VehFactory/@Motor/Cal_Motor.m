function  Cal_Motor(obj)
%% Motor Parameters
Speed = obj.Speed;
speed_min=obj.speed_min;
speed_max=obj.speed_max;
Trq_Max = obj.Trq_Max;
Trq_Min = obj.Trq_Min;
W_Row = obj.W_Row;
T_Col = obj.T_Col;
Eff_map = obj.Eff_map;
Wm = obj.Wm;
Tm = obj.Tm;

%% Calculation
Min_Trq = interp1(speed_min, Trq_Min, Wm, 'linear');
Max_Trq = interp1(speed_max, Trq_Max, Wm, 'linear');
%当前转速的最大力矩和最小力矩
T_m = (Tm >= Min_Trq) .* Tm + (Tm < Min_Trq) .* Min_Trq;
%Tm小于最小值（负）时变为最小值（电机制动达到最大值），Tm大于最小值（负）时不变

In_Motor_Traq = (T_m > Max_Trq);

% T_m = (Tm < Min_Trq) .* Min_Trq + (Tm > Max_Trq) .* Max_Trq + (Tm >= Min_Trq) .* (Tm <= Max_Trq) .* Tm; 
%没看懂为什么Tm> Max_Trq还要留着
% EM_Eff_1 = 1 ./ interp2(T_Col, W_Row, Eff_map, T_m, Wm, 'nearest');
% EM_Eff_2 = interp2(T_Col, W_Row, Eff_map,T_m, Wm, 'nearest');
EM_Eff_1 = 1 ./ interp2(W_Row, T_Col, Eff_map, Wm, T_m, 'nearest');
EM_Eff_2 = interp2(W_Row, T_Col, Eff_map,Wm, T_m, 'nearest');
EM_Eff = (T_m >=  0) .* EM_Eff_1 + (T_m <  0) .* EM_Eff_2;
obj.P_EM = T_m .* Wm .* EM_Eff;

obj.T_m = T_m;
obj.EM_Eff = EM_Eff;

%% Motor Invalue
In_Motor_Speed = (Wm > max(Speed));
obj.In_Motor = In_Motor_Speed | In_Motor_Traq;
 
end

