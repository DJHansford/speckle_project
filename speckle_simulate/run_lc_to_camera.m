% RUN_LC_TO_CAMERA sets up for simulation of light propagation from the LC
% device through a lens, onto a screen and then imaged by a camera. You
% will be prompted to provide the location of your simulated data and your
% screen selection

clear all

% Select location of simulated LC output data, for example: 'C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\'
loc = uigetdir('C:\', 'Select the location of your simulated data');
% cd(loc)
[codeloc, ~, ~] = fileparts(which('run_lc_to_camera'));

% Pick screen type
screen_file = uigetfile([codeloc,'\supplementary\screens'], 'Select screen type');
screen = load([codeloc,'\supplementary\screens\',screen_file]);
p.screen_phase = screen.phase;
[~, p.screen_name, ~] = fileparts([codeloc,'\supplementary\screens\',screen_file]);

% Don't change these variables
p.n = 8192; % Number of sample points
p.mid = p.n*4; % centre of the screen
p.search = p.n*2; % +- from centre where speckle is measured

% Make a list of the folders the simulator will work through (1: all
% folders with a stat_sim_1mm_x100.mat file | 2: folders with x100.mat that
% haven't already been simulated over your selected screen)
searchfol = 2;
switch searchfol
    case 1
        folders = findfolderswith(loc, 'stat_sim_1mm_x100', 'mat');
    case 2
        outputfolders = findfolderswith(loc,p.screen_name,'mat');
        simefolders = findfolderswith(loc,'stat_sim_1mm_x100','mat');
        folders=setdiff(simefolders,outputfolders);
end

% Set up an array that will store the simulation data for each run
params = cellfun(@(x) x(length(loc)+3:end), folders, 'un', 0);
data = zeros(length(params),15); % 8 params + loads of stats

% Run the simulation, looping through all the folders selected above
In=0;
disp([num2str(length(params)),' new runs to complete.'])
for I=1:length(params)
    In = In+1;
    p.folder_now = folders{I};
%     data(I,1:8) = str2double(strsplit(params{I},{'\','-','_','t','w'}));
    data(I,1:length(str2double(strsplit(params{I},{'\','-','_','t','w'})))) = str2double(strsplit(params{I},{'\','-','_','t','w'}));
    disp(num2str(data(I,:)))
    p.lambda = data(I,6)*1e-9;

    [p, loop] = prop_lc_to_camera(p); % This actually simulates the light propagation
%     load([folders{I},'\speckle s1 A3 W64 data.mat'],'cumSC','fcumSC');
    data(I,13)=p.cumSC(end); % This is the speckle contrast after 100 frames are averaged
    data(I,14) = 100*(sum(sum(loop.I.all(:,p.mid-p.search:p.mid+p.search)))/100)/5.19504096344176e+19; % Transmission?

    b = dir([folders{I},'\','*complex.mat']);
    load([folders{I},'\',b.name],'x');
    data(I,15) = abs(max(max(real(x)))); % I think this is a check to make sure the simulation hasn't failed and given weird results

%     loopIall = loop.I.all;
%     save([folders{I},'\speckle s1 A3 W64 data.mat'],'cumSC','loopIall','sc','fcumSC');

    disp([num2str(round(100*In/(length(params)),0)),'% through run_all_steve'])
end