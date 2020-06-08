clear all
load 'data.mat'

f1 = fit(x,y(:,1),'power2');
f2 = fit(x,y(:,2),'power2');
f3 = fit(x,y(:,3),'power2');
f4 = fit(x,y(:,4),'power2');

hold on
p1 = errorbar(x,y(:,1),err(:,1),'xr');
p2 = errorbar(x,y(:,2),err(:,2),'xg');
p3 = errorbar(x,y(:,3),err(:,3),'xb');
p4 = errorbar(x,y(:,4),err(:,4),'xk');
p5 = plot(f1,'r');
p6 = plot(f2,'g');
p7 = plot(f3,'b');
p8 = plot(f4,'k');

ylabel 'Speckle Contrast (C)'
xlabel 'Exposure time (ms)'
xlim([0 250])
ylim([0 1])
legend([p1, p2, p3, p4],{'25°C','35°C','45°C','55°C'})
box on

graph = 'sc exp';
export_fig([graph,'.png'], '-transparent', '-r600')
saveas(gcf,[graph,'.fig'])