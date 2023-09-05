%% 构建工况
clear;clc
load('./Factory/Condition/cycles_epa.mat');
load('./Factory/Condition/cycles_wltp.mat');

HWFET = HWFET.Data;       % √
WLTP = WLTP_class_3.Data; % √

% 平均速度计算
L_HWFET=0;
for i=2:length(HWFET)
    v_ave_1(i-1)=(HWFET(i)+HWFET(i-1))/2;
    L_HWFET=L_HWFET+v_ave_1(i-1)/3600;
end
V_ave_HWFET=L_HWFET*3600/length(v_ave_1);

% WLTC
L_WLTP=0;
for i=2:length(WLTP)
    v_ave_2(i-1)=(WLTP(i)+WLTP(i-1))/2;
    L_WLTP=L_WLTP+v_ave_2(i-1)/3600;
end
V_ave_WLTP=L_WLTP*3600/length(v_ave_2);


