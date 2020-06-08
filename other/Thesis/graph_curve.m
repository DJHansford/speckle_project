% Plot of x against y with a 'smoothingspline' fit added. No legend

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph = 'Speckle dependence on camera focus';

x=lens_pos;
x_name = 'Lens position (mm)';
% x_unit = 'wt.%';

y=speckle;
y_name = 'Speckle Contrast';
y_unit = 'C';

f = fit( x, y, 'gauss6');
% xfit = linspace(x(1),x(length(x)),100);
% yfit = xfit.*xfit.*f.p1 + xfit.*f.p2 + f.p3;

plot(f)
hold on
plot(x,y,'o','Color','w','MarkerFaceColor', 'b')
xlim([-25 25])
ylim([0.1,0.15])
title(graph)
xlabel([x_name])
ylabel([y_name,' (',y_unit,')'])
legend('off')

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[graph,'.svg'])
saveas(gcf,[graph,'.fig'])
save(graph)