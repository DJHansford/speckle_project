% Make a plot of pitch^-1 against concentration of chiral dopant with a
% line of best fit that goes through 0,0. Need two arrays: conc and pitch

graph = 'conc pitch';

load('E7 BDH1281 data.mat'
x=A(:,1);
y=A(:,2);

% x=1./cam_pos;
x_name = 'Concentration of chiral dopant';
x_unit = 'wt.%';
x_hi = 7;

% y=speckle;
y_name = 'Pitch^{-1}';
y_unit = '\mum^{-1}';

f = fit( x, y, 'a*x');
y_hi=x_hi*f.a;

plot([0,x_hi],[0,y_hi],'-','Color','r')
hold on
plot(x,y,'o','Color','w','MarkerFaceColor', 'b')
xlim([0,x_hi])
ylim([0,y_hi])
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])

export_fig([graph,'.png'], '-transparent', '-r600')
saveas(gcf,[graph,'.fig'])
save(graph)