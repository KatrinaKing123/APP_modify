         Match = struct;
% mc_max_spd_dr=[0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11500];
% mc_max_trq_dr=[200 200 200 175.2 131.4 105.1 87.6 75.1 65.7 58.4 52.4 50.5]*1.075;
mc_max_spd_dr=[0 500	1000	1500	2000	2500	3000	3500	4000	4500	5000	5500	6000	6500	7000	7500	8000	8500	9000	9500	10000	10500	11000	11500	12000];
mc_max_trq_dr=[310 310	310	310	310	310	310	310	310	276	243	214	186	162	139	121	107	98	90	85	76	73	69	66	64]*1.075;

u_Row = 0.377 * r0 * mc_max_spd_dr / i0;
        F_wheel_Col_external = mc_max_trq_dr * i0 * nt / r0;
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
      T_max=interp1(Motor_valid{1, Motor_index}.mc_max_spd_dr,Motor_valid{1, Motor_index}.mc_max_trq_dr,n_zhuansu);                                  %查表得到最大转矩
        F_1 = T_max*22*nt/r0;
        theta_1 = asin((F_1-(A+B*Vi+C*Vi*Vi))/(GVW*g));
        F_2 = C_fai*(GVW*g*(a0/lz*cos(theta_1)+hm/lz*sin(theta_1)));
if F_2 >= F_1 
tgtheta_1 = tan(theta_1);
else tgtheta_1 = a0/lz*(1/C_fai-hm/lz);
end
tgtheta_1

syms tha;
Pi1=60;%Kw
eq=Pi1==1/nt*((A+B*Vi+C*Vi*Vi)/3600*Vi+GVW*g*sin(atan(tha))*Vi/3600);
S3=solve(eq,tha);
tha=S3(1)
        Match.grade = double(tha) 

Motor_PE_FCS_2.m










