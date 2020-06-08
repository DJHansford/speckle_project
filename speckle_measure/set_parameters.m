function[param] = set_parameters()

%% Variable Initiation
% Settings that get changed
param.test=false;
param.HeNesc=0.671;
param.HeNerm=117754;
param.nematic='BL006';
param.ctab=''; % Any dopant or additive beyond the nematic and chiral dopant inc concentration %
param.chiral='R5011 2.99%'; % chiral dopant inc concentration %
param.temp='30'; % in °C
param.obj_pos='square in focus'; %Position of objective - either distance from screen or description like 'in focus'
param.cam_type = 'Retiga R3'; % Name of camera
param.cam_pos=0.14; %Distance between camera sensor and screen (m)
param.cam_angle=30; %Angle between camera and laser line in degrees
param.cam_lens_f=35; %Focal length of camera lens (mm)
param.iris=3.2; %Iris size in mm
param.lens_dist = 29.00; %distance between lens cage box and camera cage box (mm)
param.msobj = '10x'; % magnification of microscope objective used
param.screen = 'paper'; % screen type (usually paper)
param.optics = 'diff1500 LC LP Diff1500 Obj'; % list of optics in order seen by laser eg: diff1500 LC LP Diff1500 Obj

% User input for crucial values
disp('Have you selected the correct folder location?')
% param.cellt = input('Enter cell thickness (µm): ');
param.cellt = 20; % Set permenantly to 20µm at the moment
param.lot = ' LOT 002'; % With space before: ' LOT 00x'
% param.filldate = input(['Enter ',num2str(param.cellt),'µm cell fill date (yymmdd-x): '],'s');
param.filldate = '200225-2';
param.ndf = input('Enter NDF strength (OD): ');
% param.ndf = 1.2;
param.scan = input('Enter scan type (1: Quick scan, 2: Peak scan, 3: Steady State): ');
% param.scan = 2;
% param.cam_lens_f = input('Enter camera lens focal length (mm): ');
% param.cam_pos = input('Enter camera position (m): ');
% param.lens_dist = input('Enter lens distance from camera (mm): ');
% param.lens_dist = 0;
% disp(['Lens distance = ',num2str(param.lens_dist)])

% Set up timing variables (in seconds)
switch param.scan
    case {1,2}
        param.time.pre_read=5;
        param.time.between_reps=0.05; % Time between repeat readings
        param.time.post_read=2;
        param.reps=18; % Number of repeat readings (1 = no repeats) (18 is about 3 s)
        param.onoff = true; % Switch SigGen off between readings?
        param.fullreps = 1; % Repeat entire range of readings? Make =1 for single run
        param.pause = 0;
        param.all_photos = true;
    case 3
        param.time.post_read=0.001; % 1 Between readings
        time=5*60; %Total time in secs
        param.time.pre_read=0;
        param.time.between_reps=0; % Time between repeat readings
        param.reps=1; % Number of repeat readings (1 = no repeats)
        param.onoff = false; % Switch SigGen off between readings? (usually off for constant readings)
        param.pause = 5; % 5 Pause after switching SigGen on before taking readings to get to steady state response
        param.all_photos = false;
        param.photo_time = 60; % Save photos every x seconds (rather than saving every photo)
        param.photo_time_n = 0; % When to start taking photos (leave as 0 to take throughout)
end

% Initiate results arrays
param.titles={'Cell t (µm)','Nematic','CTAB %','Chiral %','Time','VPP (V)','V/µm','Freq (Hz)','NDF (OD)','Maxcount','Mean','Real Mean','SD','Speckle','Spec Range','Trans %','Spec Red','Non-zero'};

% Set SigGen variables
switch param.scan
    case 1
        param.scantype='Quick scan';
        param.v.range=10:1:20;
        param.f.range=100:20:240;  
    case 2
        param.scantype='Peak scan';
        param.v.range=12.0:0.2:14.0;
%         param.v.range=[6:0.25:10,9.75:-0.25:6.25];
        param.f.range=100:2:140;
        
        0;
    case 3
        param.scantype='Steady State';
        param.v.now=13.6; param.f.now=112;
end

% Setup scan variables
switch param.scan
    case {1, 2}
        param.siggenvec(1,:)=repmat(param.v.range,1,length(param.f.range));
        fvec=repmat((param.f.range),[length(param.v.range),1]);
        param.siggenvec(2,:)=fvec(:)';
        param.siggenvec=round(param.siggenvec,1);
        if param.fullreps ~= 1
            param.scantype=[param.scantype,'mm x',num2str(param.fullreps)];
        end
        param.siggenvec=repmat(param.siggenvec,1,param.fullreps); % Repeat entire VF sweep param.fullrep times
        runtime;
        param.testname=[param.scantype,' ',num2str(param.v.range(1)),'-',num2str(param.v.range(length(param.v.range))),'Vµm ',num2str(param.f.range(1)),'-',num2str(param.f.range(length(param.f.range))),'Hz ',num2str(param.temp),'°C'];
    case 3
        param.siggenvec=ones(2,((time/param.time.post_read)+1));
        param.siggenvec(1,:)=param.siggenvec(1,:)*param.v.now;
        param.siggenvec(2,:)=param.siggenvec(2,:)*param.f.now;
        runtime;
        param.testname=[param.scantype,' ',num2str(param.time.total),' minute(s)'];
%         param.testname=[num2str(param.lens_dist),'mm ',num2str(param.cam_pos),'m ',num2str(param.cam_lens_f),'mm ',param.nematic,' ',num2str(param.iris),'mm'];
end

% Calculate run time
    function[] = runtime()
%         Time taken to complete one column of siggenvec
        param.time.read=(param.reps-1)*param.time.between_reps + param.time.pre_read + param.time.post_read;
        param.time.readsec=seconds(param.time.read);
        param.time.total=round(param.time.read*length(param.siggenvec(1,:))/60,0);
        param.time.totalsec=seconds(param.time.read*(length(param.siggenvec(1,:))-1));
        param.time.finish=datetime('now') + param.time.totalsec;
        [~, ~, ~, H, MN, S] = datevec(param.time.totalsec);
        param.time.remaining = [num2str(H),'h ',num2str(MN),'m ',num2str(S),'s'];
    end

% Function-specific variables (don't edit)
param.isrunning=true; param.n=0; param.pwd=pwd;

% Set up Signal Generator
instrreset;
param.afg=visa('ni','USB::0x0699::0x0341::C020167::INSTR');
fopen(param.afg);
fprintf(param.afg,'*RST');
fprintf(param.afg,'OUTP1:STAT OFF'); fprintf(param.afg,'OUTP2:STAT OFF');
fprintf(param.afg,'OUTP1:IMP INF'); fprintf(param.afg,'OUTP2:IMP INF');
fprintf(param.afg,'SOURCE1:FUNCTION SQUARE'); fprintf(param.afg,'SOURCE2:FUNCTION SQUARE');
fprintf(param.afg,'SOURce1:VOLTage:CONCurrent:STATe ON');
fprintf(param.afg,'SOURce1:FREQuency:CONCurrent ON');
fprintf(param.afg,'SOURce1:PHASe:INITiate');
fprintf(param.afg,'SOURce2:PHASe:ADJust 180 deg');
disp('Signal Generator initiated succesfully')

end