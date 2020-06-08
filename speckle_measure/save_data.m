function[param, fig] = save_data(param, fig)

% Save in base directory if intended directory is too long
if numel(param.location)>208
    param.location='C:\Users\bras2756\Google Drive\Uni Work\Experimental\Speckle Reduction\';
    warndlg('Excel spreadsheet saved in base folder as path length exceeds maximum length (218 characters)');
end

try
xlswrite([param.location,'Data.xlsx'],param.titles,1,'A1');
xlswrite([param.location,'Data.xlsx'],param.results,1,'A2');
catch
    disp('Cannot connect to Excel')
end

switch param.scan
    case {1, 2}
        try
        xlswrite([param.location,'Data.xlsx'],param.f.range,2,'B1');
        xlswrite([param.location,'Data.xlsx'],param.v.range',2,'A2');
        end
        if param.fullreps == 1
            param.results2D = cell2mat(reshape(param.results(:,18),length(param.v.range),length(param.f.range)));
            try
            xlswrite([param.location,'Data.xlsx'],param.results2D,2,'B2');
            end
        else
            param.results3D = cell2mat(reshape(param.results(:,18),length(param.v.range),length(param.f.range),param.fullreps));
            param.results2D = param.results3D(:,:,param.fullreps); % Results 2D is plotted - it is the 2D plot of the final run
        end
        
        fig.colourmap=figure();
        imagesc(param.results2D,[0 0.625]);
%         title(param.testname);
        set(gca, 'XTick', 1:length(param.f.range), 'XTickLabel', param.f.range)
        set(gca, 'YTick', 1:length(param.v.range), 'YTickLabel', param.v.range)
        
        xlabel 'Frequency (Hz)'
        ylabel 'Field amplitude (V/\mum)'
        
        colormap jet;
        c=colorbar;
        c.Label.FontSize = 12;
        c.Label.String = 'Speckle contrast';
        
        savefig([param.location,'Figure.fig'])
%         saveas(gca, [param.location,'Image.jpg'], 'jpg')
        export_fig([param.location,'Image.png'], '-transparent', '-r600')
        
%         Display the minimum speckle contrast reading and associated field
%         conditions
        [minC,minLoc]=min([param.results{:,18}]);
        minV=param.results{minLoc,7};
        minF=param.results{minLoc,8};
        disp(['Minimum C = ',num2str(minC),' at ',num2str(minV),' V/µm and ',num2str(minF),' Hz.'])
    case 3
        param.avgsc = mean(cell2mat(param.results(2:length(param.results(:,14)),14)));
        param.range = max(cell2mat(param.results(2:length(param.results(:,14)),14)))-min(cell2mat(param.results(2:length(param.results(:,14)),14)));
        disp(['Average SC = ',num2str(param.avgsc),' Range = ',num2str(param.range)])
        
        time=cell2mat(param.results(2:length(param.results(:,5)),5))';
        time=time/(60); %If you change this, change the xlabel too
        sc=cell2mat(param.results(2:length(param.results(:,18)),18))';
                
        plot(time,sc);
        ylim([0,0.625])
        xlim([0,param.time.total])
%         title(param.testname)
        xlabel('Time (mins)')
        ylabel('Speckle Contrast (C)')
        
        savefig([param.location,'Figure.fig'])
        export_fig([param.location,'C = ',num2str(round(param.avgsc,3)),' Range = ',num2str(round(param.range,3)),' ',num2str(param.v.now),'Vµm ',num2str(param.f.now),'Hz.png'], '-transparent', '-r600')
end

if param.sendemail
    emailme('Finished',sprintf([param.scantype,' finished.']));
end

param.time.actualfinish=datetime('now');
save([param.location,'param.mat'], 'param')
end