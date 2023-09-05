function [P_EM,In_Motor] = Cal_Motor(Par_Mator)
%% Motor Parameters
Speed = Par_Mator.Speed;
Trq_Max = Par_Mator.Trq_Max;
Trq_Min = Par_Mator.Trq_Min;
W_Row = Par_Mator.W_Row;
T_Col = Par_Mator.T_Col;
Eff_map = Par_Mator.Eff_map;
Wm = Par_Mator.Wm;
Tm = Par_Mator.Tm;

%% Calculation
Min_Trq = interp1(Speed, Trq_Min, Wm, 'linear');
Max_Trq = interp1(Speed, Trq_Max, Wm, 'linear');
Tm = (Tm > Min_Trq) .* Tm + (Tm <= Min_Trq) .* Min_Trq;   
In_Motor_Traq = (Tm < Min_Trq) | (Tm > Max_Trq);
T_m = (Tm < Min_Trq) .* Min_Trq + (Tm > Max_Trq) .* Max_Trq + (Tm >= Min_Trq) .* (Tm <= Max_Trq) .* Tm;
EM_Eff_1 = 1 ./ interp2(T_Col, W_Row, Eff_map, T_m, Wm, 'nearest');
EM_Eff_2 = interp2(T_Col, W_Row, Eff_map,T_m, Wm, 'nearest');
EM_Eff = (T_m >=  0) .* EM_Eff_1 + (T_m <  0) .* EM_Eff_2;
P_EM = T_m .* Wm .* EM_Eff;

%% Motor Invalue
In_Motor_Speed = (Wm > max(Speed));
In_Motor = In_Motor_Speed | In_Motor_Traq;

end

