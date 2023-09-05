
%% 修改：
%       最高车速确定电机额定功率
%       加速时间确定电机峰值功率
%       坡起确定电机峰值扭矩
%% 性能指标
%tm=21;                                                                     %百公里加速时间
%Vmax=130;                                                                  %最大车速km/h
% tgtheta=0.25;                                                              %坡起
% %theta=atan(tgtheta);                                                       %坡度
% L=310;                                                                     %WLTP目标续航里程km
% g=9.81;                                                                    %重力加速度m2/s   
% GVW=4250;                                                                  %爬坡用满载质量kg
% GVW_n=2681+100;                                                            %空载质量，最高车速和续航里程算kg
% Cd=0.31;                                                                   %风阻系数,暂定
% A=2.22;                                                                    %迎风面积 m2，暂定
% f=0.01;                                                                    %滚动阻力系数，暂定
% delta=1.08;                                                                %质量换算系数，暂定
% Vm=100;                                                                    %加速后期车速km/h
% Vi=20;                                                                     %爬坡速度km/h，暂定
% Vp=5;                                                                      %爬坡达到的速度
% tp=1;                                                                     %达到爬坡速度所需的时间
% i0=15.046;                                                                 %主减速比
% r0=0.346;                                                                  %车轮滚动半径:m
% 
% hk=0.79;                                                                   %空载质心高度:m
% hm=0.88;                                                                   %满载质心高度:m
% lz=3.76;                                                                   %轴距:m
% nt=0.95;                                                                   %效率综合值，暂定
% n0=1;                                                                      %电池到电机效率，暂定
% Pa=5+5+7;                                                                  %附件功率 KW 
% %lmada=2.5;                                                                %过载系数  
% ndoc=0.8;%放电深度 需要匹配,暂定
% backward = 2025;
% Forward = 1735;
% Line = 3760;
% hg = 880;
num_valid = length(Motor_valid) * length(Batt_valid)*length(FCS_valid);
Dynamic_Match = {};

for Motor_index = 1 : length(Motor_valid)
    for Batt_index = 1 : length(Batt_valid)
        for FCS_index = 1:length(FCS_valid)
        Match = struct;
        Match.type_Motor = Motor_valid{1, Motor_index}.name;                 % 该组合的电机型号
        Match.type_Batt = Batt_valid{1, Batt_index}.name;                    % 该组合的电池型号
        Match.type_FCS = FCS_valid{1,FCS_index}.name;
        Match.MotorPar = Motor_valid{1, Motor_index};                        % 该组合的电机参数
        Match.BattPar = Batt_valid{1, Batt_index};                           % 该组合的电池参数
        Match.FCSPar = FCS_valid{1, FCS_index};  

%         syms Con_Vmax
%         Con_Pe = Motor_valid{1, Motor_index}.mc_PE;                                   % 电机额定功率
%         eqn=1/nt*(GVW_n*g*f*Con_Vmax/3600+Cd*A*Con_Vmax^3/76140)-Con_Pe==0; % 电机额定功率确定最高车速
%         S1=vpasolve(eqn,Con_Vmax);
%         Con_Vmax1 = S1(1);                                                  % 计算出该组合的最高车速KM/h             
%         Match.vmax = double(Con_Vmax1);                                             % 将计算出的最高车速保存

        %%%% Modify calculate vmax
        u_Row = 0.377 * r0 * Motor_valid{1, Motor_index}.mc_max_spd_dr / i0;
        F_wheel_Col_external = Motor_valid{1, Motor_index}.mc_max_trq_dr * i0 * nt / r0;
        F_Resis_Col = GVW_n * g * f + Cd * Area * u_Row.^2 / 21.15;
        u_Row_max = max(u_Row);
        u = 0;
        delta_F = 0;
        while u <= u_Row_max & delta_F <= 0

            F_w = interp1(u_Row, F_wheel_Col_external, u);
            F_R = interp1(u_Row, F_Resis_Col, u);
            delta_F = F_R - F_w;            
            u = u + 1;
        end
        Match.vmax = u;


%         syms Con_tm
% 
%         Con_Pmax = Motor_valid{1, Motor_index}.mc_max_P;                              % 电机峰值功率
%         eqn2=Con_Pmax==1/(3600*Con_tm*nt)*(delta*GVW_n*Vm^2/7.2+GVW_n*g*f*Vm/1.5*Con_tm+Cd*A*Vm^3/21.15/2.5*Con_tm); %电机峰值功率确定百公里加速时间
%         S2=vpasolve(eqn2,Con_tm);
%         Con_tm1=S2(1);                                                      % 计算出该组合的百公里加速时间s
%         Match.tm = double(Con_tm1);                                                 % 将计算出的最高车速保存

        %%%% Modify acc t
        acc = (F_wheel_Col_external - GVW_n * f - Cd * Area * u_Row.^2 / 21.15) / (delta * GVW_n);
        acc_daoshu = 1 ./ acc;
        u = 0;
        s_total=0;
        while u <= Vm-1
            Acc_dao_shu = interp1(u_Row, acc_daoshu, u);
            Acc_dao_shu_1 = interp1(u_Row, acc_daoshu, (u+1));
            s = (Acc_dao_shu_1+Acc_dao_shu)/2;
            s_total = s_total+s;
            u = u+1;
        end
        s_total = s_total/3.6;
        Match.tm = s_total; %加速时间

%         %% JY 修改 根据电机峰值转矩算坡起
%         syms Con_theta
%         
%         Con_Tmax = Motor_valid{1, Motor_index}.mc_max_trq_dr_value;
%         backward = Line - Forward;
%         % theta = atan(tgtheta);
% %         qianqu=1;
% %         if qianqu ==1
% %             eqn3 = Con_Tmax * i0 * nt / r0 == GVW * g * (Forward/Line*cos(atan(Con_theta))+hg/Line * sin(atan(Con_theta))) * f  + GVW * g *sin(atan(Con_theta));
% %         else
%             eqn3 = Con_Tmax * i0 * nt / r0 == GVW * g * (backward/Line*cos(atan(Con_theta))-hg/Line * sin(atan(Con_theta))) * f + GVW * g * sin(atan(Con_theta));
% %         end    
%         S3 = solve(eqn3, Con_theta);
%         Con_theta1 = S3(1);                                                 % 计算该组合的坡起
%         Match.grade = double(Con_theta1);                                           % 将计算出的坡起保存
%% 计算最大坡度
        C_fai=0.8;%附着率取0.8
        n_zhuansu = Vi*i0/r0/0.377;                                                %计算转速
        
      A=245.44;
      B=1.8536;
      C=0.0791;
      lz=3.76;                                                             %轴距:m
      a0=2.140;                                                            %质心至前轴的距离:m
      b=lz-a0;                                                             %质心至后轴的距离:m
      hm=0.89;                                                             %满载质心高度:m
%       n100=[500	1000	1500	2000	2500	3000	3500	4000	4500	5000	5500	6000	6500	7000	7500	8000	8500	9000	9500	10000	10500	11000	11500	12000];
%       T100=[310	310	310	310	310	310	310	310	276	243	214	186	162	139	121	107	98	90	85	76	73	69	66	64];
%       T_max=interp1(Motor_valid{1, Motor_index}.mc_max_spd_dr,Motor_valid{1, Motor_index}.mc_max_trq_dr,n_zhuansu);                                  %查表得到最大转矩
%         F_1 = T_max*i0*nt/r0;
%         theta_1 = asin((F_1-(A+B*Vi+C*Vi*Vi))/(GVW*g));
%         F_2 = C_fai*(GVW*g*(a0/lz*cos(theta_1)+hm/lz*sin(theta_1)));
% if F_2 >= F_1 
% tgtheta_1 = tan(theta_1);
% else tgtheta_1 = a0/lz*(1/C_fai-hm/lz);
% end
% 根据峰值功率算最大坡度
syms tha;
Pi1=interp1(Motor_valid{1, Motor_index}.mc_max_spd_dr,Motor_valid{1, Motor_index}.mc_P_dr,n_zhuansu); %
eq=Pi1==1/nt*((A+B*Vi+C*Vi*Vi)/3600*Vi+GVW*g*sin(atan(tha))*Vi/3600);
S3=solve(eq,tha);
tha=S3(1);
        Match.grade = double(tha) ;
                                                % 将计算出的坡起保存
%         %%%%% Modify grade by limit the fuzhuoli
%         Con_Tmax = Motor_valid{1, Motor_index}.mc_max_trq_dr_value;
%         F_t = Con_Tmax * i0 * nt / r0 ;
%         F_abs_grade = 10;
%         fai = 0.6;
%         if qianqu == 1
%             Con_theta = 0;
% %             F_x_max = 
%             while Con_theta < 1 & F_abs_grade > 0
%                 F_z = GVW * g * (Forward/Line*cos(atan(Con_theta))+hg/Line * sin(atan(Con_theta)));
%                 F_x_max = F_z * fai;
%                 F_abs_grade = min(F_t,F_x_max) - F_z * f - GVW * g * sin(atan(Con_theta)) ;
%                 Con_theta = Con_theta + 0.01;
%             end
%         else
%             Con_theta = 0;
%             while Con_theta < 1 & F_abs_grade > 0
%                 F_z = GVW * g * (backward/Line*cos(atan(Con_theta))-hg/Line * sin(atan(Con_theta)));
%                 F_x_max = F_z * fai;
%                 F_abs_grade = min(F_t,F_x_max) - F_z * f - GVW * g * sin(atan(Con_theta)) ;
%                 Con_theta = Con_theta + 0.01;
%             end     
%         end
%         Match.grade = Con_theta1-0.01;

        %% 
        

        
        x=WLTP(:,1);
        y=WLTP(:,2);
        N = length(x);                                                             %总时间
        W=zeros( 1, N - 1 );%每秒功率
        interv_x=zeros(1,N-1 );
        mid_y=zeros(1,N-1);
        interv_x1=zeros(1,N-1 );
        mid_y1=zeros(1,N-1);
        %单个WLTP行程
        for i = 2 : N
            mid_y(i-1) = ( y(i) + y(i-1) ) / 2;
            interv_x(i - 1) = x(i) - x(i-1);
        end
        L0 = interv_x * mid_y'/3600;                                               %一个WLTP行程Km
        %WLTP工况下的功率用功率算
        for i = 2 : N
            v0=y(i-1);                                                                 %1s的初始速度
            v1=1/2*(y(i-1)+y(i));                                                      %1s的平均速度
            t0=x(i)-x(i-1);
            a=(y(i)-y(i-1))/3.6/t0;
            W(i-1)=1/3600/3600/nt*v1*(GVW_n*g*f+Cd*Area*v0^2/21.15+delta*GVW_n*a);        %计算每一秒所消耗的功率即能量
            %W(i-1)=1/3600/nt/t0*(GVW_n*g*f*v1/1.5+Cd*A*v1^3/21.15/2.5+delta*GVW_n*a/2*v1)*t0/3600;
        end
        Ws=sum(W);                                                                 %一个工况仅车辆行驶所消耗的能量kwh
        
        Con_Wtotal = Batt_valid{1, Batt_index}.E;                          % 电池总能量
        n1=Con_Wtotal/Ws;
        ans1=fix(n1);
        W1=Con_Wtotal-ans1*Ws;                                                         %剩下的非整数段功率
        
        Wm=zeros( 1, N - 1 );%每秒功率
        for i = 2 : N
            v0=y(i-1);                                                                 %1s的初始速度
            v1=1/2*(y(i-1)+y(i));                                                      %1s的平均速度
            t0=x(i)-x(i-1);
            a=(y(i)-y(i-1))/3.6/t0;
            Wm(i-1)=1/3600/3600/nt*v1*(GVW_n*g*f+Cd*Area*v0^2/21.15+delta*GVW_n*a);        %计算每一秒所消耗的功率即能量
            %W(i-1)=1/3600/nt/t0*(GVW_n*g*f*v1/1.5+Cd*A*v1^3/21.15/2.5+delta*GVW_n*a/2*v1)*t0/3600;
            Ws1=sum(Wm);
            if Ws1>=W1
                N1=i;
                break
            end
        end
        
        for i = 2 : N1
            mid_y1(i-1) = ( y(i) + y(i-1) ) / 2;
            interv_x1(i - 1) = x(i) - x(i-1);
            L2 = interv_x1 * mid_y1'/3600;%算出剩下的距离
        end
        
        
        Ltotal=L0*ans1+L2;
        Match.mile = Ltotal;                                           % 将计算出的坡起保存
        Dynamic_Match{end+1} = Match;
        end
    end
end
