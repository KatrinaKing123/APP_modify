%% 权重选择、归一化与计算
num=length(Dynamic_Match);
%% 预分配内存
vmax_raw=zeros(1,num);
tm_raw=zeros(1,num);
grade_raw=zeros(1,num);
mile_raw=zeros(1,num);
Dynamic_Cal_normalization=cell(2,num);
%% 评价指标归一化
for i=1:num
    vmax_raw(i)=Dynamic_Match{i}.vmax;
    tm_raw(i)=Dynamic_Match{i}.tm;
    grade_raw(i)=Dynamic_Match{i}.grade;
    mile_raw(i)=Dynamic_Match{i}.mile;
end

vmax_normalization=sqrt(sum(vmax_raw.^2));
tm_normalization=sqrt(sum(tm_raw.^2));
grade_normalization=sqrt(sum(grade_raw.^2));
mile_normalization=sqrt(sum(mile_raw.^2));


for i=1:num
    Dynamic_Cal_normalization{1,i}={vmax_raw(i)/vmax_normalization,tm_raw(i)/tm_normalization,grade_raw(i)/grade_normalization,mile_raw(i)/mile_normalization};
end

%% 权重计算排名
global w_vmax;
global w_grade;
global w_t_0_100;
global w_mile;

for i=1:num
    Dynamic_Cal_normalization{2,i}=w_vmax*cell2mat(Dynamic_Cal_normalization{1,i}(1))+w_t_0_100*cell2mat(Dynamic_Cal_normalization{1,i}(2))+w_grade*cell2mat(Dynamic_Cal_normalization{1,i}(3))+w_mile*cell2mat(Dynamic_Cal_normalization{1,i}(4));
    % Dynamic_Match{1,i}.weightvalue=Dynamic_Cal_normalization{2,i};
end
Dynamic_Match_rank={};
[ranking_value,ranking_index]=sort([Dynamic_Cal_normalization{2,:}],'descend');
index=1;
for i=1:num
    Dynamic_Match_rank{end+1}=Dynamic_Match{1,ranking_index(i)};
    Dynamic_Match_rank{i}.rank=index;
    index=index+1;
end

%% 单电机结果保存
if Model=="ev"
    Dynamic_Rank=cell2mat(Dynamic_Match_rank);
    fields={'MotorPar','BattPar'};
    Dynamic_Rank2=rmfield(Dynamic_Rank,fields);
    % save(strcat('./+AppResult/Dynamic_Rank.mat'),'Dynamic_Rank2');
    Dynamic_Rank_table=struct2table(Dynamic_Rank2);
    writetable(Dynamic_Rank_table,'./+AppResult/Dynamic_Rank.csv');
%% 双电机结果保存
elseif Model=="double_ev"
    Double_Dynamic_Match_Rank={};
    for i=1:length(Dynamic_Match_rank)
        Double_Dynamic_Match=struct;
        Double_Dynamic_Match.Motor_Front=Dynamic_Match_rank{1,i}.Motor_Front_Par.name;
        Double_Dynamic_Match.Motor_Rear=Dynamic_Match_rank{1,i}.Motor_Rear_Par.name;
        Double_Dynamic_Match.type_batt=Dynamic_Match_rank{1,i}.type_Batt;
        Double_Dynamic_Match.vmax=Dynamic_Match_rank{1,i}.vmax;
        Double_Dynamic_Match.tm=Dynamic_Match_rank{1,i}.tm;
        Double_Dynamic_Match.grade=Dynamic_Match_rank{1,i}.grade;
        Double_Dynamic_Match.mile=Dynamic_Match_rank{1,i}.mile;
        Double_Dynamic_Match.rank=Dynamic_Match_rank{1,i}.rank;
        Double_Dynamic_Match_Rank{end+1}=Double_Dynamic_Match;
    end
    Double_Dynamic_Rank=cell2mat(Double_Dynamic_Match_Rank);
    Double_Dynamic_Rank_table=struct2table(Double_Dynamic_Rank);
    writetable(Double_Dynamic_Rank_table,'./+AppResult/Double_Dynamic_Rank.csv');
%% 燃料电池结果保存
elseif Model=="fcev"
    fcev_Dynamic_Rank=cell2mat(Dynamic_Match_rank);
    fields={'MotorPar','BattPar','FCSPar'};
    fcev_Dynamic_Rank2=rmfield(fcev_Dynamic_Rank,fields);
    % save(strcat('./+AppResult/Dynamic_Rank.mat'),'Dynamic_Rank2');
    fcev_Dynamic_Rank_table=struct2table(fcev_Dynamic_Rank2);
    writetable(fcev_Dynamic_Rank_table,'./+AppResult/fcev_Dynamic_Rank.csv');
end



% % 画图
% x_axis_dy = 1 : 1 : num;
% y_axis_vmax = [];
% y_axis_tm = [];
% y_axis_grade = [];
% y_axis_mile = [];
% for y_axis = 1 : num
%     y_axis_vmax(y_axis) = Double_Dynamic_Match_Rank{1,y_axis}.vmax;
%     str_vmax = [num2str(y_axis_vmax')];
% 
%     y_axis_tm(y_axis) = Double_Dynamic_Match_Rank{1, y_axis}.tm;
%     str_tm = [num2str(y_axis_tm')];
% 
%     y_axis_grade(y_axis) = Double_Dynamic_Match_Rank{1, y_axis}.grade;
%     str_grade = [num2str(y_axis_grade')];
% 
%     y_axis_mile(y_axis) = Double_Dynamic_Match_Rank{1, y_axis}.mile;
%    
%     
% end
% x_axis_mile_plot = x_axis_dy([1:2:num]);
% y_axis_mile_plot = y_axis_mile([1:2:num]);
% str_mile = [num2str(y_axis_mile_plot')];
