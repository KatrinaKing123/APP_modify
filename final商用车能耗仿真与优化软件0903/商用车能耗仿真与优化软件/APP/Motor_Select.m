%% 单电机筛选电机
if Model=="ev"
    Motor_name_valid = struct;
    Motor_valid = {};
    for i = 1: length(Motor)
        if (Motor{1, i}.mc_max_P >= Pmax) && (Motor{1, i}.mc_PE >= Pe) && (Motor{1, i}.mc_max_trq_dr_value>Tmax)
            Motor_valid{end+1} = Motor{1,i};
            Motor_Name_valid = Motor{1,i}.name;
            Motor_name_valid.(Motor_Name_valid)=Motor_Name_valid;
        end
    end

% Motor_name.('Motor_PE_50')='Motor_PE_50';

%% 双电机筛选电机
elseif Model=="double_ev"
    Motor_Front_Rear_valid=struct;
    Motor_Combine_name_valid=struct;
%     Motor_combine_valid={};
    Motor_valid={};

    for i=1:length(Motor_Front)
        for j=1:length(Motor_Rear)
            if(Motor_Front{1,i}.mc_max_P+Motor_Rear{1,j}.mc_max_P>=P_max)&&(Motor_Front{1,i}.mc_max_trq_dr_value+Motor_Rear{1,j}.mc_max_trq_dr_value>=T_max)
                Motor_Combine_name=[Motor_Front{1,i}.name,'______',Motor_Rear{1,j}.name];
                Motor_Combine_name_valid.(Motor_Combine_name)=Motor_Combine_name;
                Motor_Front_Rear_valid.name=Motor_Combine_name;
                Motor_Front_Rear_valid.Motor_Front=Motor_Front{1,i};
                Motor_Front_Rear_valid.Motor_Rear=Motor_Rear{1,j};
%                 Motor_combine_valid{end+1}=Motor_Front_Rear_valid;
                Motor_valid{end+1}=Motor_Front_Rear_valid;

            end
        end
    end

%% 燃料电池筛选电机
elseif Model=="fcev"
    Motor_name_valid = struct;
    Motor_valid = {};
    for i = 1: length(Motor)
        if (Motor{1, i}.mc_max_P >= Pmax) && (Motor{1, i}.mc_PE >= Pe) && (Motor{1, i}.mc_max_trq_dr_value>= Tmax)
            Motor_valid{end+1} = Motor{1,i};
            Motor_Name_valid = Motor{1,i}.name;
            Motor_name_valid.(Motor_Name_valid)=Motor_Name_valid;
        end
    end
end

if isempty(Motor_valid) 
    no_valid = 1;
else
    no_valid = 0;
end



