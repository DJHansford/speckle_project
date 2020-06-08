function[] = extract_stats_list(folders)

loc='C:\Users\david\Google Drive\Uni Work\Simulation\SimData\';
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

end