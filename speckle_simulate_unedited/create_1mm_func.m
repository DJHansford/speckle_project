function[] = create_1mm_func(folders)

s = 40960; % Size of output

for I=1:length(folders)
    [p30, xfa_mean, x_f_abs, dc] = read_dat_complex_master(folders{I});
    
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
        
        save([folders{I},'\stat_sim_1mm_x100']);
        clearvars -except folders s I
        disp([num2str(I),' of ',num2str(length(folders)),' stat_sim_1mm_x100 created'])
    end
end

end