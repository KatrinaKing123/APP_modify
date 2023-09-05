function ObjVal = Object_Motor(Motor_Parameters,Motor_Update)
%% Basic Parameters
ObjVal = zeros(length(Motor_Parameters),1);
Power_E = Motor_Update.Power_Drv_Brk_E(:);

%% 
for row_index = 1:length(Motor_Parameters)
    toc
    % ≥ı ºªØ
    a = Motor_Parameters(row_index,1);
    b = Motor_Parameters(row_index,2);
    c = Motor_Parameters(row_index,3);
    Power_M = Motor_Update.Power_Drv_Brk_M(1);
    sim_result = a * Power_M^2 + b * Power_M + c;
    for power_index = 2:length(Motor_Update.Power_Drv_Brk_M)
        Power_M = Motor_Update.Power_Drv_Brk_M(power_index);
        sim_result(power_index) = a * Power_M^2 + b * Power_M + c;
    end
    ObjVal(row_index) = sqrt(sum((sim_result' - Power_E).^2) / length(Power_E));
end


