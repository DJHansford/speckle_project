load 'C:\Users\bras2756\Google Drive\Uni Work\Experimental\Speckle Reduction\E7 R811 (5-25%)\DJH-111016-01 19.9%\20µm\Quick scan x10 5-11Vµm 20-100Hz 25°C 03-Feb-2017\param.mat'

figure
plot(reshape(param.results3D(5,1,:),10,1,1),'o-r','MarkerFaceColor','r','MarkerSize',3)
hold on
plot(reshape(param.results3D(4,1,:),10,1,1),'o-b','MarkerFaceColor','b','MarkerSize',3)
plot(reshape(param.results3D(5,2,:),10,1,1),'o-g','MarkerFaceColor','g','MarkerSize',3)

load 'C:\Users\bras2756\Google Drive\Uni Work\Experimental\Speckle Reduction\E7 R811 (5-25%) CTAB (0.1%)\DJH-111016-01 01 19.9% CTAB 0.2%\20µm\Quick scan x10 5-11Vµm 20-100Hz 25°C 03-Feb-2017\param.mat'
plot(reshape(param.results3D(5,1,:),10,1,1),'^--r','MarkerFaceColor','r','MarkerSize',3)
plot(reshape(param.results3D(4,1,:),10,1,1),'^--b','MarkerFaceColor','b','MarkerSize',3)
plot(reshape(param.results3D(5,2,:),10,1,1),'^--g','MarkerFaceColor','g','MarkerSize',3)

legend('no CTAB, 9V/\mum 20Hz','no CTAB, 8V/\mum 20Hz','no CTAB, 9V/\mum 40Hz','CTAB, 9V/\mum 20Hz','CTAB, 8V/\mum 20Hz','CTAB, 9V/\mum 40Hz')

xlabel 'Run'
ylabel 'Speckle Contrast (C)'
ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
set(gca, 'FontName', 'Cambria')
xlim([1 10])
ylim([0.1 0.5])

graph='QS10';
export_fig([graph,'.png'], '-transparent', '-r600')
saveas(gcf,[graph,'.fig'])