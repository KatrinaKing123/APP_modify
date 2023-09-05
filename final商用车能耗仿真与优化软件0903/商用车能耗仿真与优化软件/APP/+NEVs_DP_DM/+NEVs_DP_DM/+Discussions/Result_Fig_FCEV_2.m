% Example 4: Power distribution optimization between FCS and battery for a FCEV that FCS is allowed to close during driving
% Function:   analysis and discussion of the results

%% Clear workspace
clear all
close all
clc

%% Load the result calcultaed by Level-Set DP
load('.\+ResultData\+FCEV_3S_IDSC\CYC_NEDC_Grid_SOC_71_PF_45_LevelSet.mat')
Level_DP_SOC = res.X{1, 1};
Level_DP_PF  = res.X{1, 2};
Level_DP_Time_S = Time_S
Level_DP_Fuel = Fuel
Level_DP_PF_Work = Level_DP_PF(Level_DP_PF > 0);
Level_DP_D_SOC      = abs(SOC_Init - Level_DP_SOC(end))
Level_DP_Grid_SOC  = (grd.Xn{1}.hi - grd.Xn{1}.lo) / (grd.Nx{1} - 1)
Level_DP_Grid_PF_S  = (grd.Xn{2}.hi - grd.Xn{2}.lo) / (grd.Nx{2} - 1)
Level_DP_Grid_PF_U = (grd.Un{1}.hi - grd.Un{1}.lo) / (grd.Nu{1} - 1)

%% Load the result calcultaed by SJTU DP
load('.\+ResultData\+FCEV_3S_SJTU\CYC_NEDC_Grid_SOC_0.8_End_0.8.mat')
SJTU_SOC= [OPT_Result.SOC_K(1),OPT_Result.SOC_K_1];
SJTU_PF= [OPT_Result.PF_K(1),OPT_Result.PF_K_1];
SJTU_DP_Time_S = Time_S
SJTU_DP_Fuel = Fuel
SJTU_PF_Work = SJTU_PF(SJTU_PF > 0);
SJTU_DP_D_SOC      = abs(SOC_Init - SJTU_SOC(end))
SJTU_DP_Grid_SOC  = Grid.Deta_SOC

%% Load Vehicle Parameters
VehParameters.FCEV_Par;
PF_List = Par_FCS.FCS_P_Min:100:Par_FCS.FCS_P_Max;
H2_List = Par_FCS.FCS_H2_P1 .* PF_List .* PF_List +  Par_FCS.FCS_H2_P2 .* PF_List +  Par_FCS.FCS_H2_P3;
P_List = Par_FCS.G2J .* H2_List;
FCS_Eff = PF_List ./ P_List;

%% Rate
Energy_Reduce_Rate = (Level_DP_Fuel - SJTU_DP_Fuel) / Level_DP_Fuel * 100
Time_Reduce_RateP = (Level_DP_Time_S - SJTU_DP_Time_S) / Level_DP_Time_S * 100

%%  Figure  ============================================================================
Figure_1 = figure('Name', 'SOC Range', 'NumberTitle', 'off','Position',[300 200 1000 700]);
FontSize = 14;

%% (1) Comparison of SOC trajectories calculated by the two different methods
axes('Position',[0.075 0.60 0.38 0.38]);
plot(FCEV.Result.SOC_Limt_Up, '-k', 'LineWidth', 2)
hold on
plot(FCEV.Result.SOC_Limt_Down, '-k' ,'LineWidth', 2)
x1 = linspace(1, FCEV.Cycle_Num, FCEV.Cycle_Num);
x2 = linspace(FCEV.Cycle_Num, 1, FCEV.Cycle_Num);
X = [x1,x2];
Y = [FCEV.Result.SOC_Limt_Up, fliplr(FCEV.Result.SOC_Limt_Down)];
H0 = fill(X,Y,[1 1 0.800000011920929]);
X_Init = 1;
Y_Init = FCEV.SOC_Init;
X_End = FCEV.Cycle_Num;
Y_End = FCEV.SOC_End;
SOC_L_X = [X_Init, X_End];
SOC_L_Y = [Y_Init, Y_End];
plot(SOC_L_X, SOC_L_Y,'--g','LineWidth',1)
H2 = plot(Level_DP_SOC,'-m','LineWidth',2);
H3 = plot(SJTU_SOC,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('SOC','FontSize',FontSize,'FontName','Times New Roman');
legend1 = legend([H2,H3],'Level-Set DP','SJTU DP');
set(legend1,'Location','northwest','FontSize',FontSize,...
    'FontName','Times New Roman');
axis([0 1200 0.54 0.66])

%% (2) Comparison of FCS power calculated by the two different methods
axes('Position',[0.555 0.60 0.38 0.38]);
hold on
H2 = plot(Level_DP_PF / 1000,'-m','LineWidth',2);
H3 = plot(SJTU_PF / 1000,'-b','LineWidth',2);
grid on
xlabel('Time (s)','FontSize',FontSize,'FontName','Times New Roman');
ylabel('FCS Power (kW)','FontSize',FontSize,'FontName','Times New Roman');
axis([0 1200 0 40])
legend2 = legend([H2,H3],'Level-Set DP','SJTU DP');
set(legend2,'Location','northwest','FontSize',FontSize,...
    'FontName','Times New Roman');

%%  (3) Statistical distribution of FCS working points calculated by Level-set DP
h_ap = axes('Position',[0.075 0.125 0.36 0.35]);
PF_Min =  0;
PF_Max = 45000;
PF_Grid = 1000;
FCS_P_Max = 30;
PCE_Eff_Max = 0.6;
FCS_P_Counter_Max = 250;
Bar_Width = 1;
nx = 6;
ny = 5; 
pxtick=0:((FCS_P_Max-0)/nx):FCS_P_Max;
pytick=0:((FCS_P_Counter_Max-0)/ny):FCS_P_Counter_Max; 
[PF_His_X, PF_His_Y] = Discussions.PF_Histogram(Level_DP_PF_Work,PF_Min,PF_Max,PF_Grid);
bar(PF_His_X / 1000,PF_His_Y,Bar_Width, 'Parent', h_ap) 
set(h_ap,'Xtick',pxtick,'Ytick',pytick,'Xgrid','on','Ygrid','on')
set(get(h_ap,'Xlabel'),'String',' FCS Power (kW)','FontSize',FontSize,'FontName','Times New Roman');
set(get(h_ap,'Ylabel'),'String','Counts','FontSize',FontSize,'FontName','Times New Roman');
set(h_ap,'Xcolor','k','Ycolor','k','Xlim',[0,FCS_P_Max],'Ylim',[0,FCS_P_Counter_Max]);
hold on 
h_at=axes('Position',get(h_ap,'Position')); 
set(h_at,'Color','none','Xcolor','k','Ycolor','r'); 
set(h_at,'Yaxislocation','right')
set(h_at,'Ylim',[0,PCE_Eff_Max]) 
line(PF_List / 1000,FCS_Eff,'Color','r','LineWidth',2,'Parent',h_at) %<19>
pytick = 0:0.1:PCE_Eff_Max;
set(h_at,'Ytick',pytick,'Xgrid','on','Ygrid','on')
set(h_at,'Xcolor','k','Ycolor','k','Xlim',[0,FCS_P_Max],'Ylim',[0.1,PCE_Eff_Max]);
set(get(h_at,'Ylabel'),'String','Efficiency ','Color','k','FontSize',FontSize,'FontName','Times New Roman');
set(h_at,'xtick',[])
grid off

%% (4) Statistical distribution of FCS working points calculated by SJTU DP
h_ap = axes('Position',[0.555 0.125 0.36 0.35]);
pxtick=0:((FCS_P_Max-0)/nx):FCS_P_Max;
pytick=0:((FCS_P_Counter_Max-0)/ny):FCS_P_Counter_Max; 
[PF_His_X, PF_His_Y] = Discussions.PF_Histogram(SJTU_PF_Work,PF_Min,PF_Max,PF_Grid);
bar(PF_His_X / 1000,PF_His_Y,Bar_Width, 'Parent', h_ap) 
set(h_ap,'Xtick',pxtick,'Ytick',pytick,'Xgrid','on','Ygrid','on')
set(get(h_ap,'Xlabel'),'String',' FCS Power (kW)','FontSize',FontSize,'FontName','Times New Roman');
set(get(h_ap,'Ylabel'),'String','Counts','FontSize',FontSize,'FontName','Times New Roman');
set(h_ap,'Xcolor','k','Ycolor','k','Xlim',[0,FCS_P_Max],'Ylim',[0,FCS_P_Counter_Max]);
hold on 
h_at=axes('Position',get(h_ap,'Position')); 
set(h_at,'Color','none','Xcolor','k','Ycolor','r'); 
set(h_at,'Yaxislocation','right')
set(h_at,'Ylim',[0,PCE_Eff_Max]) 
line(PF_List / 1000,FCS_Eff,'Color','r','LineWidth',2,'Parent',h_at) %<19>
pytick = 0:0.1:PCE_Eff_Max;
set(h_at,'Ytick',pytick,'Xgrid','on','Ygrid','on')
set(h_at,'Xcolor','k','Ycolor','k','Xlim',[0,FCS_P_Max],'Ylim',[0.1,PCE_Eff_Max]);
set(get(h_at,'Ylabel'),'String','Efficiency ','Color','k','FontSize',FontSize,'FontName','Times New Roman');
set(h_at,'xtick',[])
grid off



