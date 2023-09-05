%% 构建工况
clear;clc
% load('F:\项目-doing\电动汽车能耗计算\软件开发\项目内容\part4控制策略\NEVs-DP_TJY\cycledata\cycles_artemis.mat');
% load('F:\项目-doing\电动汽车能耗计算\软件开发\项目内容\part4控制策略\NEVs-DP_TJY\cycledata\cycles_epa.mat');
% load('F:\项目-doing\电动汽车能耗计算\软件开发\项目内容\part4控制策略\NEVs-DP_TJY\cycledata\cycles_nedc.mat');
load('F:\项目-doing\电动汽车能耗计算\软件开发\项目内容\part4控制策略\NEVs-DP_TJY\cycledata\cycles_wltp.mat');

% ArtMw130 = ArtMw130.Data;
% ArtMw150 = ArtMw150.Data;
% ArtRoad = ArtRoad.Data;
% ArtUrban = ArtUrban.Data; % √
% % ECE_R15 = ECE_R15.Data;
% % EUDC = EUDC.Data;
% FTP = FTP.Data;           % √
% HWFET = HWFET.Data;       % √
% NEDC = NEDC.Data;
% UDDS = UDDS.Data;
WLTP = WLTP_class_3.Data; % √

% 拼接
% velocity = [WLTP; ArtUrban; HWFET; FTP];  
velocity = WLTP;
% 保存
save('F:\项目-doing\电动汽车能耗计算\软件开发\项目内容\part3匹配设计\参数匹配软件设计\3月24日代码更新\App完整版\App\NEVs-DP_TJY\+CycleData\CYC_WLTP.mat', "velocity");
