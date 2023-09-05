
%% 电机型号选择或上传处理
if Model_isexist ==1
    Motor_Model_path=strcat('..\..\Factory\Motor\EV\两驱\',string(Motor_Model),'.m');
    run(Motor_Model_path);
    Motor_Model_struct=evalin('base',strcat('Motor_P',upper('e'),'_',Motor_Model(regexp(Motor_Model,'\d'))));
elseif Model_isexist ==2
    run(Motor_Model_path);
    Motor_Model_struct=evalin('base',strcat('Motor_P',upper('e'),'_',Motor_Model(regexp(Motor_Model,'\d'))));
% 电池型号选择或上传处理
elseif Model_isexist==3
    Batt_Model_path=strcat('..\..\Factory\Battery\EV\',string(Batt_Model),'.m');
    run(Batt_Model_path);
    Batt_Model_struct=evalin("base",upper(Batt_Model));
elseif Model_isexist==4
    run(Batt_Model_path);
    Batt_Model_struct=evalin("base",upper(Batt_Model));
end
