% Make a plot of pitch^-1 against concentration of chiral dopant with a
% line of best fit that goes through 0,0. Need two arrays: conc and pitch

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph = 'Speckle dependence on camera position';

x=1./cam_pos;
x_name = 'Camera Position^{-1}';
x_unit = 'm^{-1}';
% x_hi = 7;

y=speckle;
y_name = 'Speckle Contrast';
y_unit = 'C';

f = fit( x, y, 'poly1');
% y_hi=x_hi*f.a;

plot(f)
hold on
plot(x,y,'o','Color','w','MarkerFaceColor', 'b')
xlim([1,3])
ylim([0.1,0.2])
title(graph)
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])
legend('off')

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[graph,'.svg'])
saveas(gcf,[graph,'.fig'])
save(graph)