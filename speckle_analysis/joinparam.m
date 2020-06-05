% Use this to combine to data sets for the same cell that have the same
% voltage range and consecutive frequency ranges
% 
% The param files must be named param1 (low frequencies) and param2 (high
% frequencies)

clear all
load param1.mat
param2 = load('param2.mat');
[x1,~] = size(param.results);
[x2,~] = size(param2.param.results);
[~,b1] = size(param.results2D);
[~,b2] = size(param2.param.results2D);
l1 = length(param.f.range);
l2 = length(param2.param.f.range);
param.results(x1+1:x1+x2,:) = param2.param.results;
param.results2D(:,b1+1:b1+b2) = param2.param.results2D;
param.f.range(l1+1:l1+l2) = param2.param.f.range;

save('param.mat','param')