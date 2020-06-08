% Run this code on a csv file output from the UV-Vis. It knows the approx
% refractive indices for E7, BL006, MDA-02-2419 and 5CB at room temperature
% to calculate the pitch from the PBG position. Select nematic type (1-4).
% 
% Select data type (1: .csv file, 2: if you have already transferred the
% data into a MATLAB called 'A' that has lambda values in column 1 and
% transmission percentage values in column 2.
% 
% Select type of pitch measurement. (1: Using entire PBG, using convolution
% with inverted top hat function, 2: using long band edge only (if the full
% PBG isn't within the visible range), or 3: if you just want to observe a
% graph of the PBG without making calculations
% 
% Select the csv file from the pop up box. The code will output an .emf
% file (to the same directory as the .csv file originated) of the PBG graph with PBG centre or long
% band edge marked (depending on choice made above). The file name will
% have the pitch and PBG position included, and both will also be printed
% to the command window.
% 
% NOTE: If the full PBG is close to the edge of the visbile wavelength the
% tophat method may struggle to correctly locate the PBG. Also, this code
% hasn't been written to calculate the pitch using only the short band edge
% but would only need a small adjustment for this to be included.
% 
% Written by David Hansford, partly based on code by Julian Fells.

nematic = input('Select base nematic (1: E7, 2: BL006, 3: MDA-02-2419, 4: 5CB): ');
data = input('Select data type (1: CSV, 2: Manually input into MATLAB array A): ');
type = input('Enter PBG type (1: both, 2: LBE only, 3:none - graph only): ');

switch nematic
    case 1
        disp('Selected E7')
        no=1.517473;
        ne=1.7349;
    case 2
        disp('Selected BL006')
        no=1.5249;
        ne=1.7988;
    case 3
        disp('Selected MDA-02-2419')
        no=1.506;
        ne=1.686;
    case 4
        disp('Selected 5CB')
        no = 1.530;
        ne = 1.708; %24.3°C 632.8nm
end

switch data
    case 1
        [filename,path]=uigetfile('*.csv'); % user selects .csv file
        uvvis=readuvvis([path filename]); % Read in and convert .csv file
        [~,fname,fext] = fileparts(filename); % save current file location to save graph to later
        lambda=uvvis(190:811,1)*1e-9; % wavelengths
        tx=100*10.^-uvvis(190:811,2); % transmission percentage
    case 2
        lambda=A(210:811,1)*1e-9; % wavelengths
        tx=A(210:811,2); % transmission percentage
end

switch type
    case 1
        pitchtype='PBGc';
        n=100; % This is the width of the inverted top hat
        
        % Use inverted top hat convolution to find PBG
        tophat=ones(n,1)*25;
        tophat(n/4:3*n/4)=75;
        invtx=100.-tx;
        tconv=conv(invtx,tophat);
        [~,peak]=max(tconv);
        peak=peak-(n/2);
        marklambda=lambda(peak) % position of PBG center
        nmean=(ne+no)/2;
        pitch=(marklambda/nmean) % calculate pitch using average of ne and no with PBG center
    case 2
        pitchtype='PBGl';
        
        % Find peak gradient of line after smoothing it using a moving average
        gtx=movav(movav(gradient(tx,lambda)));
        [~,peak]=max(gtx(1:end-25));
        marklambda=lambda(peak) % position of long band edge
        pitch=(marklambda/ne) % calculate pitch using ne and long band edge
    case 3
        pitchtype='noPBG';
end

f=figure;

switch type
    case {1, 2}
        plot(lambda/1e-9,tx,'b',[marklambda/1e-9,marklambda/1e-9],[0,100],'r')
    case 3
        plot(lambda/1e-9,tx,'r')
end

% Set up graph
ylim([0,100])
xlim([350,1000])
xlabel('Wavelength, nm')
ylabel('Transmission, %');
grid
f.Children.FontSize=18;

% Save graph. Modify this if you want a MATLAB figure output or a different
% file type to .emf
switch type
    case {1, 2}
        switch data
            case 1
                saveas(f,[path,fname,' ',pitchtype,'=',num2str(round(marklambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm.emf'])
            case 2
                saveas(f,[pitchtype,'=',num2str(round(marklambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm.emf'])
        end
    case 3
        export_fig([path,fname,'.png'], '-transparent', '-r600')
        saveas(gcf,[path,fname,'.fig'])
end

% This is the function that converts old .csv file into MATLAB array
function p=readuvvis(fname)
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid=fopen(fname,'r','n','UTF-16');
p=cell2mat(textscan(fid,'%f %f %f','Delimiter',',','Headerlines',2));
fclose(fid);
warning('on','MATLAB:iofun:UnsupportedEncoding');
end