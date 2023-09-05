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
%   [1] Research on modeling and solving of Dynamic Programming for New Energy Vehicles based on their work modes
%        Part I: Electric Vehicles (EVs) and Hybrid Electric Vehicles (HEVs)
%   [2] Research on modeling and solving of Dynamic Programming for New Energy Vehicles based on their work modes
%        Part II: Fuel Cell Electric Vehicles (FCEVs)
% 
%   FUNCTION
%   An example to show how to optimize gear operation for an EV with a gearbox
% 
%   This DP problem is solved by SJTU DP 
%

%% 
% clear all
% close all
clc

%%  Start the time
tic                                                     

%% Select the computer operating system       % 1---Windows System
% OS_Flag = 1;                                   
% [Symbol,  Path] =   OS_Selection(OS_Flag);          

% %% Driving cycle path
% Cycle_Name = 'WLTC';
% Cycle_Data_Path = strcat(Path.In ,Symbol,'+CycleData',Symbol,Cycle_Name,'.mat');
% Data_Path.Cycle_Data_Path = Cycle_Data_Path;

%% 赋值全局变量
global g
global GVW_n
global Cd
global A
global f
global delta
global Line
global Forward
global he
global r0
global i0
global nt

%% 保存数据
Fuel_each = zeros(1, length(Match_selected));
OPT_Result_select = {};
%% 筛选组合
for matchIndex = 1:length(Match_selected)

% 替换工况
%     Cycle_Name = 'WLTP';
%     load('CYC_WLTP.mat')
    
    % Cyc_Velocity =velocity(1 : length(velocity))/3.6; 
    %% Design vehicle dynamics model
    Index_Start = 1;   
    Index_End = 1800; 
    SOC_Init = 0.80;
    % EV = Example.EV_3S_SJTU.Cal_EV_Model(Data_Path,Index_Start, Index_End);
%     EV = Example.EV_3S_SJTU.Cal_EV_Model(velocity, Index_Start, Index_End, matchIndex, Match_selected);
    EV = NEVs_DP_DM.NEVs_DP_DM.Example.EV_3S_SJTU.Cal_EV_Model(velocity, Index_Start, Index_End, matchIndex, Match_selected);

    % %% Driving cycle path
    % % Cycle_Name = 'CYC_NEDC';
    % Cycle_Name = 'WLTC';
    % Cycle_Data_Path = strcat(Path.In ,Symbol,'+CycleData',Symbol,Cycle_Name,'.mat');
    % Data_Path.Cycle_Data_Path = Cycle_Data_Path;
    % 
    % %% Design vehicle dynamics model
    % Index_Start = 1;   
    % % Index_End = 1180; 
    % load('F:\搬砖\电动汽车能耗计算\DP_SJTU\NEVs-DP\NEVs-DP\+CycleData\WLTC.mat');
    % Index_End = length(velocity);
    % SOC_Init = 0.80;
    % EV = Example.EV_3S _SJTU.Cal_EV_Model(Data_Path,Index_Start, Index_End);
    %% SOC grid
    Grid_SOC = 0.00005; 
    
    %% Determination of Weight Coefficient 
    Cost.G    = 0;      
    Cost.M    = 0;     
    Cost.Fuel = 1;      
    Cost.SOC_End = 0;
    
    %% Mode definition
    Mode.Stop = 1;
    Mode.EV = 2;
    EV.Mode = Mode;
    
    %% Initial state
    Input_K = NEVs_DP_DM.NEVs-DP-DM.Example.EV_3S_SJTU.Init_Put_K_Struct();
    Input_K.SOC_K_1_Grid = SOC_Init;
    Input_K.J_K_1_Grid = 0;
    
    Input_K.G_K_1_Grid = 1;
    Input_K.M_K_1_Grid = Mode.Stop;
    Input_K.Fuel_K_1_Grid = 0;
    
    %% Control variables
    % EV.U_G = EV.GearBox.Index;
    % EV.Num_U_G_K = length(EV.U_G);
    EV.U_G = (0:0.1:1);
    EV.Num_U_G_K = length(EV.U_G);
    %% SOC Range: Initial
    SOC_UP_List = SOC_Init;
    SOC_Down_List = SOC_Init;

    %% DP forward calculation 
    for Step = 1: EV.Cycle_Num - 1
        clc
        str_dis = strcat('The computer is calculating,this is ',32,num2str(Step),'th step. Please wait........');
        disp(str_dis)
        disp('----------------------------------------------------------------------------------------------------------------------------------------')
        
        %% Calculate SOC range of the (K+1)th step
        SOC_K_Min = min(Input_K.SOC_K_1_Grid);
        SOC_K_Max = max(Input_K.SOC_K_1_Grid);
        SOC_K_1_Min = SOC_K_Min + EV.Batt.Deta_SOC_Min;
        SOC_K_1_Max = SOC_K_Max + EV.Batt.Deta_SOC_Max;
        SOC_UP_List(Step + 1) = SOC_K_1_Max;
        SOC_Down_List(Step + 1) = SOC_K_1_Min;
        Grid_Num = ceil((SOC_K_1_Max - SOC_K_1_Min) / Grid_SOC) + 1;
        SOC_K_1 = linspace(SOC_K_1_Min,SOC_K_1_Max,Grid_Num);
        
        %% Main 
        Out_Put_K= NEVs_DP_DM.NEVs-DP-DM.Example.EV_3S_SJTU.DP_Main_Function(EV,SOC_K_1,Input_K,Step);
        
        %% Data merge
        OutPut_K = NEVs_DP_DM.NEVs-DP-DM.Example.EV_3S_SJTU.CS_Data_Merge(Out_Put_K);
        
        %% Update 
        Input_K = OutPut_K;
        
        %% Data Save
        Data_Result{Step} = OutPut_K;
    end
    
    %% Backward calculation to obtain the optimal control decision sequence
    try 
        SOC_Up = EV.Batt.SOC_Max;
        SOC_Down = EV.Batt.SOC_Min;
        Cyc_Num = EV.Cycle_Num - 1;
        OPT_SOC_Index_List = find((Data_Result{1, Cyc_Num}.SOC_K_1_Grid < SOC_Up) & (Data_Result{1, Cyc_Num}.SOC_K_1_Grid) > SOC_Down);
        OPT_M_Index_List = find(Data_Result{1, Cyc_Num}.M_K_1_Grid == Mode.Stop);
        %倒推，选择最后一步SOC满足要求，且为停车模式的网格开始
        OPT_Index_List = intersect(OPT_SOC_Index_List,OPT_M_Index_List);
        J_K_1_Grid = Data_Result{1, Cyc_Num}.J_K_1_Grid(OPT_Index_List); 
        [Y,Index] = min(J_K_1_Grid);
        OPT_Index = OPT_Index_List(Index);
    
        % Data Save
    %     OPT_Result.T_m_K_1(Cyc_Num)   = Data_Result{1, Cyc_Num}.T_m_K_Grid(OPT_Index);
    %     OPT_Result.W_m_K_1(Cyc_Num)  = Data_Result{1, Cyc_Num}.W_m_K_Grid(OPT_Index);
        OPT_Result.T_m_Front_K_1(Cyc_Num)   = Data_Result{1, Cyc_Num}.T_m_Front_K_Grid(OPT_Index);
        OPT_Result.W_m_Front_K_1(Cyc_Num)  = Data_Result{1, Cyc_Num}.W_m_Front_K_Grid(OPT_Index);
        OPT_Result.T_m_Rear_K_1(Cyc_Num)   = Data_Result{1, Cyc_Num}.T_m_Rear_K_Grid(OPT_Index);
        OPT_Result.W_m_Rear_K_1(Cyc_Num)  = Data_Result{1, Cyc_Num}.W_m_Rear_K_Grid(OPT_Index);
        
        OPT_Result.SOC_K(Cyc_Num)      = Data_Result{1, Cyc_Num}.SOC_K_Grid(OPT_Index);
        OPT_Result.SOC_K_1(Cyc_Num)   = Data_Result{1, Cyc_Num}.SOC_K_1_Grid(OPT_Index);
        OPT_Result.G_K(Cyc_Num)          = Data_Result{1, Cyc_Num}.G_K_Grid(OPT_Index);
        OPT_Result.G_K_1(Cyc_Num)       = Data_Result{1, Cyc_Num}.G_K_1_Grid(OPT_Index);
        OPT_Result.Pb_K_1(Cyc_Num)     = Data_Result{1, Cyc_Num}.Pb_K_Grid(OPT_Index);
        OPT_Result.J_K_1(Cyc_Num)        = Data_Result{1, Cyc_Num}.J_K_1_Grid(OPT_Index);
        OPT_Result.M_K(Cyc_Num)         = Data_Result{1, Cyc_Num}.M_K_Grid(OPT_Index);
        OPT_Result.M_K_1(Cyc_Num)      = Data_Result{1, Cyc_Num}.M_K_1_Grid(OPT_Index);
        OPT_Result.Fuel_K_1(Cyc_Num)   = Data_Result{1, Cyc_Num}.Fuel_K_1_Grid(OPT_Index);
        for Index =  Cyc_Num - 1 : -1: 1
            %% Find the Optmial Index 
            M_K             = OPT_Result.M_K(Index + 1);
            SOC_K           = OPT_Result.SOC_K(Index + 1);
            G_K             = OPT_Result.G_K(Index + 1);
            OPT_Index_M     = find(Data_Result{1, Index}.M_K_1_Grid == M_K);
            OPT_Index_SOC   = find(Data_Result{1, Index}.SOC_K_1_Grid == SOC_K);
            OPT_Index_G     = find(Data_Result{1, Index}.G_K_1_Grid == G_K);
            OPT_Index_M_SOC = intersect(OPT_Index_M, OPT_Index_SOC);
            OPT_Index_G_SOC = intersect(OPT_Index_G, OPT_Index_SOC);
            OPT_Index_2     = intersect(OPT_Index_M_SOC, OPT_Index_G_SOC);
            OPT_Index       = OPT_Index_2(1);
            if ((length(OPT_Index_2) > 1) || (isempty(OPT_Index_2)))
                disp('There is a waring....')
                break
            end
            %% Data Save
    %         OPT_Result.T_m_K_1(Index)   = Data_Result{1, Index}.T_m_K_Grid(OPT_Index);
    %         OPT_Result.W_m_K_1(Index) = Data_Result{1, Index}.W_m_K_Grid(OPT_Index);
            OPT_Result.T_m_Front_K_1(Index)   = Data_Result{1, Index}.T_m_Front_K_Grid(OPT_Index);
            OPT_Result.W_m_Front_K_1(Index) = Data_Result{1, Index}.W_m_Front_K_Grid(OPT_Index);
            OPT_Result.T_m_Rear_K_1(Index)   = Data_Result{1, Index}.T_m_Rear_K_Grid(OPT_Index);
            OPT_Result.W_m_Rear_K_1(Index) = Data_Result{1, Index}.W_m_Rear_K_Grid(OPT_Index);
            
            OPT_Result.SOC_K(Index)     = Data_Result{1, Index}.SOC_K_Grid(OPT_Index);
            OPT_Result.SOC_K_1(Index)  = Data_Result{1, Index}.SOC_K_1_Grid(OPT_Index);
            OPT_Result.G_K(Index)         = Data_Result{1, Index}.G_K_Grid(OPT_Index);
            OPT_Result.G_K_1(Index)      = Data_Result{1, Index}.G_K_1_Grid(OPT_Index);
            OPT_Result.Pb_K_1(Index)    = Data_Result{1, Index}.Pb_K_Grid(OPT_Index);
            OPT_Result.J_K_1(Index)       = Data_Result{1, Index}.J_K_1_Grid(OPT_Index);
            OPT_Result.M_K(Index)        = Data_Result{1, Index}.M_K_Grid(OPT_Index);
            OPT_Result.M_K_1(Index)     = Data_Result{1, Index}.M_K_1_Grid(OPT_Index);
            OPT_Result.Fuel_K_1(Index)  = Data_Result{1, Index}.Fuel_K_1_Grid(OPT_Index);
        end
        
        %% Energy Consumption
        Total_Fuel = sum(OPT_Result.Fuel_K_1) ;                      
        Fuel = Total_Fuel / 3600 * 100 / (EV.Distance/1000);    % k·Wh·(100 km)^-1
    
    catch
        disp('There is a warning in  Backward Calculation of DP')
    end
    
    %%  Calculation time
    Time_S = toc;
    Fuel_each(matchIndex) = Fuel;
    OPT_Result_select{end+1} = OPT_Result;
end

% %% Save data
% Str_Grid_Deta_SOC = num2str(1e4 .* Grid_SOC ) ;
% Path_Name            = strcat(Path.Out, Symbol, '+EV_3S_SJTU', Symbol,Cycle_Name,'_','Grid_SOC_',Str_Grid_Deta_SOC,'_1.mat');
% save(Path_Name,'-v7.3')




