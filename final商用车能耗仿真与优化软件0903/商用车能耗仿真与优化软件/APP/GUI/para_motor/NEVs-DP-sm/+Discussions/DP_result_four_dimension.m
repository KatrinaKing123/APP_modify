lambda = zeros(1,Index_End);
lambda(1) = Index_Start;
lambda(2:Index_End) = OPT_Result.G_K_1;
SOC = zeros(1,Index_End);
SOC(1) = SOC_Init;
SOC(2:Index_End) = OPT_Result.SOC_K_1;
velocity = EV.Result.Velocity;
acceleration = EV.Result.Acceleration;
% 
% scatter3(acceleration,velocity,SOC,[],lambda, 'filled');
% %colormap(parula)
% colormap(jet)
% colorbar;
