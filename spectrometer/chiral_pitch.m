% Run this code on a csv file output from the UV-Vis. It knows the approx
% refractive indices for E7, BL006, MDA-02-2419, 5CB and the LC10-80
% mixtures at room temperature to calculate the pitch from the PBG
% position. Select nematic type (1-7).
% 
% Select data type (1: .csv file, 2: if you have already transferred the
% data into a MATLAB called 'A' that has lambda values in column 1 and
% transmission percentage values in column 2.
% 
% Select type of pitch measurement. (1: Using entire PBG, using convolution
% with inverted top hat function, 2: using long band edge only (if the full
% PBG isn't within the visible range), 3: if you just want to observe a
% graph of the PBG without making calculations, 4 shows you the graph and
% lets you select the position of the LBE, 5 lets you select the PBG
% centre)
% 
% Select the csv file from the pop up box. The code will output a .fig and
% .png file (to the same directory as the .csv file originated) of the PBG
% graph with PBG centre or long band edge marked (depending on choice made
% above). The file name will have the pitch and PBG position included, and
% both will also be printed to the command window.
% 
% NOTE: If the full PBG is close to the edge of the visbile wavelength the
% tophat method may struggle to correctly locate the PBG. Also, this code
% hasn't been written to calculate the pitch using only the short band edge
% but would only need a small adjustment for this to be included.

nematic = input('Select base nematic (1: E7, 2: BL006, 3: MDA-02-2419, 4: 5CB, 5: LC10/30/40, 6: LC20, 7: LC80): ');
data = input('Select data type (1: CSV, 2: Manually input into MATLAB array A): ');
type = input('Enter PBG type (1: both, 2: LBE only, 3:none - graph only, 4: Manual LBE, 5: Manual PBGc)');

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
    case 5
        disp('Selected LC10/30/40')
        no = 1.5050;
        ne = 1.6640;
    case 6
        disp('Selected LC20')
        no = 1.5040;
        ne = 1.6630;
    case 7
        disp('Selected LC80')
        no = 1.4872;
        ne = 1.6041;
end

switch data
    case 1
        [filename,path]=uigetfile('*.csv'); % user selects .csv file
        uvvis=readuvvis([path filename]); % Read in and convert .csv file
        [~,fname,fext] = fileparts(filename); % save current file location to save graph to later
%         lambda=uvvis(190:811,1)*1e-9; % wavelengths
        lambda=uvvis(110:610,1)*1e-9; % wavelengths
        tx=100*10.^-uvvis(110:610,2); % transmission percentage
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
    case 4
        pitchtype='PBGl-man';
    case 5
        pitchtype='PBGc-,man';
end

f=figure;

switch type
    case {1, 2}
        plot(lambda/1e-9,tx,'b',[marklambda/1e-9,marklambda/1e-9],[0,100],'r')
    case 3
        plot(lambda/1e-9,tx,'r')
    case {4, 5}
        plot(lambda/1e-9,tx,'b')
        
end

% Set up graph
ylim([0,100])
% xlim([350,1000])
xlim([350,800])
xlabel('Wavelength, nm')
ylabel('Transmission, %');
grid
f.Children.FontSize=18;

switch type
    case 4
        [marklambda,~] = ginput(1);
        marklambda=marklambda*1e-9;
        hold on
        plot([marklambda/1e-9,marklambda/1e-9],[0,100],'r')
        hold off
        pitch=(marklambda/ne) % calculate pitch using ne and long band edge
    case 5
        [marklambda,~] = ginput(1);
        marklambda=marklambda*1e-9;
        hold on
        plot([marklambda/1e-9,marklambda/1e-9],[0,100],'r')
        hold off
        nmean=(ne+no)/2;
        pitch=(marklambda/nmean) % calculate pitch using ne and long band edge
end

% Save graph. Modify this if you want a MATLAB figure output or a different
% file type to .emf
switch type
    case {1, 2, 4, 5}
        switch data
            case 1
                name = [path,fname,' ',pitchtype,'=',num2str(round(marklambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm'];
                savetwo(name)
            case 2
                name = [pitchtype,'=',num2str(round(marklambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm'];
                savetwo(name)
        end
    case 3
        name = [path,fname,' ',pitchtype,'nm'];
        savetwo(name)
end

% This is the function that converts old .csv file into MATLAB array
function p=readuvvis(fname)
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid=fopen(fname,'r','n','UTF-16');
p=cell2mat(textscan(fid,'%f %f %f','Delimiter',',','Headerlines',2));
fclose(fid);
warning('on','MATLAB:iofun:UnsupportedEncoding');
end

function p = movav(x)
a=[-3:3];
coeff=exp(-(a/2).^2);
p=mean([x(1:end-6)*coeff(1),x(2:end-5)*coeff(2),x(3:end-4)*coeff(3),x(4:end-3)*coeff(4),x(5:end-2)*coeff(5),x(6:end-1)*coeff(6),x(7:end)*coeff(7)]')';
p=[x(1);x(2);x(3);p/mean(coeff);x(end-2);x(end-1);x(end)];
end