% This takes param.mat and creates a VFSweep colormap for whatever size you
% want. For example, if you want to compare data sets that have different
% ranges of frequencies or voltages you can set the range to encompass all
% values and plot each graph with empty space where there is no data.
%
% This can also make transmission colormaps if you choose type = 2
% 
% Option 3 is to make a map of SC*(1-trans) for 'best of both worlds' plot
%
% The colormap is saved to the current folder

clear all

padding = false;

load param.mat

results2D = zeros(20,length(param.f.range));
[x,y] = size(param.results2D);
name=[param.nematic,' + ',param.chiral,', ',num2str(param.cellt),'µm, ',param.temp,'°C'];

for type = [1 2 3]
%     type = 1; % 1 = SC Map, 2 = Trans Map, 3 = Figure of Merit
        
    try
        param.trans2D;
    catch
    param.trans2D = cell2mat(reshape(param.results(:,16),[length(param.v.range) length(param.f.range)]));
    end
    
    switch type
        case 1
            results2D(1:x,1:y) = param.results2D;
            name = ['SC ',name];
        case 2
            results2D(1:x,1:y) = param.trans2D;
            name = ['Trans ',name];
        case 3
            loss = 1.-param.trans2D;
            param.optimum = param.results2D.*loss;
            results2D(1:x,1:y) = param.optimum;
            name = ['Opt ',name];
    end
    
    imagesc(results2D)
    colorbar
    cmap = jet;
    switch type
        case 1
            caxis([0 0.625]);
        case 2
            cmap = flipud(cmap);
            caxis([0 1])
    end
    
    if padding
        cmap(1,:) = [1 1 1];
    end
    colormap(cmap);
    
    title(name)
    ylabel('E-Field (V/µm)')
    set(gca, 'YTick', linspace(2,20,10), 'YTickLabel', linspace(2,20,10))
    xlabel('Frequency (Hz)')
    set(gca, 'XTick', linspace(1,length(param.f.range),length(param.f.range)), 'XTickLabel', param.f.range)
    
    savefig([name,'.fig'])
    saveas(gca, [name,'.jpg'], 'jpg')

end

save('param.mat','param')