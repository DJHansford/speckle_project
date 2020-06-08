function[stats] = read_dat_complex(folder)

% clear all

% folder=folders{1};

path = strsplit(folder, '\');
name = [path{end-1},'_',path{end}];

files = dir([folder,'\*E_out*.dat']);
filenames = {files.name};

for k = 1:length(filenames)
    %% Initialize variables.
    
    % [FileName,PathName] = uigetfile('*.dat','Select data file to import');
    filename = [folder,'\',filenames{k}];
    delimiter = '\t';
    
    %% Read columns of data as strings:
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%*s%*s%s%s%[^\n\r]';
    
    %% Open the text file.
    fileID = fopen(filename,'r');
    
    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    
    %% Close the text file.
    fclose(fileID);
    
    %% Convert the contents of columns containing numeric strings to numbers.
    % Replace non-numeric strings with NaN.
    raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
    for col=1:length(dataArray)-1
        raw(1:length(dataArray{col}),col) = dataArray{col};
    end
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));
    
    for col=[1,2]
        % Converts strings in the input cell array to numbers. Replaced non-numeric
        % strings with NaN.
        rawData = dataArray{col};
        for row=1:size(rawData, 1);
            % Create a regular expression to detect and remove non-numeric prefixes and
            % suffixes.
            regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
            try
                result = regexp(rawData{row}, regexstr, 'names');
                numbers = result.numbers;
                
                % Detected commas in non-thousand locations.
                invalidThousandsSeparator = false;
                if any(numbers==',');
                    thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                    if isempty(regexp(numbers, thousandsRegExp, 'once'));
                        numbers = NaN;
                        invalidThousandsSeparator = true;
                    end
                end
                % Convert numeric strings to numbers.
                if ~invalidThousandsSeparator;
                    numbers = textscan(strrep(numbers, ',', ''), '%f');
                    numericData(row, col) = numbers{1};
                    raw{row, col} = numbers{1};
                end
            catch
            end
        end
    end
    
    
    %% Replace non-numeric cells with NaN
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
    raw(R) = {NaN}; % Replace non-numeric cells
    
    disp([filenames{k},' succesfully read in'])
    
    %% Allocate imported array to column variable names
    x_r(:,k) = cell2mat(raw(:, 1));
    x_i(:,k) = cell2mat(raw(:, 2));
    x_power(k) = sum(x_r(:,k).*x_r(:,k) + x_i(:,k).*x_i(:,k));
    x(:,k) = x_r(:,k) + 1i*x_i(:,k);
    
    x_f_abs(:,k) = abs(fft(x(:,k)));
    x_f_ang(:,k) = angle(fft(x(:,k)));
    
    %% Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R FileName PathName;
    
end
x_f_abs_avg = mean(x_f_abs,2);
x_f_ang_avg = mean(x_f_ang,2);

dc_hi = max(x_f_abs(1,:));
dc_lo = min(x_f_abs(1,:));
dc = x_f_abs_avg(1);

power = mean(x_power);
nstd = std(x_power)/mean(x_power); % Normalised SD of power values - this should be very small (<0.1) otherwise there's a huge range in output power

l = length(x_f_abs_avg);
p30=movmean(x_f_abs_avg(2:l/2 + 1),round(l/136.53,0)); % Moving mean over 30 consecutive values, excluding dc component and mirrored 2nd half of data
pfull = repmat(p30,1,length(filenames)); % Make matrix of this fit to be subtracted from x_f_abs
xfa_norm = x_f_abs(2:l/2 + 1,:)-pfull; % Take away moving mean values to centralise noise around zero
xfa_mean = mean(abs(xfa_norm),2); % These are the mean values of the absolute distance from the moving mean (to be multiplied with the mean of the wgn values)

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

figure
plot([1:l/2 + 1]',x_f_abs_avg(1:l/2 + 1),[2:l/2 + 1]',p30)
title(['Average absolute fft component of ',num2str(length(filenames)),' runs with movmean fit'])
xlim([0 l/2])
ylim([0 300])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

stats = [length(filenames), dc, dc_hi, dc_lo, power, nstd];

save([folder,'\',name,'_complex.mat'],'x','x_power','x_f_abs','x_f_ang','dc','dc_lo','dc_hi','x_f_abs_avg','x_f_ang_avg','power','nstd','p30','pfull','xfa_norm','xfa_mean')

saveas(gcf,[folder,'\graph.svg'])
saveas(gcf,[folder,'\graph.fig'])

end