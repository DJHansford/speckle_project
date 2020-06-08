clear all

% p=dir('*\*complex*.mat');
p=dir('*complex.mat');
pname={p.name};
pfolder={p.folder};

for j = 1:length(p)
    load([pfolder{j},'\',pname{j}],'x')
    yhi=max(max(abs(real(x))));
    figure
    for i = 1:10
        subplot(10,1,i)
        plot(real(x(:,i)))
        xlim([0 4096])
        ylim([-yhi yhi])
    end
    
%     saveas(gcf,[pfolder{j},'\','BeamProp E_out files2.svg'])
%     saveas(gcf,[pfolder{j},'\','BeamProp E_out files2.fig'])
%     close all
%     clear x
end