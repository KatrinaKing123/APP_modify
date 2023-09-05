%% 挑出可行组合
% Cal_E=[];
% Time_S = [];
for Dynamic_sort_index = 1 : length(Dynamic_Match_rank)
    
    tic
    v_1 = WLTP(:,2) / 3.6;
    v_1=means_fillter(v_1,5);

    C_D = Cd; % 空气阻力系数
    
    air_density = 1.226; % 空气密度 kg/m3
    area = A; % 迎风面积 m2
    roll_coef = f;
    gravity = g; % 重力加速度
    m = GVW_n; % 车重 kg
    grad = 0; % 坡度
    r = r0; % 车轮半径 m
    
    I0 = i0;
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%没给的参数，暂定%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    iner_coef = delta; % 旋转质量惯性系数
    eff_i0 = nt; % 综合效率，
    
    %% 电机参数
    % 外特性
%     W_external_dr = Motor_valid{1, i}.mc_max_spd_dr; %  外特性查表转速（驱动）单位：rpm
%     T_external_Max = Motor_valid{1, i}.mc_max_trq_dr; % 外特性查表转矩（驱动）单位：Nm
%     W_external_br = Motor_valid{1, i}.mc_max_spd_br; % 外特性查表转速（回收）单位：rpm
%     T_external_Min = Motor_valid{1, i}.mc_max_gen_trq; % 外特性查表转矩（回收）单位：Nm

    W_external_dr = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_max_spd_dr; %  外特性查表转速（驱动）单位：rpm
    T_external_Max = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_max_trq_dr; % 外特性查表转矩（驱动）单位：Nm
    W_external_br = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_max_spd_br; % 外特性查表转速（回收）单位：rpm
    T_external_Min = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_max_gen_trq; % 外特性查表转矩（回收）单位：Nm

    % 效率map图
    W_Row = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_map_spd; % 效率map图查表转速：单位：rpm
    T_Col = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_map_trq; % 效率map图查表转矩：单位：Nm
    Eff_map = Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_eff_map; % 效率map图，效率（驱动回收做在一张表里）
    
    %% 车辆动力学模型
    % 轮边扭矩
    acc_seq = [];
    F_veh_seq = [];
    W_Motor_seq = [];
    T_Motor_seq = [];
    T_veh_seq = [];
    energy_seq = [];
    Eff_seq = [];
    P_Motor_E_seq = [];
    delta_T_m = 20;
    for index = 1 : (length(v_1) - 1)
    
        v_cur = v_1(index);
        v_next = v_1(index+1);
        
        acc = (v_next - v_cur); % 加速度
        acc_seq = [acc_seq,acc];
    
        F_w = 0.5 * C_D * area * air_density * (v_cur^2); % F_w：风阻；
        F_r = m * gravity * cos(grad) * roll_coef; % F_r：滚阻；
        F_c = m * gravity * sin(grad); % 爬坡阻力
        F_i = iner_coef * m * acc; % 惯性阻力
    
        F_veh = F_w + F_r + F_c + F_i;
        F_veh_seq = [F_veh_seq, F_veh];
%         F_Wheel_watch = F_Wheel_1(index)
    
        
        %转速
        n = v_cur * 60 * I0 / (2 * pi * r); % 电机转速 rpm
        
        if n > max(Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_max_spd_dr)
            n = max(Dynamic_Match_rank{1, Dynamic_sort_index}.MotorPar.mc_max_spd_dr);
            str = "motor speed exceed!";
            disp(str);
        end
        W_Motor_seq = [W_Motor_seq, n];
        % 插值求转矩最大值
        T_Max = interp1(W_external_dr,T_external_Max, n,'linear','extrap'); % n对应的转矩最大值（放电）
        T_Min = interp1(W_external_br,T_external_Min, n,'linear','extrap'); % n对应的转矩最大值（充电）
    
        % 轮边扭矩
        T_veh = F_veh * r; % 轮边扭矩
        T_veh_seq = [T_veh_seq, T_veh];
        T_M = T_veh / eff_i0 / I0; % 电机扭矩
         
        if T_M >= 0
            if T_M > T_Max
    
                T_M = T_Max;
                Eff_Motor_Drive = interp2(T_Col, W_Row, Eff_map, T_M, n, 'linear');
                Eff_seq = [Eff_seq, Eff_Motor_Drive];

                
                energy = T_M * n / 9550 / Eff_Motor_Drive;
                if energy > Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max
                    energy = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max;
                end
                P_Motor_e = T_M * n / Eff_Motor_Drive / 9550;
                if P_Motor_e >= Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max
                    P_Motor_e = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max;
                end            
                P_Motor_E_seq = [P_Motor_E_seq, P_Motor_e]; % 电机电功率
            else
                Eff_Motor_Drive = interp2(T_Col, W_Row, Eff_map, T_M, n, 'linear');
                Eff_seq = [Eff_seq, Eff_Motor_Drive];
           
                energy = T_M * n / 9550 / Eff_Motor_Drive;
                if energy >= Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max
                    energy = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max;
                end
                P_Motor_e = T_M * n / Eff_Motor_Drive / 9550;
                if P_Motor_e >= Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max
                    P_Motor_e = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_max;
                end 
                P_Motor_E_seq = [P_Motor_E_seq, P_Motor_e];
            end
        end
        if T_M < 0
            if T_M < T_Min
                T_M = T_Min;
                Eff_Motor_Reg = interp2(T_Col, W_Row, Eff_map, T_M, n, 'linear');
                Eff_seq = [Eff_seq, Eff_Motor_Reg];
           
                energy = 0.7* T_M * n * Eff_Motor_Drive/ 9550 ;
                if energy < Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min
                    energy = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min;
                end
                P_Motor_e = T_M * n * Eff_Motor_Drive / 9550;
                if P_Motor_e < Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min
                    P_Motor_e = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min;
                end            
                P_Motor_E_seq = [P_Motor_E_seq, P_Motor_e];
            else
                Eff_Motor_Reg = interp2(T_Col, W_Row, Eff_map, T_M, n, 'linear');
                Eff_seq = [Eff_seq, Eff_Motor_Reg];
            
                energy = 0.7*T_M * n * Eff_Motor_Drive/ 9550 ;
                if energy < Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min
                    energy = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min;
                end
                P_Motor_e = T_M * n * Eff_Motor_Drive / 9550;
                if P_Motor_e < Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min
                    P_Motor_e = Dynamic_Match_rank{1,Dynamic_sort_index}.BattPar.P_bat_min;
                end
                P_Motor_E_seq = [P_Motor_E_seq, P_Motor_e];            
            end
        end
        
        T_Motor_seq = [T_Motor_seq, T_M];
        energy_seq = [energy_seq, energy]; 
    end
    
    Energy_Seq = [];
    for index2 = 1 : (length(energy_seq)-1)
        e = (energy_seq(index2) + energy_seq(index2+1))/2;
        Energy_Seq = [Energy_Seq, e];
    end
    
    Dynamic_Match_rank{1, Dynamic_sort_index}.Cal_E = sum(Energy_Seq)/3600/L0*100;

    Dynamic_Match_rank{1, Dynamic_sort_index}.time = toc;

    for i = 1:length(energy_seq)
        Energy_cumul_cal(i) = sum(energy_seq(1:i))/3600;
    end
    Dynamic_Match_rank{1, Dynamic_sort_index}.Energycumu = [0,Energy_cumul_cal];

end

%% 找排名为 rand2Eco 的能耗并展示
Com_Match_Result={};
for rank_index = 1 : length(Dynamic_Match_rank)
    for j=1:length(rank2Eco_double)
        if Dynamic_Match_rank{1, rank_index}.rank == str2double(rank2Eco_double(1,j))
            Dynamic_Match_rank{1,rank_index}.Rank=rank_index;
            Com_Match_Result{end+1}=Dynamic_Match_rank{1,rank_index};
        end
    end
end


