%% EV63静态参数
% 编写时间：2023-06-27
% 编写人：陈宇轩
% 说明：EV车静态参数，后向模型


%% 车身部分 （待补充滑行阻力曲线）
Par_Vehicle_Static.gravity = 9.81;                                         % 重力加速度，单位：m/s^2
Par_Vehicle_Static.air_density=1.2;                                        % 空气密度，单位：kg/m^3
Par_Vehicle_Static.m_f = 2881;                                             % 车身重量，单位：kg      
Par_Vehicle_Static.Cd = 0.198;                                             % 空气阻力系数
Par_Vehicle_Static.A_f=4.75;                                               % 迎风面积，单位：m^2
Par_Vehicle_Static.mu = 0.018;                                             % 滚动阻力系数
Par_Vehicle_Static.mt2m_f = 0.03;
Par_Vehicle_Static.g_f = 12.1;                                             % 主减速比

Par_Vehicle_Static.L=3.760;                                                %轴距，单位：m
Par_Vehicle_Static.a = 1.735;                                              % 前轴到质心的距离
Par_Vehicle_Static.b = 1.568 ;                                             % 后轴到质心的距离
Par_Vehicle_Static.hg = 0.88;
Par_Vehicle_Static.coefficient = 0.8;                                      % 当前道路附着系数
Par_SM_Static.Par_Vehicle_Static = Par_Vehicle_Static;

%% 车轮部分
Par_Wheel_Static.r_wheel=0.346;                                            %车轮半径，单位：m

%% 电机参数150kw（峰值功率）
Par_Motor_Static.w_EM_row=Motor_Model_struct.mc_map_spd;
Par_Motor_Static.T_EM_col_1=Motor_Model_struct.mc_map_trq_dr;
Par_Motor_Static.T_EM_col_2=Motor_Model_struct.mc_map_trq_br;
Par_Motor_Static.eta_EM_map_1=Motor_Model_struct.mc_eff_map(:,1:41);
Par_Motor_Static.eta_EM_map_2=Motor_Model_struct.mc_eff_map(:,42:end);
%% 蓄电池参数88Kwh（电量）
Par_Batt_Static.voc_map=Batt_Model_struct.ESS_VOC;                         % 电池包开路电压，单位：V
Par_Batt_Static.soc_map=Batt_Model_struct.ESS_SOC;                                   
Par_Batt_Static.R_D_SOC=Batt_Model_struct.ESS_R_D;                         % 电池包放电内阻，单位：欧
Par_Batt_Static.R_C_SOC=Batt_Model_struct.ESS_R_C;                         % 电池包充电内阻，单位：欧
Par_Batt_Static.Q_Ah=Batt_Model_struct.Q_Ah;                               % 电池包电容量，单位：安时
Par_Batt_Static.delta_h =0.2;                                              % 取样步长
Par_Batt_Static.EFF_CL=1;                                                  % 库伦效率