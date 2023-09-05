%% 杂项功能
% 模式功能
% 1:单电机文件读取；
% 2:电池文件读取；
% 3:单电机动力性组合选取；
% 4:动力性组合经济性结果table数据读取；
% 5:数据保存；
% 6:fc文件批量读取；
% 7、8:双电机文件批量读取；

%% 电机文件批量读取
if Factory_flag==1
    Motor_num=length(Motor_path);
    for i=1:Motor_num
        run(Motor_path(i));
    end
end

%% 电池文件批量读取
if Factory_flag==2
    Batt_num=length(Batt_path);
    for i=1:Batt_num
        run(Batt_path(i));
    end
end

%% 动力性组合选取
if Factory_flag==3
    rank2Eco_double={};
    for i=1:length(rank2Eco)
        if rank2Eco(i)==','
        else
            rank2Eco_double{end+1}=rank2Eco(i);
        end
    end
    
    % 使用strsplit函数将字符串按逗号拆分成一个字符串数组

    strArray = strsplit(string(rank2Eco), ',');
    
    % 去除字符串数组中的空格
    strArray = strtrim(strArray);
    
    % 使用str2double函数将字符串数组中的元素转换为数字数组
    Rank2Eco_double = str2double(strArray);
end

%% table数据读取
if Factory_flag==4
    Com_Match_Result=cell2mat(Com_Match_Result);
    fields={'MotorPar','BattPar','rank','Energycumu'};
    Com_Match_Result_2=rmfield(Com_Match_Result,fields);
    Com_Result_table=struct2table(Com_Match_Result_2);
    writetable(Com_Result_table,'./+AppResult/Com_Match_Result.csv');
end

%% 数据保存
if Factory_flag==5
    writetable(Com_Result_table,save_path);
end

%% fcs文件批量读取
if Factory_flag==6
    FCS_num=length(FCS_path);
    for i=1:FCS_num
        run(FCS_path(i));
    end
end

%% 前电机文件批量读取
if Factory_flag==7
    if isa(Front_Motor_path,'char')==1
        Motor_Front={};
        Front_Motor_name=struct;
        run(Front_Motor_path);
        Motor_Front=Motor;
        Front_Motor_name=Motor_name;
    else
        Front_Motor_num=length(Front_Motor_path);
        Motor_Front={};
        Front_Motor_name=struct;
        for i=1:Front_Motor_num
            run(Front_Motor_path(i));
            Motor_Front{end+1}=Motor{1,i};
            Front_Motor_name=Motor_name;
        end
    end
    clearvars Motor Motor_name;
end
%% 后电机文件批量读取
if Factory_flag==8
    if isa(Rear_Motor_path,'char')==1
        Motor_Rear={};
        Rear_Motor_name=struct;
        run(Rear_Motor_path);
        Motor_Rear=Motor;
        Rear_Motor_name=Motor_name;
    else
        Rear_Motor_num=length(Rear_Motor_path);
        Motor_Rear={};
        for i=1:Rear_Motor_num
            run(Rear_Motor_path(i));
            Motor_Rear{end+1}=Motor{1,i};
            Rear_Motor_name=Motor_name;
        end
    end
    clearvars Motor Motor_name;
end

%% 双电机带能耗的结果保存（Double_Para_matching_Final/mlapp）
if Factory_flag == 9
    rank_select_DM = str2num(rank2Eco_double{1,1});
    Double_dy_eco_select_result = Double_Dynamic_Match_Rank{1, rank_select_DM};
    Double_dy_eco_select_result.energy = Fuel;
%     fields_DM_Eco_dy_result={'Motor_Front','Motor_Rear','type_batt','vmax','tm','grade','mile','rank','energy'};
%     Com_Match_Result_2_DM=rmfield(Double_dy_eco_select_result,fields_DM_Eco_dy_result);
    Com_Result_table_DM=struct2table(Double_dy_eco_select_result);
    writetable(Com_Result_table_DM,save_path);
end

%% 两驱策略求解，上传电机（只允许上传一款）
if Factory_flag==10
    Motor = {};
    run(Motor_path);
end

%% 两驱策略求解，上传电池（只允许上传一款）
if Factory_flag==11
    Batt = {};
    run(Batt_path);
end

%% 两驱策略求解，上传变速箱（只允许上传一款）
if Factory_flag==12
    Gear = {};
    run(Gear_path);
end

%% 四驱策略求解，上传前电机（只允许上传一款）
if Factory_flag==13
    Motor_front = {};
    run(Front_Motor_path);
end

%% 四驱策略求解，上传后电机（只允许上传一款）
if Factory_flag==14
    Motor_rear = {};
    run(Rear_Motor_path);
end

%% 四驱策略求解，上传电池（只允许上传一款）
if Factory_flag==15
    Batt = {};
    run(battery_path);
end