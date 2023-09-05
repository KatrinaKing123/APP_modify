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

%% Rate
Energy_Diff = IDSC_Fuel - SJTU_Fuel 
Time_Diff    = IDSC_Time - SJTU_Time 
Time_Reduce_Rate = Time_Diff / IDSC_Time * 100
%% Figure

X_1_Init = 0.075;
X_2_Init = 0.58;
X_With = 0.40;
Y_Hight = 0.375;
Y_1_2_Init = 0.60;
Y_3_4_Init = 0.1;


%% Figure ----------------------------------------------------------------------------------
FontSize = 14;
Figure1 = figure('Name', 'SOC Range', 'NumberTitle', 'off','Position',[300 200 900 600]);
%%  1
axes('Position',[X_1_Init Y_1_2_Init X_With Y_Hight]);
H2 = plot(IDSC_SOC,'-r','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('SOC','FontSize',FontSize,'FontName','Times New Roman');
legend1 = legend([H2],'Basic DP');
set(legend1,'Location','SouthWest','FontSize',0.9 * FontSize,...
    'FontName','Times New Roman');

%% 2
axes('Position',[X_2_Init Y_1_2_Init X_With Y_Hight]);
H2 = plot(IDSC_G,'-r','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Gear','FontSize',FontSize,'FontName','Times New Roman');
axis([0 1200 1 5])
legend1 = legend([H2],'Basic DP');
set(legend1,'Location','SouthEast','FontSize',0.9*FontSize,...
                           'FontName','Times New Roman');
set(gca,'YTick',1:5);
set(gca,'YTicklabel',{'1','2','3','4','5'})

%% 3
axes('Position',[X_1_Init Y_3_4_Init X_With Y_Hight]);
H3 = plot(SJTU_SOC,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('SOC','FontSize',FontSize,'FontName','Times New Roman');
legend1 = legend([H3],'SJTU DP');
set(legend1,'Location','SouthWest','FontSize',0.9*FontSize,...
                           'FontName','Times New Roman');
                       
%% 4
axes('Position',[X_2_Init Y_3_4_Init X_With Y_Hight]);
H3 = plot(SJTU_G,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('Gear','FontSize',FontSize,'FontName','Times New Roman');
axis([0 1200 1 5])
set(gca,'YTick',1:5);
set(gca,'YTicklabel',{'1','2','3','4','5'})
legend1 = legend([H3],'SJTU DP');
set(legend1,'Location','SouthEast','FontSize',0.9*FontSize,...
                           'FontName','Times New Roman');

