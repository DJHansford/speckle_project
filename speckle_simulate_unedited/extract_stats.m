clear all

loc='C:\Users\david\Google Drive\Uni Work\Simulation\SimData\p200_t20_w20_10-20\632.8_1.5_1.7\';
type='dat'; % 'mat' reads in the .mat files already created. Use 'dat' to convert .dat files and make .mat
% Make list of subfolders
p=dir([loc,'**\']);
q=dir([loc,'**\*E_out*.dat']);
pfol={p.folder}.';
qfol={q.folder}.';
folders=intersect(pfol,qfol);
params = cellfun(@(x) x(length(loc)+2:end), folders, 'un', 0);
params_length=length(params);
data=zeros(params_length,14); % 8 params + loads of stats
for I=1:params_length
    switch type
        case 'mat'
%             r=dir([folders{I},'\*.mat']);
%             load([folders{I},'\',r.name])
%             data(I,1:8) = str2double(strsplit(params{I},{'\','-','_','t','w'}));
%             stats(9) = std(x_power)/mean(x_power);
%             stats(10:15) = (max(xstats)-min(xstats))/2;
%             data(I,9:23) = stats;
%             save([folders{I},'\',r.name],'x_real','x_imag','x_power','x_real_fft','x_imag_fft','stats')
        case 'dat'
            data(I,1:8) = str2double(strsplit(params{I},{'\','-','_','t','w'}));
%             stats = read_dat(folders{I},'movmean');
            stats = read_dat_complex(folders{I});
            data(I,9:end) = stats;
    end
end