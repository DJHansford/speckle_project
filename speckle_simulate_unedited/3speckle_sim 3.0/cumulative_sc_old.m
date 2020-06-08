function[cumSC, cumI, fcumSC] = cumulative_sc(loop, m_total, mid, search, loc, screen)

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

cumI=zeros(size(loop.I.all));
cumSC=zeros(m_total,1);
for I = 1:m_total
    cumI(I,:) = sum(loop.I.all(1:I,:),1); % cumulative intensity at retina for increasing number of frames
    cumSC(I) = std(cumI(I,mid-search:mid+search))/mean(cumI(I,mid-search:mid+search));
end

% fcumSC = fit([1:length(cumSC)]',cumSC,'power2');
fcumSC.c = 0;

figure
% plot(fcumSC,[1:length(cumSC)]',cumSC)
plot([1:length(cumSC)]',cumSC)
xlabel('Number of frames combined')
ylabel('Speckle Contrast')
ylim([0 1])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

saveas(gcf,[loc,'\speckle ',screen,'.svg'])
saveas(gcf,[loc,'\speckle ',screen,'.fig'])
close
end