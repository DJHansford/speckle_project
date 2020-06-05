% Summarises param.mat data for excel files (just by outputting to console.
% Better to use peak_performance_table if comparing data for a range of
% experiments as the table can be used for plots etc
% 
% QUICK or PEAK:
% Outputs the following data in a space separated line:
% Date | Test type | Voltage range | Frequency Range | NDF | Peak V | Peak F | Min Speckle Contrast (SC) | Trans (%) at peak
% 
% STEADY STATE:
% Outputs the following data in a space separated line:
% Date | Test Type | Time (mins) | Voltage | Frequency | NDF | Average SC | SC Range | Speckle Reduction (%) | Transmission (%)
% 
% The try sections deal with old versions of param.mat and the lack of
% information these can suffer from. The user must input some of this missing
% information.

clear all
warning('off','MATLAB:Java:GenericException')
load param.mat

try
    param.time.start;
%     date=char(datetime(param.time.start,'Format','dd/MM/yy'));
catch
    date=input('Input date of test in the following format: DD/MM/YYYY : ','s');
    param.time.start=datetime(str2double(date(7:10)),str2double(date(4:5)),str2double(date(1:2)));
end

ndf=num2str(param.ndf);

try
    param.scan;
catch
    param.scan=input('Input scan type. 1:Quick | 2:Peak | 3:Steady State ');
end

n=0;
[results_n, titles_n]=size(param.results);
try
    param.results(1,18);
catch
    warning(['OLD VERSION OF PARAM. Working with ',num2str(titles_n),' columns. Check results!']);
    n=1;
end

switch param.scan
    case {1,2}
        if param.scan==1; scantype='Quick'; end
        if param.scan==2; scantype='Peak'; end
        vrange=[num2str(min(param.v.range)),'-',num2str(max(param.v.range)),'V/µm'];
        frange=[num2str(min(param.f.range)),'-',num2str(max(param.f.range)),'Hz'];
        [minsc,y]=min(cell2mat(param.results(:,18-n)));
        minsc=num2str(minsc);
        minv=num2str(cell2mat(param.results(y,7-n)));
        minf=num2str(cell2mat(param.results(y,8-n)));
        peaktrans=num2str(cell2mat(param.results(y,16-n)));
        disp([date,' ',scantype,' ',vrange,' ',frange,' ',ndf,' ',minv,' ',minf,' ',minsc,' ',peaktrans])
    case 3
        try
            time=num2str(minutes(param.time.totalsec));
        catch
            time=input('Input length of scan in minutes: ','s');
            param.time.totalsec=minutes(str2double(time));
        end
        v=num2str(param.v.now);
        f=num2str(param.f.now);
        average_sc=mean(cell2mat(param.results(2:results_n,18-n)));
        range_sc=num2str(range(cell2mat(param.results(2:results_n,18-n))));
        sr=num2str(1-(average_sc/param.HeNesc));
        trans=num2str(mean(cell2mat(param.results(2:results_n,16-n))));
        disp([date,' ','SteadyState',' ',time,' ',v,' ',f,' ',ndf,' ',num2str(average_sc),' ',range_sc,' ',sr,' ',trans])
end

save('param.mat','param')