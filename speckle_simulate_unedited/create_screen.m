clear all

phase=zeros(1,65536);
n=8192;
% phase(1)=rand*pi/16 - pi/32;
% for i = 2:65536
%     phase(i)=phase(i-1)+(rand*pi/16 - pi/32s);
% end

for b=1:8*n/64
    phase(64*(b-1) +1 :64*(b-1)+64) = rand*1*632.8e-9; % Surface only varies every 64 values to make roughness the same as steve_1
end

% scatter = rand(1,n/8)*2*pi; % Perturbation on wavefront at lengthscale 8d/n from LC device
% phase = interp1(linspace(1,8*n,n/8),scatter,linspace(1,8*n,8*n));