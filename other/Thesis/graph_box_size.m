% Run this after running 'find_centre_of_speckle spot' to make thesis ready
% graphs

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph = 'Speckle dependence on box size - He-Ne';

x=x_C;
y=y_C;
e=y_err./2;

lo = y - e;
hi = y + e;
f = fit(x,y,'power2');

figure
hl = plot(x,y,'o','Color','w','MarkerFaceColor', 'b', 'MarkerSize', 4);
hold on;
hp = patch([x; x(end:-1:1); x(1)], [lo; hi(end:-1:1); lo(1)], 'b');
hl = plot(x,y,'o','Color','w','MarkerFaceColor', 'b', 'MarkerSize', 4);
hf = plot(f);
legend('off')

set(hp, 'facecolor', [0.8 0.8 1], 'edgecolor', 'b');
% set(hl, 'color', 'w', 'marker', 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 4);
xlim([0,2])
% ylim([0,1])
title('He-Ne')
xlabel('Box size normalised by c')
ylabel('Speckle Contrast (C)')
ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[graph,'.svg'])
saveas(gcf,[graph,'.fig'])
save([graph,'.mat'])