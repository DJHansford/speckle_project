close all
clear all

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph='01 13.6Vµm 75Hz';
sn =imread([graph,'.jpg']);
meanx = mean(sn,1)';
meany = mean(sn,2);
fx = fit([1:length(meanx)]',meanx,'gauss1');
fy = fit([1:length(meany)]',meany,'gauss1');
centrex = round(fx.b1);
centrey = round(fy.b1);

half = min([length(meanx)-centrex,centrex,length(meany)-centrey,centrey]);
sn_square = sn(centrey-half:centrey+half,centrex-half:centrex+half);

fx1 = fit([1:2*half+1]',sn_square(:,half),'gauss1');
fy1 = fit([1:2*half+1]',sn_square(half,:)','gauss1');

subplot(2,1,1)
plot(sn_square(:,half))
hold on
plot(fx1)
legend('off')
xlim([0 2*half+1])
xticklabels([])
yticklabels([])
xlabel('Vertical line')
ylabel('Intensity values')

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

subplot(2,1,2)
plot(sn_square(half,:))
hold on
plot(fy1)
legend('off')
xlim([0 2*half+1])
xticklabels([])
yticklabels([])
xlabel('Horizontal line')
ylabel('Intensity values')

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

sn_marked = sn_square;
sn_marked(:,half-1:half+1) = 255;
sn_marked(half-1:half+1,:) = 255;

saveas(gcf,[graph,' intensity profile.svg'])
saveas(gcf,[graph,' intensity profile.fig'])
save([graph,' intensity profile.mat'])

figure
imshow(sn_marked)
imwrite(sn_marked,[graph,' marked.jpg']);