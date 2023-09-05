function [Symbol,  Path ]=  OS_Selection(OS_Flag)
    %% Windows System 
    if OS_Flag == 1
        Symbol = '\';
        disp('This is Wimdows System. Welcome to use NEVs-DP software...')
        disp('------------------------------------------------------------------------------------------------------')
        Path.In = '.\';
        Path.Out = '.\+ResultData';
    end
    
    %% Linux System
    if OS_Flag == 2
        Symbol = '/';
        disp('This is Linux System. Welcome to use NEVs-DP software...')
        disp('------------------------------------------------------------------------------------------------------')
        Path.In = '/home/zhouwei/Working/DP_HEV_FCEV/DP_Main';
        Path.Out = '/home/zhouwei/Working/DP_HEV_FCEV/DP_Main/+ResultData';
    end
    
end