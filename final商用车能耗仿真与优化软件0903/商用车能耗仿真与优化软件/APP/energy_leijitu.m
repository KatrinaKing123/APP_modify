%% 绘制能耗累计图
%% 画图
x = {};
y = {};
for i = 1 : num_picture
    x{i} = linspace(1, length(OPT_Result_select{1, i}.J_K_1), length(OPT_Result_select{1, i}.J_K_1));
    y{i} = OPT_Result_select{1, i}.J_K_1 * 1000 * 0.000000277778;
    figure()
    
    plot(x{i}, y{i});
    xlabel("时间/s")
    ylabel("电耗/kwh")
    title(['选择的第 ', num2str(i), '个组合']);
end