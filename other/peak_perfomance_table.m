% This code outputs the peak performance data from a VFSweep param.mat
% file. It can be used to populate a table for multiple runs. Measures peak 
% performance through minimum speckle contrast (type 1) and through the
% figure of merit C*(1-trans) - lowest value is best (type 2)

clear all

load param.mat

try
    peak_data;
catch
    peak_data = cell(1,13);
    peak_data(1,:) = {'Nematic','Chiral','Ionic','Cellt','Temp','Field Vµm','Freq Hz','SC','Trans','Field Vµm','Freq Hz','SC','Trans'};
end
    
[n,~] = size(peak_data);
n = n+1;

peak_data(n,1:5) = {param.nematic,param.chiral,param.ctab,param.cellt,str2double(param.temp)};

% Collect peak speckle performance data
[minsc,y]=min(cell2mat(param.results(:,18)));
peak_data{n,6}=cell2mat(param.results(y,7));
peak_data{n,7}=cell2mat(param.results(y,8));
peak_data{n,8}=minsc;
peak_data{n,9}=100*cell2mat(param.results(y,16));

% Collect peak FOM performance data
fom = cell2mat(param.results(:,18)).*(1.-cell2mat(param.results(:,16)));
[~,z]=min(fom);
peak_data{n,10}=cell2mat(param.results(z,7));
peak_data{n,11}=cell2mat(param.results(z,8));
peak_data{n,12}=cell2mat(param.results(z,18));
peak_data{n,13}=100*cell2mat(param.results(z,16));