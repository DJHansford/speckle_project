% Make a basic plot of x against y

% Only save the data before you make the first graph (so its just data you
% save!)

load 'C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\180121_0604 eighth_pi_max_change_screen.mat'

try
    y;
catch
    save 'pitch lambda.mat'
end

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph = 'Pitch and lambda (max8)';

% x=exp;
x_name = 'Pitch length';
x_unit = 'nm';
% x_hi = 2;

% y=sc;
y_name = 'Speckle Contrast';
y_unit = 'C';
y_hi = 1;
y_lo = 0;

x=1;
y=10;

data465 = select_data(data, [NaN, 20, NaN, 10, 20, 465, 1.5, 1.7], 1);
data520 = select_data(data, [NaN, 20, NaN, 10, 20, 520, 1.5, 1.7], 1);
data632 = select_data(data, [NaN, 20, NaN, 10, 20, 632.8, 1.5, 1.7], 1);

figure
% plot(pitch_633(:,x),pitch_633(:,y),'r-x')
% plot(domain_10(:,x),domain_10(:,y),'r-x')
% plot(cellt(:,x),cellt(:,y),'r-x')
plot(data632(:,x),data632(:,y),'r-x')
hold on
% plot(pitch_520(:,x),pitch_520(:,y),'g-x')
% plot(domain_20(:,x),domain_20(:,y),'g-x')
plot(data520(:,x),data520(:,y),'g-x')
hold on
% plot(pitch_465(:,x),pitch_465(:,y),'b-x')
% plot(domain_30(:,x),domain_30(:,y),'b-x')
plot(data465(:,x),data465(:,y),'b-x')
hold off

legend 633nm 520nm 465nm 'Location' 'northwest'
% legend 10-20 20-40 30-60 'Location' 'northwest'
% legend 0.1 0.2 0.3 'Location' 'northwest'

% plot(x,y,'o','Color','w','MarkerFaceColor', 'b')
% xlim([0,x_hi])
ylim([0,y_hi])
% xlim([100,1100])
title(graph)
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[graph,'.svg'])
saveas(gcf,[graph,'.fig'])
% save(graph)