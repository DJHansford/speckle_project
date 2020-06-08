% clear all
graph = 'E7 10';
load(['data ',graph,'.mat'])

% f1 = fit(data(:,1),data(:,2),'a*cos(x)^2 + b*x + c');
f2 = fit(data(:,1),data(:,4),'a*cos(x)^2 + b*x + c');
% f1 = fit(data(:,1),data(:,2),'a*cos(x)^2 + c');
% f2 = fit(data(:,1),data(:,4),'a*cos(x)^2 + c');

% figure
% yyaxis left
% p12 = errorbar(data(:,1),data(:,2),data(:,3)./2,'xg');
hold on
% p32 = plot(f1,'-g');
% ylabel 'Speckle contrast (C)'
% ylim([0.28 0.35])

% yyaxis right
p2 = errorbar(data(:,1),data(:,4),data(:,5)./2,'xg');
p4 = plot(f2,'-g');
xlim([0 pi])
set(gca,'xtick',0:pi/4:pi)
set(gca,'xticklabel',{'0','\pi/4','\pi/2','3\pi/4','\pi'})
xlabel 'Polariser angle (radians)'
ylabel 'Transmission (%)'
box on
legend off

% export_fig([graph,'.png'], '-transparent', '-r600')
% saveas(gcf,[graph,'.fig'])