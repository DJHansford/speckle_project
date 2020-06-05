function plotsteadystate(param,time)
%PLOTSTEADYSTATE(param,time)
%  param:   param struct
%  time:    Length of experiment in minutes for plotting (optional)
% 
% Make a steady state graph in the publication style using the param
% struct. Optional time input to decide how long to show on the plot.

time=cell2mat(param.results(2:length(param.results(:,5)),5))';
time=time/60;

sc=cell2mat(param.results(2:length(param.results(:,18)),18))';

plot(time,sc);
ylim([0,0.625])
xlabel('Time (mins)')
ylabel('Speckle Contrast')

if nargin == 1
    xlim([0,param.time.total])
else
    xlim([0,time])
end

savetwo(param.testname)

p = polyfit(time,sc,1);
f = polyval(p,time);

disp(['Gradient = ',num2str(p(1))])
disp(['y-intersept = ',num2str(p(2))])

disp(['Mean = ',num2str(mean(sc))])
disp(['Range = ±',num2str(0.5*(max(sc)-min(sc)))])