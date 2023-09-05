%% 车速计算电机扭矩代替加速踏板位置
%version:1.1
% clear;
% clc;
close all;
%% 车辆参数
m = m_f;
g = gravity;
alpha=0;
C_d = Cd;
A_d = A;
r = r_wheel;
i0=r0;
n_t=0.95;
delta=1.0;
%% 原始能耗计算
Batt_origin.Power=Batt_origin.Power(1:1/Batt_origin.time_diff:end);
Power=Batt_origin.Power';
Origin_E = means_fillter(Power,5);
%% 压缩机功率
ActuPwr = ActuPwr_origindata(:,2);
ActuPwr = ActuPwr(1:1/ActuPwr_origin.time_diff:end);
ActuPwr = means_fillter(ActuPwr,5);
%% 车速数据
velocity = velocity_origindata(:,2);
velocity = velocity(1:1/velocity_origin.time_diff:end);
velocity = means_fillter(velocity,5);
cycle_vs = velocity;
Len_Cycle=length(cycle_vs);
%% 能耗计算
energy_seq=[];
energy_seq_wujiaohe=[];
for i=1:Len_Cycle-1
    velocity_cur=cycle_vs(i);
    velocity_next=cycle_vs(i+1);
    velocity_avg=(velocity_cur+velocity_next)/2;
    delta_T = 1;
    acc=(velocity_next-velocity_cur)/delta_T/3.6;

    F_f=m*g*f*cos(alpha);                                                  %滚动阻力
    F_w=C_d*A_d*cycle_vs(i).^2/21.15;                                      %风阻
    F_i=m*g*sin(alpha);                                                    %坡度阻力
    F_j=delta*m*acc;                                                       %加速阻力
    F_t=(F_f+F_w+F_i+F_j).*gt(cycle_vs(i),0);                              %行驶阻力
    
    T_veh=F_t*r;
    T_tq=F_t*r/i0/n_t;

    
    n=velocity_cur*60*i0/(2*pi*r*3.6);
    if n>max(Motor_Model_struct.mc_max_spd_dr)
        n=max(Motor_Model_struct.mc_max_spd_dr);
        str1="Motor speed exceed!";
        disp(str1);
    end
    T_Max=interp1(Motor_Model_struct.mc_max_spd_dr,Motor_Model_struct.mc_max_trq_dr,n,'linear','extrap');
    T_Min=interp1(Motor_Model_struct.mc_max_spd_br,Motor_Model_struct.mc_max_gen_trq,n,'linear','extrap');
        
    if T_tq>=0
        if T_tq>T_Max
            T_tq=T_Max;
            Eff_Motor_Drive=interp2(Motor_Model_struct.mc_map_spd,Motor_Model_struct.mc_map_trq,Motor_Model_struct.mc_eff_map',n,T_tq,"linear");
            energy_wujiaohe=T_tq*n/9550/Eff_Motor_Drive;
            P_Motor_m=T_tq*n/9550;
            P_Motor_e= Motor_Result_Drv.a * P_Motor_m^2 + Motor_Result_Drv.b * P_Motor_m + Motor_Result_Drv.c;
            energy=P_Motor_e;
        else
            Eff_Motor_Drive=interp2(Motor_Model_struct.mc_map_spd,Motor_Model_struct.mc_map_trq,Motor_Model_struct.mc_eff_map',n,T_tq,"linear");
            energy_wujiaohe=T_tq*n/9550/Eff_Motor_Drive;
            P_Motor_m=T_tq*n/9550;
            P_Motor_e= Motor_Result_Drv.a * P_Motor_m^2 + Motor_Result_Drv.b * P_Motor_m + Motor_Result_Drv.c;
            energy=P_Motor_e;
        end
    elseif T_tq<0
        if T_tq<T_Min
            T_tq=T_Min;
            Eff_Motor_Reg=interp2(Motor_Model_struct.mc_map_spd,Motor_Model_struct.mc_map_trq,Motor_Model_struct.mc_eff_map',n,T_tq,"linear");
            energy_wujiaohe=T_tq*n*Eff_Motor_Reg/9550;
            P_Motor_m=T_tq*n/9550;
            P_Motor_e=Motor_Result_Brk.a * P_Motor_m^2 + Motor_Result_Brk.b * P_Motor_m + Motor_Result_Brk.c;
            energy=P_Motor_e;
        else
            Eff_Motor_Reg=interp2(Motor_Model_struct.mc_map_spd,Motor_Model_struct.mc_map_trq,Motor_Model_struct.mc_eff_map',n,T_tq,"linear");
            P_Motor_m=T_tq*n/9550;
            energy_wujiaohe=T_tq*n*Eff_Motor_Reg/9550;
            P_Motor_e=Motor_Result_Brk.a * P_Motor_m^2 + Motor_Result_Brk.b * P_Motor_m + Motor_Result_Brk.c;
            energy=P_Motor_e;
        end
    end
    if isnan(energy)
        energy=0;
    end
    if isnan(energy_wujiaohe)
        energy_wujiaohe=0;
    end
    energy_seq=[energy_seq,energy];
    energy_seq_wujiaohe = [energy_seq_wujiaohe, energy_wujiaohe];
end

Energy_seq=[];
for index=1:(length(energy_seq)-1)
    e=(energy_seq(index)+energy_seq(index+1))/2+ActuPwr(index);
    Energy_seq=[Energy_seq,e];
end
Cal_E=sum(Energy_seq)/3600;

Energy_seq_wujiaohe=[];
for index=1:(length(energy_seq_wujiaohe)-1)
    e=(energy_seq_wujiaohe(index)+energy_seq_wujiaohe(index+1))/2+ActuPwr(index);
    Energy_seq_wujiaohe=[Energy_seq_wujiaohe,e];
end
Cal_E_wujiaohe=sum(Energy_seq_wujiaohe)/3600;

Energy_origin_seq=[];
for index=1:(length(Origin_E)-1)
    Energy_origin=(Origin_E(index)+Origin_E(index+1))/2;
    Energy_origin_seq=[Energy_origin_seq,Energy_origin];
end
Cal_Origin_E=sum(Energy_origin_seq)/3600;
