function plothysteresis(num, data)
%PLOTHYSTERESIS(num, data)
%  num:     Number of field conditions to track
%  data:    3D array of speckle contrast values from multiple sweeps (eg:
%           param.results3D
% 
% This will plot how well the cell performs over a repeat quick/peak test
% at the <num> best performing field conditions.

load param.mat
x = mean(data,3);

xr = reshape(x,1,[]);
xs = sort(xr);

plotx = 1:10;
plotl = cell(1,num);

figure
hold on

for i=1:num
    [row, col] = find(x == xs(i));
    ploty(i,:) = permute(param.results3D(row,col,:),[1 3 2]);
    plotl(i) = {[num2str(param.v.range(row)),' V/\mum, ',num2str(param.f.range(col)),' Hz']};
end

plot(plotx,ploty,'.-','MarkerSize',18)
legend(plotl,'location','northwest','NumColumns',2,'FontSize',10)

ylabel 'Speckle Contrast (C)'
xlabel 'Run'
xlim([0 10])
ylim([0 0.625])

plotreformat