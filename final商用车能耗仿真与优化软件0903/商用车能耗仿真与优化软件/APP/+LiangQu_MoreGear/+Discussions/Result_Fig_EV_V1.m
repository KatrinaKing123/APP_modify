% Example 1: Gear optimization for a smCDEV
% Function:   analysis and discussion of the results

%% Clear workspace
clear all
close all
clc

%% Load the result calcultaed by Basic DP
load('.\+ResultData\+EV_2S_IDSC\CYC_NEDC_Grid_SOC_51_none.mat')
IDSC_SOC         = res.X{1, 1};
IDSC_G             = res.X{1, 2};
IDSC_M            = res.M_K_1;
IDSC_Motor     = (IDSC_M == 2);
IDSC_W_Motor_K = res.W_Motor_K;
IDSC_T_Motor_K  = res.T_Motor;
IDSC_Time      = Time_S
IDSC_Fuel       = Fuel
IDSC_Grid_SOC = (grd.Xn{1}.hi - grd.Xn{1}.lo) / (grd.Nx{1}  - 1)

%% Load the result calcultaed by SJTU DP
load('.\+ResultData\+EV_3S_SJTU\CYC_NEDC_Grid_SOC_0.5.mat')
SJTU_SOC         = [OPT_Result.SOC_K(1),OPT_Result.SOC_K_1];
SJTU_G             = [OPT_Result.G_K(1),OPT_Result.G_K_1];
SJTU_M            = OPT_Result.M_K_1;
SJTU_Motor      = (SJTU_M == 2);
SJTU_W_Motor_K = OPT_Result.W_m_K_1;
SJTU_T_Motor_K  = OPT_Result.T_m_K_1;
SJTU_M_K_1 = OPT_Result.M_K_1;
SJTU_Time   = Time_S
SJTU_Fuel    = Fuel
SJTU_Grid_SOC = Grid_SOC

%% Rate
Energy_Diff = IDSC_Fuel - SJTU_Fuel 
Time_Diff    = IDSC_Time - SJTU_Time 
Time_Reduce_Rate = Time_Diff / IDSC_Time * 100


%% Figure ----------------------------------------------------------------------------------
FontSize = 14;
Figure1 = figure('Name', 'SOC Range', 'NumberTitle', 'off','Position',[300 200 900 300]);
%%  (1) Comparative analysis of SOC trajectories
axes('Position',[0.075 0.165 0.40 0.80]);
plot(SOC_UP_List, '-k', 'LineWidth', 2)
hold on
H2 = plot(IDSC_SOC,'-r','LineWidth',2);
hold on
H3 = plot(SJTU_SOC,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('SOC','FontSize',FontSize,'FontName','Times New Roman');
legend1 = legend([H2,H3],'Basic DP','SJTU DP');
set(legend1,'Location','SouthWest','FontSize',FontSize,...
    'FontName','Times New Roman');

%%  (2) Comparative analysis of gear operation.
axes('Position',[0.55 0.165 0.40 0.80]);
hold on
H2 = plot(IDSC_G,'-r','LineWidth',2);
H3 = plot(SJTU_G,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Gear','FontSize',FontSize,'FontName','Times New Roman');
axis([0 1200 1 5])
legend1 = legend([H2,H3],'Basic DP','SJTU DP');
set(legend1,'Location','SouthEast','FontSize',FontSize,...
    'FontName','Times New Roman');
set(gca,'YTick',1:5);
set(gca,'YTicklabel',{'1','2','3','4','5'})


