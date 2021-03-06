clear all

loc='C:\Users\david\Google Drive\Uni Work\Simulation\SimData\';
% Make list of subfolders
q=dir([loc,'**\*complex.mat']);
qfol={q.folder}.';
qfil={q.name}.';
params = cellfun(@(x) x(length(loc)+2:end), qfol, 'un', 0);
params_length=length(params);
s = 40960; % Size of output
disp(num2str(params_length))

for I=1:params_length
    load([qfol{I},'\',qfil{I}]);
    
    % Only do this if the folder has 100um data in it
    if length(p30)==2048
        % Make a movmean 10x larger and scaled by sqrt(10)
        mm1 = repmat(p30,1,10)';
        mm = reshape(mm1,1,20480);
        nn1 = repmat(xfa_mean,1,10)';
        nn = reshape(nn1,1,20480);
        dc_std = std(x_f_abs(1,:));
        
        n=100;
        sim_xfa = zeros(s,n); % xfa is 'x fft abs'
        sim_xf_com = zeros(s,n);
        sim_x = zeros(s,n);

        for J=1:n
            
            noise = wgn(1,20480,1);
            
            ratio_n = nn/mean(abs(noise));
            
            sim_xfa(2:20481,J) = mm + (noise.*ratio_n);
            sim_xfa(end-20479:end,J) = flip(sim_xfa(2:20481,J)); % Put flipped part on the end (without DC on this side!)
            sim_xfa(1,J) = sqrt(10)*(dc_std*randn + dc); % Add DC component with normal distribution equal to opt_sim data
            sim_xfa = sim_xfa*sqrt(10);
            
            % Add angle component to make FFT values complex as they should be!
            sim_xf_com(:,J) = abs(sim_xfa(:,J)) .* exp((rand(s,1)*2*pi - pi)*1i); % Take abs(sim_xfa) because statistically
            
            sim_x(:,J) = ifft(sim_xf_com(:,J));
        end
        
        save([qfol{I},'\stat_sim_1mm_x100']);
        clearvars -except loc q qfol qfil params params_length s I
        disp(num2str(I),' of ',sum2str(params_length),' created')
    end
end