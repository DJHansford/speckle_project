% Create a range of output plots from param.mat file for different
% experiments

% clear all
% load param.mat
plotruns = false;
plotrun = true;
plotchange = false;
plotmin = false;
plotav = false;
tablefullreps = false;

%% Add v and f ranges
if ~ isfield(param.f,'range')
    param.f.range=param.f.lo:param.f.diff:param.f.hi;
    param.v.range=param.v.lo:param.v.diff:param.v.hi;
    disp('Added param.f.range and param.v.range');
    save param.mat
end

%% Add fullreps
if ~ isfield(param,'fullreps')
    param.fullreps=1;
    disp('Added param.fullreps = 1');
    save param.mat
end

%% Plot runs (n×VF Sweeps)
if plotruns
    
    for n = [1,5,10]
        plotcmap(param.results3D(:,:,n),param.f.range,param.v.range)
        savetwo([param.scantype,' ',num2str(n)])
        close all
    end
end

%% Plot single VF Sweep
if plotrun
%     imagesc(param.results2D,[0 0.625]); % Speckle contrast
    imagesc(param.results2Dtrans,[0 1]); % Transmission
%     title(param.testname);
    set(gca, 'XTick', 1:length(param.f.range), 'XTickLabel', param.f.range)
    set(gca, 'YTick', 1:length(param.v.range), 'YTickLabel', param.v.range)
    colormap jet;
    colorbar;
    xlabel 'Frequency (Hz)'
    ylabel 'Field amplitude (V/\mum)'
    
    c = colorbar;
    c.Label.FontSize = 12;
    c.Label.String = 'Transmission';
    export_fig([param.testname,' trans.png'], '-transparent', '-r600')
    saveas(gcf,[param.testname,' trans.fig'])
%     close all
end

%% Plot SC at x V/µm, y Hz over n runs
if plotmin
    param.resultsmean=mean(param.results3D,3);
    [x,y] = find(param.resultsmean == min(param.resultsmean(:)));
%     x=5;
    plot(permute(param.results3D(x,y,:),[1 3 2]))
%     surf(permute(param.results3D(:,y,:),[1 3 2]))
    title(['Peak speckle contrast over ',num2str(param.fullreps),' runs at ',num2str(param.v.range(x)),'V/µm ',num2str(param.f.range(y)),'Hz'])
    savefig([param.location,'Peak SC over ',num2str(param.fullreps),' runs at ',num2str(param.v.range(x)),'Vµm ',num2str(param.f.range(y)),'Hz.fig'])
    saveas(gca, [param.location,'Peak SC over ',num2str(param.fullreps),' runs at ',num2str(param.v.range(x)),'Vµm ',num2str(param.f.range(y)),'Hz.jpg'], 'jpg')
end

% Plot normalised change in SC over n×VF Sweeps for chosen F and range of V
if plotchange
    freq=20; vlo=5; vhi=10;
    fpos=find(param.f.range==freq);
    vlopos=find(param.v.range==vlo);
    vhipos=find(param.v.range==vhi);
    A=permute(param.results3D(vlopos:vhipos,fpos,:),[1 3 2]);
    B=repmat(A(:,1),1,param.fullreps);
    normres=A./B;
%     plot(normres') %Normalised
    plot(A') %Not normalised
    ylim([0,0.65])
    xlabel('Run number')
    ylabel('Speckle Contrast')
    title(['Change in SC over ',num2str(param.fullreps),' VF sweeps at ',num2str(freq),'Hz'])
    legend(arrayfun(@num2str, param.v.range(vlopos:vhipos), 'unif', 0))
    savefig([param.location,'Change in SC over ',num2str(length(param.results3D(1,1,:))),' VF sweeps at ',num2str(freq),'Hz.fig'])
    saveas(gca, [param.location,'Change in SC over ',num2str(length(param.results3D(1,1,:))),' VF sweeps at ',num2str(freq),'Hz.jpg'], 'jpg')
end

%% Plot change in average SC over n×VF Sweeps
if plotav
    A=mean(param.results3D(1:5,:,:),2);
    B=mean(A,1);
    C=permute(B(1,1,:),[3 2 1]);
    plot(C)
end

%% Create table of data for excel summary of cell tests for n×VF Sweeps and Plot change in SC over n×VF Sweeps for chosen f and range of V
if tablefullreps
    param.resultsmean=mean(param.results3D,3);
    [meanx,meany] = find(param.resultsmean == min(param.resultsmean(:)));
    meanv=param.v.range(meanx); meanf=param.f.range(meany);
    %Titles of a: Min V | Min F | Min SC | AVG Min V | AVG Min F | AVG Min SC
    for n=1:param.fullreps
        [x,y] = find(param.results3D(:,:,n) == min(min(param.results3D(:,:,n))));
        a(n,1)=param.v.range(x); a(n,2)=param.f.range(y); a(n,3)=min(min(param.results3D(:,:,n)));
        a(n,4)=meanv; a(n,5)=meanf; a(n,6)=param.results3D(meanx,meany,n);
    end
    
    %     A=permute(param.results3D(meanx-3:meanx+1,meany,:),[1 3 2]);
    A=permute(param.results3D(9:15,meany,:),[1 3 2]);
    B=repmat(A(:,1),1,param.fullreps);
    normres=A./B;
    %     plot(normres') %Normalised
    plot(A') %Not normalised
    ylim([0,0.65])
    xlabel('Run number')
    ylabel('Speckle Contrast')
    title(['Change in SC over ',num2str(param.fullreps),' VF sweeps at ',num2str(meanf),'Hz'])
%     legend(arrayfun(@num2str, param.v.range(meanx-3:meanx+1), 'unif', 0))
    legend(arrayfun(@num2str, param.v.range(9:14), 'unif', 0))
    savefig([param.location,'Change in SC over ',num2str(length(param.results3D(1,1,:))),' VF sweeps at ',num2str(meanf),'Hz.fig'])
    saveas(gca, [param.location,'Change in SC over ',num2str(length(param.results3D(1,1,:))),' VF sweeps at ',num2str(meanf),'Hz.jpg'], 'jpg')
end