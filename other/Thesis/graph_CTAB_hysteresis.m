graph = '273nm 9µm(2)';
A=param.results3D;
B=permute(A,[3,1,2]);

x = [1:10]';
y1 = (B(:,14,3));
% y1=y1a([1:7]);
% x1=x([1:7]);
f1 = fit(x,y1,'a*x + b');
y2 = (B(:,14,4));
% y2=y2a([1:7]);
% x2=x([1:7]);
f2 = fit(x,y2,'a*x + b');
y3 = (B(:,15,3));
% y3=y3a([2:7]);
% x3=x([2:7]);
f3 = fit(x,y3,'a*x + b');
y4 = (B(:,15,4));
% y4=y4a([1:7]);
% x4=x([1:7]);
f4 = fit(x,y4,'a*x + b');
y5 = (B(:,15,5));
% y5=y5a([1:7]);
% x5=x([1:7]);
f5 = fit(x,y5,'a*x + b');

ff.a = mean([f1.a,f2.a,f3.a,f4.a,f5.a]);
ff.b = mean([f1.b,f2.b,f3.b,f4.b,f5.b]);

plot(x,y1,'-xr')
hold on
plot(x,y2,'-xb')
plot(x,y3,'-xg')
plot(x,y4,'-xm')
plot(x,y5,'-xc')
plot([1,10],ff.a*[1,10] + ff.b,'--k')
% plot([1,8,9,10,8,9,10,8,9,10,8,9,10,8,9,10],[y3a(1),y1a(8),y1a(9),y1a(10),y2a(8),y2a(9),y2a(10),y3a(8),y3a(9),y3a(10),y4a(8),y4a(9),y4a(10),y5a(8),y5a(9),y5a(10)],'ok','MarkerSize',10)
hold off

% legend('14 V/\mum, 120 Hz','14 V/\mum, 140 Hz','15 V/\mum, 100 Hz','15 V/\mum, 120 Hz','15 V/\mum, 140 Hz',[num2str(round(ff.a,3)),'x + ',num2str(round(ff.b,3))])
legend('14 V/\mum, 100 Hz','14 V/\mum, 120 Hz','15 V/\mum, 100 Hz','15 V/\mum, 120 Hz','15 V/\mum, 140 Hz',[num2str(round(ff.a,3)),'x + ',num2str(round(ff.b,3))])
legend Location NorthWest

xlabel 'Run'
xlim([1 10])
ylabel 'Speckle Contrast (C)'
ylim([0 1])

export_fig([graph,'.png'], '-transparent', '-r600')
saveas(gcf,[graph,'.fig'])