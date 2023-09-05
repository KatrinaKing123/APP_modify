function Battery_Par = Cal_Battery_GA(obj)

% 编写时间：2023-07-16 
% 编写人：陈宇轩

%% 参数列表
%（1）静态
ess_voc = obj.ess_voc;
% ess_r_chg = obj.ess_r_chg;
% ess_r_dis = obj.ess_r_dis;
Q_Ah =  obj.Q_Ah;
delta_h = obj.delta_h;
enta_col = obj.enta_col;
soc_map=obj.soc_map;
R_D_SOC=obj.R_D_SOC;
R_C_SOC=obj.R_C_SOC;
V_SOC=obj.voc_map;
%（2）动态
Soc_Pre = obj.Soc_Pre;
P_BT = obj.P_BT;

%% 逆向计算当前所需要的牵引力
%（1）蓄电池组开路电压和内阻计算模块
E_oc = ess_voc;   % 电池电动势
if P_BT>0
    Rr=interp1(soc_map,R_D_SOC,Soc_Pre,'linear');
    Vv=interp1(soc_map,V_SOC,Soc_Pre,'linear');
else
    Rr=interp1(soc_map,R_C_SOC,Soc_Pre,'linear');
    Vv=interp1(soc_map,V_SOC,Soc_Pre,'linear');
end
I = (E_oc - sqrt(E_oc.^2 - 4.*P_BT.*Rr))./(2.*Rr);
I = (I + conj(I))./2;
U = E_oc - Rr * I;
Soc_Current = Soc_Pre - I.*delta_h./(enta_col.*3600.*Q_Ah);

Battery_Par.I = I;
Battery_Par.U = U;
Battery_Par.Soc_Current = Soc_Current;


