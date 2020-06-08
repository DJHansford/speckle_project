%% This code runs all the x100 files through the latest steve code with a common screen
% Choose screen parameters in this file and they are passed through
% Screen is also saved in case further results are required using the same
% screen

clear all
cd 'C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\'
loc='C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\'; %Different for work PC and laptop
% loc1='C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\p999_t0_w100_41-82\632.8_1_1\';
searchfol = 2; % 1: Run on every folder with simulated x100 | 2: Run only on folders with x100 and no output graph
screen_name = 'eighth_pi_max_change_screen';

n = 8192; % Number of sample points
mid = n*4;
search = n*2;


switch searchfol
    case 1
        folders = findfolderswith(loc, 'stat_sim_1mm_x100', 'mat');
    case 2
        outputfolders = findfolderswith(loc,screen_name,'mat');
        simefolders = findfolderswith(loc,'stat_sim_1mm_x100','mat');
        folders=setdiff(simefolders,outputfolders);
end

params = cellfun(@(x) x(length(loc)+2:end), folders, 'un', 0);
params_length=length(params);
data = zeros(params_length,15); % 8 params + loads of stats

screen.type = 2; % 1: Square random 2: All random (from file) 3: Mirror 4: Points random 5: Interp random every 64
screen.A = 3; % Control phase amplitude of scattering of paper screen
screen.W = 0; % Control width of square random steps (must be 2^n)
screen.name = ['s',num2str(screen.type),' A',num2str(screen.A),' W',num2str(screen.W),' all same'];
screen.lambda = 632.8e-9;
n=8192;

%% Set up the screen
switch screen.type
    case 1
        screen.phase = zeros(1,8*n);
        for b=1:8*n/screen.W
            screen.phase(screen.W*(b-1) +1 :screen.W*(b-1)+screen.W) = rand*screen.A*screen.lambda; % Surface only varies every 64 values to make roughness the same as steve_1
        end
    case 2
        %screen.phase = rand(1,8*n)*2*pi; % Height of surface of paper scatterer
        screen = load([loc,'Screens\',screen_name,'.mat'],'phase');
        screen.name = screen_name;
    case 3
        screen.phase = zeros(1,8*n); % Screen of uniform height (mirror)
    case 4
        screen.phase = zeros(1,8*n);
        for b=1:n/8
            screen.phase(64*(b-1) +1) = rand*screen.A*laser.lambda;
        end
    case 5
        screen.phase.scatter = rand(1,n/8)*screen.A*screen.lambda; % Perturbation on wavefront at lengthscale 8d/n from LC device
        screen.phase = interp1(linspace(1,8*n,n/8),screen.phase.scatter,linspace(1,8*n,8*n));
end

I1 = 1;
I2 = params_length;
% I2 = 2;
In=0;
disp([num2str(params_length),' new runs to complete.'])
for I=I1:I2
    In = In+1;
%     data(I,1:8) = str2double(strsplit(params{I},{'\','-','_','t','w'}));
    data(I,1:length(str2double(strsplit(params{I},{'\','-','_','t','w'})))) = str2double(strsplit(params{I},{'\','-','_','t','w'}));
    disp(num2str(data(I,:)))

    [fcumSC, cumSC, loopIall] = steve_2_2(folders{I}, data(I,:), screen); %
%     load([folders{I},'\speckle s1 A3 W64 data.mat'],'cumSC','fcumSC');
    data(I,13)=cumSC(end); % This is the speckle contrast after 100 frames are averaged
    data(I,12)=fcumSC.c; % This appears not to be used any more (Set to always = 0)
    data(I,14) = 100*(sum(sum(loopIall(:,mid-search:mid+search)))/100)/5.19504096344176e+19; % Transmission?
    
    b = dir([folders{I},'\','*complex.mat']);
    load([folders{I},'\',b.name],'x');
    data(I,15) = abs(max(max(real(x)))); % I think this is a check to make sure the simulation hasn't failed and given weird results

%     loopIall = loop.I.all;
%     save([folders{I},'\speckle s1 A3 W64 data.mat'],'cumSC','loopIall','sc','fcumSC');

    disp([num2str(round(100*In/(I2-I1+1),0)),'% through run_all_steve'])
end

time = datestr(now,'yymmdd_HHMM');
save([loc,time,' ',screen.name,'.mat'],'data','screen')