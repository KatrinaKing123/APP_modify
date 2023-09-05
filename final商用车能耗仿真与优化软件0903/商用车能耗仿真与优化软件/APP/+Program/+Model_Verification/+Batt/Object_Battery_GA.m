function [ObjVal,sim_result] = Object_Battery_GA(Batt_Parameters,Batt_Par,Batt_Update)
%% Basic Parameters
ObjVal = zeros(length(Batt_Parameters),1);
Batt_Pars = Batt_Par;
SOC_real = Batt_Update.SOC;
I = Batt_Update.I;
U = Batt_Update.U;

%% 
for row_index = 1:length(Batt_Parameters)
    toc
    % 初始化
    a1 = Batt_Parameters(row_index,1);b1 = Batt_Parameters(row_index,2);c1 = Batt_Parameters(row_index,3);d1 = Batt_Parameters(row_index,4);
    a2 = Batt_Parameters(row_index,5);b2 = Batt_Parameters(row_index,6);c2 = Batt_Parameters(row_index,7);d2 = Batt_Parameters(row_index,8);
    a3 = Batt_Parameters(row_index,9);b3 = Batt_Parameters(row_index,10);c3 = Batt_Parameters(row_index,11);d3 = Batt_Parameters(row_index,12);
    Batt_Pars.Q_Ah = Batt_Parameters(row_index,13);
    Batt_Pars.ess_voc = a1 * SOC_real(1)^3 + b1 * SOC_real(1)^2 +c1 * SOC_real(1) + d1;
    Batt_Pars.ess_r_dis = a2 * SOC_real(1)^3 + b2 * SOC_real(1)^2 +c2 * SOC_real(1) + d2;
    Batt_Pars.ess_r_chg = a3 * SOC_real(1)^3 + b3 * SOC_real(1)^2 +c3 * SOC_real(1) + d3;
    if Batt_Pars.ess_r_chg < 0 || Batt_Pars.ess_r_dis < 0 
        ObjVal_R = 50000;   
    else
        ObjVal_R = 0;
    end
    
    Batt_Pars.Soc_Pre = SOC_real(1);   % 0.4
    Batt_Pars.P_BT = Batt_Update.Power(1) * 1000;     % Unit:w
    Battery_Par = Program.Model_Verification.Batt.Cal_Battery_GA(Batt_Pars);
    sim_result.I = Battery_Par.I;
    sim_result.U = Battery_Par.U;
    sim_result.SOC = Battery_Par.Soc_Current;
    for power_index = 2:length(Batt_Update.Power)
        Batt_Pars.P_BT = Batt_Update.Power(power_index) * 1000;     % Unit:w
        Batt_Pars.Soc_Pre = Battery_Par.Soc_Current;
        Batt_Pars.ess_voc = a1 * Battery_Par.Soc_Current^3 + b1 * Battery_Par.Soc_Current^2 +c1 * Battery_Par.Soc_Current + d1;
        Batt_Pars.ess_r_dis = a2 * Battery_Par.Soc_Current^3 + b2 * Battery_Par.Soc_Current^2 +c2 * Battery_Par.Soc_Current + d2;
        Batt_Pars.ess_r_chg = a3 * Battery_Par.Soc_Current^3 + b3 * Battery_Par.Soc_Current^2 +c3 * Battery_Par.Soc_Current + d3;
        if Batt_Pars.ess_r_chg < 0 || Batt_Pars.ess_r_dis < 0
            ObjVal_R = 50000;
        else
            ObjVal_R = 0;
        end
        Battery_Par = Program.Model_Verification.Batt.Cal_Battery_GA(Batt_Pars);
        sim_result.I(power_index) = Battery_Par.I;
        sim_result.U(power_index) = Battery_Par.U;
        sim_result.SOC(power_index) = Battery_Par.Soc_Current;
    end
    %ObjVal(row_index) = sqrt(sum((sim_result.SOC' - Batt.SOC_Real / 100).^2) / length(Batt.SOC_Real));
     ObjVal(row_index) =  sqrt(sum((sim_result.SOC - SOC_real).^2) / length(SOC_real))+ ObjVal_R;
%    ObjVal(row_index) = sqrt(sum((sim_result.I - I).^2) / length(SOC_real)) +sqrt(sum((sim_result.U - U).^2) / length(SOC_real))+ObjVal_R;
end
end

