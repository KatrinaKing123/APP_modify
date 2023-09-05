%% 筛选电池
if Model=="ev"
Batt_name_valid = struct;
Batt_valid = {};
for i = 1: length(Batt)
    if Batt{1, i}.E >= Wtotal & Batt{1, i}.P_bat_max >= Pimax
        Batt_valid{end+1} = Batt{1,i};
        Batt_Name_valid = Batt{1,i}.name;
        Batt_name_valid.(Batt_Name_valid)=Batt_Name_valid;
    end
end
elseif Model=="double_ev"
        Batt_name_valid = struct;
Batt_valid = {};
for i = 1: length(Batt)
    if Batt{1, i}.E >= Wtotal & Batt{1, i}.P_bat_max >= Pimax
        Batt_valid{end+1} = Batt{1,i};
        Batt_Name_valid = Batt{1,i}.name;
        Batt_name_valid.(Batt_Name_valid)=Batt_Name_valid;
    end
end

elseif Model=="fcev"
             Batt_name_valid = struct;
Batt_valid = {};
for i = 1: length(Batt)
    if  Batt{1, i}.P_bat_max >= Pbat 
        Batt_valid{end+1} = Batt{1,i};
        Batt_Name_valid = Batt{1,i}.name;
        Batt_name_valid.(Batt_Name_valid)=Batt_Name_valid;
    end
end
end



% Motor_name.('Motor_PE_50')='Motor_PE_50';
