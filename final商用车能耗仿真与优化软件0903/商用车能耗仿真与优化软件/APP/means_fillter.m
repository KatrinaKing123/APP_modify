function [H]=means_fillter(A,L)




%%%简单的均值滤波




% H=[];
% [m,n]=size(A);
% g=2;
% D0=1;
% for i=1:size(A,1)
% for j=1:size(A,2)
% D(i,j)=sqrt((i-m/2)^2+(j-n/2)^2);
% H(i,j)=1/(1+D(i,j)/D0)^(2*g); %巴特沃斯滤波器
% end
% end


H=[];

miss=1:(L-1/2);
miss2=length(A):-1:length(A)-((L-1)/2-1);
for i=1:length(A)
    
    
    if ismember(i,[miss,miss2])==1
        H(i,1)=A(i,1);
    else
        H(i,1)=sum(A(i-2:i+2))/L;
    end
end



% figure(1)
% plot(A,'r');
% hold on;
% plot(H,'b')
% 
% 
% ACC=A-([0;A(1:end-1)]);
% HCC=H-([0;H(1:end-1)]);
% figure(2)
% plot(ACC,'r');
% hold on;
% plot(HCC,'b')
% 
% VCC=velocity-([0;velocity(1:end-1)]);
% 
% hold on;
% plot(VCC,'Y')

end






