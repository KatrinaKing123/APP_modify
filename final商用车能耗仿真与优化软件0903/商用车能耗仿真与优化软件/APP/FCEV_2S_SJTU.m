%   LICENSE
%   This Source Code Form is subject to the terms of the Mozilla Public   License, v. 2.0.
%   If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
%   COPYRIGHT
%   Copyright 2018- School of Mechanical Engineering, Shanghai Jiao tong University, Shanghai, PR China 
%   Author: Wei Zhou, Lin Yang, Yishan Cai, Tianxing Ying
%
%   REFERENCES
%   If you use this software, please cite:
%   [1] Dynamic Programming for New Energy Vehicles based on their work modes
%        Part I: Electric Vehicles and Hybrid Electric Vehicles
%   [2] Dynamic Programming for New Energy Vehicles based on their work modes
%        Part II: Fuel Cell Electric Vehicles
% 
%   FUNCTION
%   An example to show how to to optimize energy distribution between FCS and battery for a FCEV that FCS
%   is not allowed to close during driving
% 
%   This DP problem is solved by SJTU DP.

%% 
% clear all
% close all
% clc

%%  Start the time
tic                                                     

%% Determinr the computer Operating System
OS_Flag = 1;                                      % 1: Windows;  2:Linux; 3:SJTU-HPC
[Symbol,  Path] =   OS_Selection(OS_Flag);                                             

%% Driving cycle path
% Cycle_Name = 'NEDC';

% % 周维工况
% % Cycle_Name = 'CYC_NEDC';
% % Cycle_Data_Path = strcat(Path.In ,Symbol,'+CycleData',Symbol,Cycle_Name,'.mat');
% load('F:\项目-doing\电动汽车能耗计算\软件开发\项目内容\part4控制策略\NEVs-DP_TJY\+CycleData\CYC_NEDC.mat');

% 替换工况
Cycle_Name = 'WLTP';
load('CYC_WLTP.mat')

Cyc_Velocity =velocity(1 : length(velocity))/3.6; 

%% Design Vehicle Dynamics Model and Calculate SOC Range 
SOC_Init = 0.60;
SOC_End_Deta = 0.000095;  
FCEV = Example.FCEV_2S_SJTU.Cal_SOC_Range(Cyc_Velocity,SOC_Init, SOC_End_Deta);

%% Grid 
% (1) SOC Grid
Grid.Deta_SOC = SOC_End_Deta;
Grid.SOC_Min_List = FCEV.Result.SOC_Limt_Down;
Grid.SOC_Max_List = FCEV.Result.SOC_Limt_Up;
Grid.Deta_SOC_Max = FCEV.Batt.Deta_SOC_Max;
Grid.Deta_SOC_Min = FCEV.Batt.Deta_SOC_Min;
%(2) PF Grid
Grid.Deta_PF = 500;
Grid.PF_Min = FCEV.FCS.FCS_P_Idle;
Grid.PF_Max = FCEV.FCS.FCS_P_Max;

%% Control Variable
Control.U_K = linspace(Grid.PF_Min,Grid.PF_Max, ceil((Grid.PF_Max - Grid.PF_Min)/Grid.Deta_PF));
Control.Num = ceil((Grid.PF_Max - Grid.PF_Min)/Grid.Deta_PF);
Grid.PF = Control.U_K;
Grid.PF_Num = Control.Num;

%% Initial state
Input_K.SOC_K_1_Grid = FCEV.SOC_Init;
Input_K.PF_K_1_Grid = FCEV.FCS.FCS_P_Idle;
Input_K.J_K_1_Grid = 0;

%% DP forward calculation 
for Step = 1 : FCEV.Cycle_Num - 1
    clc
    str_dis = strcat('The computer is calculating,this is ',32,num2str(Step),'th step. Please wait........');
    disp(str_dis)
    disp('----------------------------------------------------------------------------------------------------------------------------------------')
    
    %% Main 
    P_Demand = FCEV.Result.P_Demand(Step);
    OutPut_K = Example.FCEV_2S_SJTU.Cal_FCEV(P_Demand,Input_K,Grid,FCEV,Step);
    
    %% Update
    Out_Put_K   = Example.FCEV_2S_SJTU.SOC_Filter(OutPut_K,Grid,Step);
    Input_K = Out_Put_K;
    %% Data Save
    Data_Result{Step} = Out_Put_K;
    % break
end

%% Backward calculation to obtain the optimal control decision sequence
DP_Eed_Index = FCEV.Cycle_Num - 1;
SOC_End = SOC_Init;
SOC_Up = SOC_End + SOC_End_Deta / 2;          
SOC_Down = SOC_End -SOC_End_Deta / 2;
OPT_SOC_Index = find((Data_Result{1, DP_Eed_Index}.SOC_K_1_Grid <= SOC_Up) & (Data_Result{1, DP_Eed_Index}.SOC_K_1_Grid) >= SOC_Down);
OPT_J_List = Data_Result{1, DP_Eed_Index}.J_K_1_Grid(OPT_SOC_Index);
[Y,Index] = min(OPT_J_List);
OPT_Index = OPT_SOC_Index(Index);

% Data Save
OPT_Result.SOC_K(DP_Eed_Index) = Data_Result{1, DP_Eed_Index}.SOC_K_Grid(OPT_Index);
OPT_Result.PF_K(DP_Eed_Index) = Data_Result{1, DP_Eed_Index}.PF_K_Grid(OPT_Index);
OPT_Result.J_K(DP_Eed_Index) = Data_Result{1, DP_Eed_Index}.J_K_Grid(OPT_Index);
OPT_Result.SOC_K_1(DP_Eed_Index) = Data_Result{1, DP_Eed_Index}.SOC_K_1_Grid(OPT_Index);
OPT_Result.PF_K_1(DP_Eed_Index) = Data_Result{1, DP_Eed_Index}.PF_K_1_Grid(OPT_Index);
OPT_Result.J_K_1(DP_Eed_Index) = Data_Result{1, DP_Eed_Index}.J_K_1_Grid(OPT_Index);
for Index =  DP_Eed_Index - 1 : -1: 1
    %% Find the Optmial Index 
    SOC_K = OPT_Result.SOC_K(Index + 1);
    PF_K = OPT_Result.PF_K(Index + 1);
    J_K = OPT_Result.J_K(Index + 1);
    OPT_Index_SOC = find(Data_Result{1, Index}.SOC_K_1_Grid == SOC_K);
    OPT_Index_PF = find(Data_Result{1, Index}.PF_K_1_Grid == PF_K);
    OPT_Index_J = find(Data_Result{1, Index}.J_K_1_Grid == J_K);
    OPT_Index_SOC_PF = intersect(OPT_Index_SOC, OPT_Index_PF);
    OPT_Index_Temp = intersect(OPT_Index_SOC_PF, OPT_Index_J);
	if ((length(OPT_Index_Temp) > 1) || (isempty(OPT_Index_Temp)))
        disp('There is a waring....')
    end
    OPT_Index = OPT_Index_Temp(1);
    %% Data Save
    OPT_Result.SOC_K(Index) = Data_Result{1, Index}.SOC_K_Grid(OPT_Index);
    OPT_Result.PF_K(Index) = Data_Result{1, Index}.PF_K_Grid(OPT_Index);
    OPT_Result.J_K(Index) = Data_Result{1, Index}.J_K_Grid(OPT_Index);
    OPT_Result.SOC_K_1(Index) = Data_Result{1, Index}.SOC_K_1_Grid(OPT_Index);
    OPT_Result.PF_K_1(Index) = Data_Result{1, Index}.PF_K_1_Grid(OPT_Index);
    OPT_Result.J_K_1(Index) = Data_Result{1, Index}.J_K_1_Grid(OPT_Index); 
end

%% Energy Consumption
Total_Fuel = OPT_Result.J_K_1(end);
Fuel = Total_Fuel * 100 / (FCEV.Distance/1000)
Diff_SOC = SOC_End -  OPT_Result.SOC_K_1(end)

%% Time Consumption
Time_S = toc

% %% Data Save
% Str_SOC_End_Deta = num2str(Grid.Deta_PF) ;
% Str_Grid_Deta_SOC = num2str(1e4 .* Grid.Deta_SOC ) ;
% Path_Name = strcat(Path.Out, Symbol, '+FCEV_2S_SJTU', Symbol,Cycle_Name,'_','Grid_SOC_',Str_Grid_Deta_SOC,'_Grid_PF_',Str_SOC_End_Deta,'_1.mat');
% save(Path_Name,'-v7.3')
% 
% save("Result_PINJIE_driving_condition.mat", 'Fuel', 'OPT_Result', 'Diff_SOC',"Time_S", 'FCEV')
