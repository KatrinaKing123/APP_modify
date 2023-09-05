function Cal_Final(obj,Wheel)
%% Final Parameters
Ratio = obj.Ratio;
Eff = obj.Eff;

%% Traction Force 
Tw = Wheel.Tw;
Ww = Wheel.Ww;

%% Calculation of Traction Force  
obj.Tf = (Tw > 0) * (Tw / Ratio) / Eff + (Tw < 0) * (Tw / Ratio) * Eff;
obj.Wf = Ww * Ratio;
end

