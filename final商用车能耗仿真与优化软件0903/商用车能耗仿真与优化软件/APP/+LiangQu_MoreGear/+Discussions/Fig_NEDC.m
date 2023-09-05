clear all
close all
clc

%% Plot NEDC Driving Cycle
load('.\+CycleData\CYC_NEDC.mat')
figure('Name', 'SOC Range', 'NumberTitle', 'off','Position',[300 200 600 300]);
axes('Position',[0.10 0.15 0.8 0.8]);
plot(velocity, '-k', 'LineWidth', 2)
grid on
xlabel('Time (s)','FontSize',12,'FontName','Times New Roman');
ylabel('Velocity (km\cdoth^-^1)','FontSize',12,'FontName','Times New Roman');
