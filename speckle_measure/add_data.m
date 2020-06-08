function[param, fig] = add_data(param, fig)

addpoints(fig.plotint,param.n,param.tran);
addpoints(fig.plotsc,param.n,param.sc);

% Only save images to disk every x seconds, where x is set in
% set_parameters as param.photo_time
if param.all_photos || param.toc > param.photo_time_n
    imwrite(double(param.sn)/param.maxPixel,[param.imglocation,'Full\',sprintf(['%0',num2str(length(num2str(length(param.siggenvec(1,:))))),'d'], param.n),' ',num2str(param.v.now),'Vµm ',num2str(param.f.now),'Hz.jpg']);
    imwrite(param.sn2/param.maxPixel,[param.imglocation,'Square\',sprintf(['%0',num2str(length(num2str(length(param.siggenvec(1,:))))),'d'], param.n),' ',num2str(param.v.now),'Vµm ',num2str(param.f.now),'Hz x',num2str(param.x),' y',num2str(param.y),'.jpg']);
    if param.all_photos == false
        param.photo_time_n = param.photo_time_n + param.photo_time; %Add x seconds to counter
    end
end
fig.histogram.Data=param.sn3;
[~,ydata] = getpoints(fig.plotsc);
[~,intdata] = getpoints(fig.plotint);
fig.textdisp.String=['SC = ',num2str(round(param.sc,3)),' | SC mean = ',num2str(round(mean(ydata),3)),' | SC range = ',num2str(round(max(ydata)-min(ydata),3)),' | Int mean = ',num2str(round(mean(intdata)*100,3)),' | Int dif = ',num2str(round(100*(max(intdata)-min(intdata)),3))];

switch param.scan
    case {1,2}
        [~, ~, ~, H, MN, S] = datevec(param.time.totalsec - (param.n*param.time.readsec));
        param.time.remaining = [num2str(H),'h ',num2str(MN),'m ',num2str(S),'s'];
    case 3
        param.time.remaining = datestr(param.time.totalsec - seconds(param.toc),'HH:MM:SS');
        fig.time.String=['Time remaining = ',param.time.remaining,'. Estimated finish: ',datestr(param.time.finish)];
end

drawnow;
param.results(param.n,:)={fig.cellt.String, fig.nematic.String, fig.CTAB.String, fig.chiral.String, round(param.toc,1), param.v.now*param.cellt, param.v.now, param.f.now, fig.NDF.String, param.maxcount, param.m, param.rm, param.s, param.sc, param.scrange, param.tran, param.spre, param.nonz};
save([param.location,'param.mat'], 'param')

end