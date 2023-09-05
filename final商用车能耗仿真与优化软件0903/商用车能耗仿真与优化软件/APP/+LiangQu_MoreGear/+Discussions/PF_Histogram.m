function [PF_His_X, PF_His_Y] = PF_Histogram(Basic_DP_PF,PF_Min,PF_Max,PF_Grid)
%     PF_Min =  5000;
%     PF_Max = 45000;
%     PF_Grid = 2500;
    PF_Histogram_Grid = PF_Min : PF_Grid : PF_Max;
    PF_Histogram_Grid_Num = length(PF_Histogram_Grid);
    PF_His_Y = zeros(1,PF_Histogram_Grid_Num - 1);
    PF_His_X = zeros(1,PF_Histogram_Grid_Num - 1);
    for index = 1 : PF_Histogram_Grid_Num - 1
        PF_His_Init = PF_Histogram_Grid(index);
        PF_His_End = PF_Histogram_Grid(index + 1);
        PF_His_Y(index) = length(find((Basic_DP_PF >= PF_His_Init) & (Basic_DP_PF < PF_His_End)));
        PF_His_X(index) = (PF_His_Init + PF_His_End) / 2;
    end
end