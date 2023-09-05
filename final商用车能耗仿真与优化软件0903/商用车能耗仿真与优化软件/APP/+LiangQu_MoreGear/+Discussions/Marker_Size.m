function MarkerSize = Marker_Size(OPT_W_M,OPT_T_M)
    Num = length(OPT_W_M);
    Data_Num = zeros(1,Num);
    for Index = 1:Num
        T_C = OPT_T_M(Index);
        W_C = OPT_W_M(Index);
        T_Index = find(OPT_T_M == T_C);
        W_Index = find(OPT_W_M == W_C);
        T_W_Index = intersect(T_Index, W_Index);
        Data_Num(Index) = length(T_W_Index);
    end
    Min_Size = 0;
    Max_Size = 300;
    K_Size = 3; % (Max_Size - Min_Size) / (max(Data_Num) - min(Data_Num));
    % MarkerSize = K_Size .* (Data_Num - min(Data_Num)) + Min_Size;
    MarkerSize = K_Size .* Data_Num + Min_Size;
%     unique(OPT_T_M)
%     unique(MarkerSize)
%     sum(unique(MarkerSize))
end