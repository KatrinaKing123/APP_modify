function restrict_I(obj)
%% Battery Parameters
ESS_SOC = obj.ESS_SOC; %SOCֵ
ESS_VOC = obj.ESS_VOC; %��·��ѹ
ESS_R_D = obj.ESS_R_D; %�ŵ����
ESS_R_C = obj.ESS_R_C; %������
I_Min = obj.I_Min; %��С��������磬��
SOC_K = obj.SOC_K; 
P_Batt_K = obj.P_Batt_K;

%% Calculation
R_D = interp1(ESS_SOC, ESS_R_D, SOC_K, 'linear');
R_C = interp1(ESS_SOC, ESS_R_C, SOC_K, 'linear');
VOC = interp1(ESS_SOC, ESS_VOC, SOC_K, 'linear');
% �����������
R = (P_Batt_K >= 0) .* R_D + (P_Batt_K < 0) .* R_C;
% ͳһ��ŵ����
I_K = (VOC - sqrt(VOC .* VOC - 4 .* R .* P_Batt_K)) ./ (2 .* R);

I_Real = (I_K >= 0).* I_K + (I_K < 0).* max(I_K, I_Min);
Pb_Real = ( VOC.^2 - (VOC - 2.*R.*I_Real).^2 )./(4.*R);


obj.Pb_Real = Pb_Real;



end