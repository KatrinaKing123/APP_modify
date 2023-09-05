% Example 2: Gear optimization and torque distribution optimization between the motor and ICE for a P2
% Function:   analysis and discussion of the results

%% Clear workspace
clear all
close all
clc

%% Load basic parameters
VehParameters.PHEV_Par; 
Mode.Stop = 1;
Mode.EV = 2;
Mode.ICE = 3;
Mode.Hybrid = 4;
Mode.Park_Charge = 5;

%% Load the result calcultaed by Level-Set DP
load('.\+ResultData\+PHEV_3S_2U_IDSC\CYC_NEDC_Grid_SOC_41_T_21_SOC_End_0.0016_LevelSet.mat')
IDSC_SOC         = res.X{1, 1};
IDSC_G             = res.X{1, 2};
IDSC_M            = res.X{1, 3};
IDSC_ICE          = (IDSC_M == 3) | (IDSC_M == 4);
IDSC_Motor     = (IDSC_M == 2) | (IDSC_M == 4);
IDSC_W_ICE_K  = res.W_ICE_K;
IDSC_T_ICE_K   = res.T_ICE_K;
IDSC_W_Motor_K = res.W_Motor_K;
IDSC_T_Motor_K  = res.T_Motor;
IDSC_M_K_1  = res.M_K_1;
IDSC_Time     = Time_S
IDSC_Fuel      = Fuel
IDSC_SOC_End_Deta = SOC_End_Deta
IDSC_D_SOC     = abs(SOC_Init - IDSC_SOC(end))
IDSC_Grid_SOC = (grd.Xn{1}.hi - grd.Xn{1}.lo) / (grd.Nx{1} - 1)
IDSC_Grid_T      = (grd.Un{1}.hi - grd.Un{1}.lo) / (grd.Nu{1} - 1)

%% Load the result calcultaed by SJTU-2U DP
load('.\+ResultData\+PHEV_3S_2U_SJTU\CYC_NEDC_Grid_SOC_4_T_Num_41.mat')
SJTU_2U_SOC  = [OPT_Result.SOC_K(1),OPT_Result.SOC_K_1];
SJTU_2U_G      = [OPT_Result.G_K(1),OPT_Result.G_K_1];
SJTU_2U_M     = [OPT_Result.M_K(1),OPT_Result.M_K_1];
SJTU_2U_ICE   = (SJTU_2U_M == 3) | (SJTU_2U_M == 4);
SJTU_2U_Motor  = (SJTU_2U_M == 2) | (SJTU_2U_M == 4);
SJTU_2U_W_ICE_K  = OPT_Result.W_ICE_K_1;
SJTU_2U_T_ICE_K   = OPT_Result.T_ICE_K_1;
SJTU_2U_W_Motor_K = OPT_Result.W_m_K_1;
SJTU_2U_T_Motor_K  = OPT_Result.T_m_K_1;
SJTU_2U_M_K_1  = OPT_Result.M_K_1;
SJTU_2U_Time    = Time_S
SJTU_2U_Fuel     = Fuel
SJTU_2U_SOC_End_Deta = SOC_End_Deta
SJTU_2U_D_SOC     = abs(Deta_SOC_End)
IDSC_2U_Grid_SOC =Grid_SOC
IDSC_2U_Grid_T      = 2/ (Num_U_Tm_Ratio - 1)

%% Load the result calcultaed by SJTU-6U DP
load('.\+ResultData\+PHEV_3S_6U_SJTU\CYC_NEDC_Grid_SOC_4_Grid_T_1.5.mat')
SJTU_6U_SOC     = [OPT_Result.SOC_K(1),OPT_Result.SOC_K_1];
SJTU_6U_G         = [OPT_Result.G_K(1),OPT_Result.G_K_1];
SJTU_6U_M        = [OPT_Result.M_K(1),OPT_Result.M_K_1];
SJTU_6U_ICE      = (SJTU_6U_M == 3) | (SJTU_6U_M == 4)| (SJTU_6U_M == 5);
SJTU_6U_Motor    = (SJTU_6U_M == 2) | (SJTU_6U_M == 4)| (SJTU_6U_M == 5);
SJTU_6U_W_ICE_K = OPT_Result.W_ICE_K_1;
SJTU_6U_T_ICE_K  = OPT_Result.T_ICE_K_1;
SJTU_6U_W_Motor_K = OPT_Result.W_m_K_1;
SJTU_6U_T_Motor_K  = OPT_Result.T_m_K_1;
SJTU_6U_M_K_1  = OPT_Result.M_K_1;
SJTU_6U_Time    = Time_S
SJTU_6U_Fuel     = Fuel
SJTU_6U_SOC_End_Deta = SOC_End_Deta
SJTU_6U_D_SOC      = abs(Deta_SOC_End)
IDSC_6U_Grid_SOC  = Grid_SOC
IDSC_6U_Grid_T       = Deta_M_T_K

%% Rate
Time_Reduce_Rate_SJTU_2U = (IDSC_Time - SJTU_2U_Time) / IDSC_Time * 100
Time_Reduce_Rate_SJTU_6U = (IDSC_Time - SJTU_6U_Time) / IDSC_Time * 100
Energy_Reduce_Rate_SJTU_2U = (IDSC_Fuel - SJTU_2U_Fuel) / IDSC_Fuel * 100
Energy_Reduce_Rate_SJTU_6U = (IDSC_Fuel - SJTU_6U_Fuel) / IDSC_Fuel * 100

%% Shift Frequency
Fre_IDSC_G = sum(abs(diff(IDSC_G)))
Fre_SJTU_2U_G = sum(abs(diff(SJTU_2U_G)))
Fre_SJTU_6U_G = sum(abs(diff(SJTU_6U_G)))

%% ICE On/OFF
Fre_IDSC_ICE = sum(abs(diff(IDSC_ICE))) / 2
Fre_SJTU_2U_ICE = sum(abs(diff(SJTU_2U_ICE))) / 2
Fre_SJTU_6U_ICE = sum(abs(diff(SJTU_6U_ICE))) / 2

%%  Figure 1 ============================================================================
figure('Name', 'Figure 1', 'NumberTitle', 'off','Position',[300 10 800 1200]);
FontSize = 14;
X_1_Init = 0.075;
X_2_Init = 0.57;
X_With = 0.40;
Y_Hight = 0.175;
Y_1_2_Init = 0.80;
Y_3_4_Init = 0.555;
Y_5_6_Init = 0.305;
Y_7_8_Init = 0.05;

%% (1) Comparison of SOC trajectories
axes('Position',[X_1_Init Y_1_2_Init X_With Y_Hight]);
plot(PHEV.Result.SOC_Limt_Up, '-k', 'LineWidth', 2)
hold on
plot(PHEV.Result.SOC_Limt_Down, '-k' ,'LineWidth', 2)
x1 = linspace(1, PHEV.Cycle_Num, PHEV.Cycle_Num);
x2 = linspace(PHEV.Cycle_Num, 1, PHEV.Cycle_Num);
X = [x1,x2];
Y = [PHEV.Result.SOC_Limt_Up, fliplr(PHEV.Result.SOC_Limt_Down)];
fill(X,Y,[1 1 0.800000011920929]);
X_Init = 1;
Y_Init = PHEV.SOC_Init;
X_End = PHEV.Cycle_Num;
Y_End = PHEV.SOC_End;
SOC_L_X = [X_Init, X_End];
SOC_L_Y = [Y_Init, Y_End];
plot(SOC_L_X, SOC_L_Y,'--g','LineWidth',1)
H2 = plot(IDSC_SOC,'-r','LineWidth',2);
H3 = plot(SJTU_2U_SOC,'-b','LineWidth',2);
H4 = plot(SJTU_6U_SOC,'-c','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('SOC','FontSize',FontSize,'FontName','Times New Roman');
Leg_Hand = legend([H2,H3,H4],'Level-Set DP','SJTU-2U DP','SJTU-6U DP');
set(Leg_Hand,'Location','NorthEast','FontSize',0.9 * FontSize,...
    'FontName','Times New Roman');
set(gca,'YTick',0.55:0.02:0.65);
set(gca,'YTicklabel',{'0.55','0.57','0.59','0.61','0.63','0.65'})

%% (2) Comparison of gear position
axes('Position',[X_2_Init Y_1_2_Init X_With Y_Hight]);
hold on
H1 = plot(IDSC_G,'-r','LineWidth',2);
H2 = plot(SJTU_2U_G,'-b','LineWidth',2);
H3 = plot(SJTU_6U_G,'-c','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Gear','FontSize',FontSize,'FontName','Times New Roman');

%% (3) Operation points of the ICE calculated by Level-Set DP
axes('Position',[X_1_Init Y_3_4_Init X_With Y_Hight]);
plot(IDSC_T_ICE_K,'-r','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('ICE Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');

%% (4) Operation points of the motor calculated by Level-Set DP
axes('Position',[X_2_Init Y_3_4_Init X_With Y_Hight]);
plot(IDSC_T_Motor_K,'-r','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Motor Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');

%% (5) Operation points of the ICE calculated by SJTU-2U DP
axes('Position',[X_1_Init Y_5_6_Init X_With Y_Hight]);
plot(SJTU_2U_T_ICE_K,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('ICE Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');

%% (6) Operation points of the motor calculated by SJTU-2U DP
axes('Position',[X_2_Init Y_5_6_Init X_With Y_Hight]);
plot(SJTU_2U_T_Motor_K,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Motor Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');

%% (7) Operation points of the ICE calculated by SJTU-6U DP
 axes('Position',[X_1_Init Y_7_8_Init X_With Y_Hight]);
plot(SJTU_6U_T_ICE_K,'-c','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('ICE Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');

%% (8) Operation points of the motor calculated by SJTU-6U DP
axes('Position',[X_2_Init Y_7_8_Init X_With Y_Hight]);
plot(SJTU_6U_T_Motor_K,'-c','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Motor Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');

%%  Figure 2 ============================================================================
figure('Name', 'Figure 2', 'NumberTitle', 'off','Position',[300 100 900 900]);
FontSize = 14;
X_1_Init = 0.075;
X_2_Init = 0.58;
X_With = 0.40;
Y_Hight = 0.24;
Y_1_2_Init = 0.73;
Y_3_4_Init = 0.405;
Y_5_6_Init = 0.075;

%%  (1) The distribution of operation points of the ICE calculated by Level-Set DP
axes1 = axes('Position',[X_1_Init Y_1_2_Init X_With Y_Hight]);
[X,Y] = meshgrid(Par_ICE.Speed / (2*pi/60), Par_ICE.T_Col);
[~,H] = contour(X,Y, Par_ICE.Eff_Map',0.10:0.025:0.35,'LineWidth',2); % ,'TextList',TextList);
hold on 
plot(Par_ICE.Speed / (2*pi/60),Par_ICE.Trq_Max,'-*k','LineWidth',2)
set(H,'ShowText','on','TextList',0.10:0.025:0.35)
grid on
hold on
Motor_Work_Index = find((IDSC_M_K_1 == Mode.ICE) |(IDSC_M_K_1 == Mode.Hybrid)|(IDSC_M_K_1 == Mode.Park_Charge));
OPT_W = IDSC_W_ICE_K(Motor_Work_Index);
OPT_T = IDSC_T_ICE_K(Motor_Work_Index);
MarkerSize = Discussions.Marker_Size(OPT_W,OPT_T);
scatter(OPT_W/(2*pi/60),OPT_T,MarkerSize,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1]);
c = colorbar('peer',axes1);
c.Label.FontSize = FontSize;
c.Label.FontName = 'Times New Roman';
c.Label.String = 'Efficiency';
colormap(jet)
xlabel('ICE Speed (Rpm)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');
axis([min(Par_ICE.Speed / (2*pi/60)) 6000 0 80])
colorbar('off')

%% (3) The distribution of operation points of the ICE calculated by SJTU-2U DP
axes1 = axes('Position',[X_1_Init Y_3_4_Init X_With Y_Hight]);
[X,Y] = meshgrid(Par_ICE.Speed / (2*pi/60), Par_ICE.T_Col);
[~,H] = contour(X,Y, Par_ICE.Eff_Map',0.10:0.025:0.35,'LineWidth',2); % ,'TextList',TextList);
hold on 
plot(Par_ICE.Speed / (2*pi/60),Par_ICE.Trq_Max,'-*k','LineWidth',2)
set(H,'ShowText','on','TextList',0.10:0.025:0.35)
grid on
hold on
Motor_Work_Index = find((SJTU_2U_M_K_1 == Mode.ICE) |(SJTU_2U_M_K_1 == Mode.Hybrid|(SJTU_2U_M_K_1 == Mode.Park_Charge)));
OPT_W = SJTU_2U_W_ICE_K(Motor_Work_Index);
OPT_T = SJTU_2U_T_ICE_K(Motor_Work_Index);
MarkerSize = Discussions.Marker_Size(OPT_W,OPT_T);
scatter(OPT_W/(2*pi/60),OPT_T,MarkerSize,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1]);
c = colorbar('peer',axes1);
c.Label.FontSize = FontSize;
c.Label.FontName = 'Times New Roman';
c.Label.String = 'Efficiency';
colormap(jet)
xlabel('ICE Speed (Rpm)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');
axis([min(Par_ICE.Speed / (2*pi/60)) 6000 0 80])
colorbar('off')

%% (5) The distribution of operation points of the ICE calculated by SJTU-6U DP
axes1 = axes('Position',[X_1_Init Y_5_6_Init X_With Y_Hight]);
[X,Y] = meshgrid(Par_ICE.Speed / (2*pi/60), Par_ICE.T_Col);
[~,H] = contour(X,Y, Par_ICE.Eff_Map',0.10:0.025:0.35,'LineWidth',2); % ,'TextList',TextList);
hold on 
plot(Par_ICE.Speed / (2*pi/60),Par_ICE.Trq_Max,'-*k','LineWidth',2)
set(H,'ShowText','on','TextList',0.10:0.025:0.35)
grid on
hold on
Motor_Work_Index = find((SJTU_6U_M_K_1 == Mode.ICE) |(SJTU_6U_M_K_1 == Mode.Hybrid) |(SJTU_6U_M_K_1 == Mode.Park_Charge));
OPT_W = SJTU_6U_W_ICE_K(Motor_Work_Index);
OPT_T = SJTU_6U_T_ICE_K(Motor_Work_Index);
MarkerSize = Discussions.Marker_Size(OPT_W,OPT_T);
scatter(OPT_W/(2*pi/60),OPT_T,MarkerSize,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1]);
c = colorbar('peer',axes1);
c.Label.FontSize = FontSize;
c.Label.FontName = 'Times New Roman';
c.Label.String = 'Efficiency';
colormap(jet)
xlabel('ICE Speed (Rpm)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');
axis([min(Par_ICE.Speed / (2*pi/60)) 6000 0 80])
colorbar('off')

%% (2) The distribution of operation points of the motor calculated by Level-Set DP
axes1 = axes('Position',[X_2_Init Y_1_2_Init X_With Y_Hight]);
[X,Y] = meshgrid(Par_Motor.Speed / (2*pi/60), Par_Motor.T_Col);
[~,H] = contour(X, Y, Par_Motor.Eff_map',0.5:0.025:0.95,'LineWidth',2); 
set(H,'ShowText','on','TextList',0.5:0.05:0.9)
grid on
hold on
plot(Par_Motor.Speed / (2*pi/60),Par_Motor.Trq_Max,'--k','LineWidth',2.5)
plot(Par_Motor.Speed / (2*pi/60),Par_Motor.Trq_Min,'--k','LineWidth',2.5)
Motor_Work_Index = find((IDSC_M_K_1 == Mode.EV) |(IDSC_M_K_1 == Mode.Hybrid));
OPT_W_M = IDSC_W_Motor_K(Motor_Work_Index);
OPT_T_M = IDSC_T_Motor_K(Motor_Work_Index);
MarkerSize = Discussions.Marker_Size(OPT_W_M,OPT_T_M);
scatter(OPT_W_M/(2*pi/60),OPT_T_M,MarkerSize,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1]);
c = colorbar('peer',axes1);
c.Label.FontSize = FontSize;
c.Label.FontName = 'Times New Roman';
c.Label.String = 'Efficiency';
colormap(jet)
xlabel('Motor Speed (Rpm)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');
axis([0 8000 -100 100])
colorbar('off')

%% (4)  The distribution of operation points of the motor calculated by SJTU-2U DP
axes1 = axes('Position',[X_2_Init Y_3_4_Init X_With Y_Hight]);
[X,Y] = meshgrid(Par_Motor.Speed / (2*pi/60), Par_Motor.T_Col);
[~,H] = contour(X, Y, Par_Motor.Eff_map',0.5:0.025:0.95,'LineWidth',2); 
set(H,'ShowText','on','TextList',0.5:0.05:0.9)
grid on
hold on
plot(Par_Motor.Speed / (2*pi/60),Par_Motor.Trq_Max,'--k','LineWidth',2.5)
plot(Par_Motor.Speed / (2*pi/60),Par_Motor.Trq_Min,'--k','LineWidth',2.5)
Motor_Work_Index = find((SJTU_2U_M_K_1 == Mode.EV) |(SJTU_2U_M_K_1 == Mode.Hybrid)|(SJTU_2U_M_K_1 == Mode.Park_Charge));
OPT_W_M = SJTU_2U_W_Motor_K(Motor_Work_Index);
OPT_T_M = SJTU_2U_T_Motor_K(Motor_Work_Index);
MarkerSize = Discussions.Marker_Size(OPT_W_M,OPT_T_M);
scatter(OPT_W_M/(2*pi/60),OPT_T_M,MarkerSize,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1]);
c = colorbar('peer',axes1);
c.Label.FontSize = FontSize;
c.Label.FontName = 'Times New Roman';
c.Label.String = 'Efficiency';
colormap(jet)
xlabel('Motor Speed (Rpm)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');
axis([0 8000 -100 100])
colorbar('off')

%% (6) The distribution of operation points of the motor calculated by SJTU-6U DP
axes1 = axes('Position',[X_2_Init Y_5_6_Init X_With Y_Hight]);
[X,Y] = meshgrid(Par_Motor.Speed / (2*pi/60), Par_Motor.T_Col);
[CS,H] = contour(X, Y, Par_Motor.Eff_map',0.5:0.025:0.95,'LineWidth',2); 
set(H,'ShowText','on','TextList',0.5:0.05:0.9)
grid on
hold on
plot(Par_Motor.Speed / (2*pi/60),Par_Motor.Trq_Max,'--k','LineWidth',2.5)
plot(Par_Motor.Speed / (2*pi/60),Par_Motor.Trq_Min,'--k','LineWidth',2.5)
Motor_Work_Index = find((SJTU_6U_M_K_1 == Mode.EV) |(SJTU_6U_M_K_1 == Mode.Hybrid)|(SJTU_6U_M_K_1 == Mode.Park_Charge));
OPT_W_M = SJTU_6U_W_Motor_K(Motor_Work_Index);
OPT_T_M = SJTU_6U_T_Motor_K(Motor_Work_Index);
MarkerSize = Discussions.Marker_Size(OPT_W_M,OPT_T_M);
scatter(OPT_W_M/(2*pi/60),OPT_T_M,MarkerSize,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1]);
c = colorbar('peer',axes1);
c.Label.FontSize = FontSize;
c.Label.FontName = 'Times New Roman';
c.Label.String = 'Efficiency';
colormap(jet)
xlabel('Motor Speed (Rpm)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Torque (N\cdotm)','FontSize',FontSize,'FontName','Times New Roman');
axis([0 8000 -100 100])
colorbar('off')

