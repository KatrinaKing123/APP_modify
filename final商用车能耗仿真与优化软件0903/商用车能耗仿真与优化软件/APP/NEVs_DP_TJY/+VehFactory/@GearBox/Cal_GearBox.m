function Cal_GearBox(obj,Final,T_G)
%%  Parameters
Ratio = obj.Ratio;
Eff = obj.Eff;

%% Traction Force 
Tf = Final.Tf;
Wf = Final.Wf;

%% Calculation of Traction Force  
Current_I_Ration = Ratio(T_G);
obj.Tg = (Tf > 0) .* (Tf ./ Current_I_Ration) ./ Eff + (Tf < 0) .* (Tf ./ Current_I_Ration) .* Eff;
obj.Wg = Wf .* Current_I_Ration;
end

