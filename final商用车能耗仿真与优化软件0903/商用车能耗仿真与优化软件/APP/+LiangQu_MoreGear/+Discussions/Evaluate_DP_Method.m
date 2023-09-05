function DP_Level = Evaluate_DP_Method(Example_Time,Example_Energy,W_T,W_E,Index_List,Level_List)
    Example_Index = W_T .* (Example_Time - min(Example_Time)) ./ max(Example_Time) .* 100 + ....
                                W_E .* (Example_Energy - min(Example_Energy)) ./ max(Example_Energy) .* 100;
    for i = 1 : length(Example_Index)         
        Index_Temp = Example_Index(i);
        for j = 1 : length(Index_List) - 1
            down = Index_List(j);
            up = Index_List(j + 1);
            if (Index_Temp < up) && (Index_Temp >= down)
                DP_Level{1,i} = Level_List{1,j};
            end
        end
    end
end