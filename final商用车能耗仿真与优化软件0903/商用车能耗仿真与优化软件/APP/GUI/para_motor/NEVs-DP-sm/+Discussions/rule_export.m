% savePath = 'C:\Users\YourUsername\Documents\';  % 替换为您想要保存的文件路径
% filename = 'data.xlsx';
% xlswrite(fullfile(savePath, filename), data, 'Sheet1');

filename = 'rule_data.xlsx';
a=size(lambda_save);
rowLabels=cell(1,1);colLabels=cell(1,1);

for p = 1:precision_1
    data_down=delta_v*(p-1)+v_min;
    data_up=data_down+delta_v;
    data_down=round(data_down * 100) / 100;
    data_up=round(data_up * 100) / 100;
    textData = strcat(num2str(data_down),32,'≤ V ≤',32,num2str(data_up));
    rowLabels=[rowLabels,textData];

    if p<=precision_1/2
        data_down=delta_a_N*(p-1)+a_min;
        data_up=data_down+delta_a_N;
    else
        data_down=delta_a_P*(p-1-precision_1/2);
        data_up=data_down+delta_a_P;
    end
    data_down=round(data_down * 100) / 100;
    data_up=round(data_up * 100) / 100;
    textData = strcat(num2str(data_down),32,'≤ acc ≤',32,num2str(data_up));
    colLabels=[colLabels,textData];
end
rowLabels(:,1)=[];
colLabels{1,1}='Rule_extract';
for p = 1:a(3)
    slice = lambda_save(:, :, p);
    fullData = [colLabels; [rowLabels', num2cell(slice)]];

    data_down=delta_SOC*(p-1)+SOC_min;
    data_up=data_down+delta_SOC;
    data_down=round(data_down * 100) / 100;
    data_up=round(data_up * 100) / 100;
    textData = strcat(num2str(data_down),32,'≤ SOC ≤',32,num2str(data_up));

    sheetname = textData;
%     range = 'B2';
%     xlswrite(filename, fullData, sheetname,range);
    writecell(fullData, filename, 'Sheet', sheetname);

end

