%% 双电机DP结果保存
Match_select_DP_Rank = {};
for i=1:length(Match_selected)
    Match_select_DP_rank=struct;
    Match_select_DP_rank.Motor_Front=Match_selected{1,i}.Motor_Front_Par.name;
    Match_select_DP_rank.Motor_Rear=Match_selected{1,i}.Motor_Rear_Par.name;
    Match_select_DP_rank.type_batt=Match_selected{1,i}.type_Batt;
    Match_select_DP_rank.vmax=Match_selected{1,i}.vmax;
    Match_select_DP_rank.tm=Match_selected{1,i}.tm;
    Match_select_DP_rank.grade=Match_selected{1,i}.grade;
    Match_select_DP_rank.mile=Match_selected{1,i}.mile;
    Match_select_DP_rank.rank=Match_selected{1,i}.rank;
    Match_select_DP_rank.fuel = Fuel_each(i);
    Match_select_DP_Rank{end+1}=Match_select_DP_rank;
end
Match_select_DP_rank_table = struct2table(cell2mat(Match_select_DP_Rank)); 
targetfolder = fullfile(fileparts(pwd), '+AppResult/Match_select_DP_rank.csv') ;
writetable(Match_select_DP_rank_table,targetfolder);

num_picture = length(Match_selected);

