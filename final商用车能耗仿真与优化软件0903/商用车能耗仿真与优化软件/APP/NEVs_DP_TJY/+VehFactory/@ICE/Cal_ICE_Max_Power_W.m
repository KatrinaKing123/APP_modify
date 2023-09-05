function [T_ICE, W_ICE_M,Index] = Cal_ICE_Max_Power_W(obj,Input_K)
    Speed = obj.Speed;
    Trq_Max = obj.Trq_Max;
    W_ICE = Input_K.W_ICE;

    %% Calculation
    T_ICE_Max = interp1(Speed, Trq_Max, W_ICE, 'linear');
    [ICE_Max_Power,Index]= max(T_ICE_Max.*W_ICE);
    if ~isnan(ICE_Max_Power)
        W_ICE_M = W_ICE(Index);
        T_ICE = T_ICE_Max(Index);
    else
        W_ICE_M = 0;
        T_ICE = 0;
    end
end

