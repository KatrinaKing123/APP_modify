if Model=="fcev"
             FCS_name_valid = struct;
FCS_valid = {};
for i = 1: length(FCS)
    if  FCS{1, i}.P_bat_PFCE >= PFCE 
        FCS_valid{end+1} = FCS{1,i};
        FCS_Name_valid = FCS{1,i}.name;
        FCS_name_valid.(FCS_Name_valid)=FCS_Name_valid;
    end
end
end
