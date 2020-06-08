% Make a basic plot of x against y

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph = 'Real Gaussian width - pitch and wavelength';

% x=exp;
x_name = 'Pitch';
x_unit = 'nm';
% x_hi = 2;

% y=sc;
y_name = 'Intensity';
y_unit = 'AU';
% y_hi = 1;

n=1;
errorbar(pitch_633(:,1),pitch_633(:,10+n*3),pitch_633(:,12+n*3)-pitch_633(:,10+n*3),pitch_633(:,11+n*3)-pitch_633(:,10+n*3),'r')
% plot(pitch_633(:,1),pitch_633(:,28),'r')
hold on
errorbar(pitch_520(:,1),pitch_520(:,10+n*3),pitch_520(:,12+n*3)-pitch_520(:,10+n*3),pitch_520(:,11+n*3)-pitch_520(:,10+n*3),'g')
% plot(pitch_520(:,1),pitch_520(:,28),'g')
hold on
errorbar(pitch_465(:,1),pitch_465(:,10+n*3),pitch_465(:,12+n*3)-pitch_465(:,10+n*3),pitch_465(:,11+n*3)-pitch_465(:,10+n*3),'b')
% plot(pitch_465(:,1),pitch_465(:,28),'b')
legend 633nm 520nm 465nm 'Location' 'northwest'
% plot(x,y,'o','Color','w','MarkerFaceColor', 'b')
% xlim([0,x_hi])
% ylim([0,y_hi])
xlim([100,1100])
title(graph)
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[graph,'.svg'])
saveas(gcf,[graph,'.fig'])
save(graph)