clear all
close all
clc

%% Weight Coefficients
W_T = 0.15;
W_E = 1 - W_T;
Index_List = [0,5,10,15,20,Inf];
Level_List =  {'A','B','C','D','E'};

%% Example 1: EV   
Example_1_Time = [350.3607, 12.3218];
Example_1_Energy = [15.5787, 15.5787];
% Basic DP    SJTU DP
Example_1_Level = Discussions.Evaluate_DP_Method(Example_1_Time,Example_1_Energy,W_T,W_E,Index_List,Level_List)

%% Example 2: P2 
Example_2_Time = [693.1682, 151.6749];
Example_2_Energy = [6.7723, 5.0656];
% Level-Set DP    SJTU DP
Example_2_Level = Discussions.Evaluate_DP_Method(Example_2_Time,Example_2_Energy,W_T,W_E,Index_List,Level_List)

%% Example 3: FCEV-1
Example_3_Time = [28.7839, 48.1126, 22.3491];
Example_3_Energy = [1040.96, 1065.60, 1026.19];
% Basic DP  Level-Set DP  SJTU DP
Example_3_Level = Discussions.Evaluate_DP_Method(Example_3_Time,Example_3_Energy,W_T,W_E,Index_List,Level_List)

%% Example 4: FCEV-2   
Example_4_Time = [2900.30, 165.41];
Example_4_Energy = [1008.69, 1006.55];
% Level-Set DP    SJTU DP
Example_4_Level = Discussions.Evaluate_DP_Method(Example_4_Time,Example_4_Energy,W_T,W_E,Index_List,Level_List)