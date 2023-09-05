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
%��ǰת�ٵ�������غ���С����
T_m = (Tm >= Min_Trq) .* Tm + (Tm < Min_Trq) .* Min_Trq;
%TmС����Сֵ������ʱ��Ϊ��Сֵ������ƶ��ﵽ���ֵ����Tm������Сֵ������ʱ����

In_Motor_Traq = (T_m > Max_Trq);

% T_m = (Tm < Min_Trq) .* Min_Trq + (Tm > Max_Trq) .* Max_Trq + (Tm >= Min_Trq) .* (Tm <= Max_Trq) .* Tm; 
%û����ΪʲôTm> Max_Trq��Ҫ����
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

