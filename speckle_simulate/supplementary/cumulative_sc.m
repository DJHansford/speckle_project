function[p] = cumulative_sc(loop, p)
% CUMULATIVE_SC works out the cumulative speckle contrast when you average
%   the output intensity fields for increasing numbers of intensity fields
%   at the camera. It plots the change in SC as the number of averaged
%   frames increases and saves them to file.
% 
%   [p] = CUMULATIVE_SC(loop, p)

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

cumI=zeros(size(loop.I.all));
p.cumSC=zeros(p.m_total,1);
for I = 1:p.m_total
    cumI(I,:) = sum(loop.I.all(1:I,:),1); % cumulative intensity at retina for increasing number of frames
    p.cumSC(I) = std(cumI(I,p.mid-p.search:p.mid+p.search))/mean(cumI(I,p.mid-p.search:p.mid+p.search));
end

figure
% plot(fp.cumSC,[1:length(p.cumSC)]',p.cumSC)
plot([1:length(p.cumSC)]',p.cumSC)
xlabel('Number of frames combined')
ylabel('Speckle Contrast')
ylim([0 1])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[p.folder_now,'\speckle ',p.screen_name,'.svg'])
saveas(gcf,[p.folder_now,'\speckle ',p.screen_name,'.fig'])
close
end