clear all

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')
pitch = '600';
A = importdata(['director_',pitch,'nm.dat']);
figure
imagesc(A(21:839,21:839),[-1,1]);
pbaspect([1 1 1])
colormap jet;
colorbar;

n=5;
set(gca,'XTick',linspace(1,819,n));
set(gca,'YTick',linspace(1,819,n));
set(gca,'XTickLabel',linspace(0,20,n));
set(gca,'YTickLabel',linspace(20,0,n));

title([pitch,'nm director profile'])
xlabel('Distance (\mum)');
ylabel('Distance (\mum)');
ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[pitch,'nm director profile2.svg'])
saveas(gcf,[pitch,'nm director profile2.png'])
saveas(gcf,[pitch,'nm director profile2.fig'])