%% This code will do the following:
% 1a. Create director profile based on input to create_opt_efields
% 1b. Create necessary parameter files
% 1c. Do optical simulation through LC at 100um
% 2a. Read in E_out .dat files, calculate stats and make x100 stat sim
%     fields at 1mm
% All the necessary files are stored in Google Drive in organised folders

clear all

% Use the next four lines to make domain size = 1-2*pitch
pitch = 3000; % in nm
dgrid = 24.418; % of LC director profile, in nm
domain_lo = round(pitch/dgrid,0);
domain_hi = round(2*pitch/dgrid,0);

newfiles1 = create_opt_sim_efields(pitch, 20, 100, domain_lo, domain_hi, 1:1:10, 632.8, [1.45 1.525 1.55], [1.75 1.675 1.65], 2);
% newfiles2 = create_opt_sim_efields(pitch, 20, 100, domain_lo, domain_hi, 1:1:10, 632.8, 1.5, 1.7, 7);
% newfiles3 = create_opt_sim_efields(250, 1, 100, 20, 40, 1:1:1, 500, 1.52, 1.7, 1);
do_missing_x100_files
check_x100_files
% allnewfiles = {newfiles1};

%% This just selects the folders into which the new files have been saved
% It avoids running the next part of the code on new files still being
% written by other instances of the same function
% n=0;
% for I = 1:length(allnewfiles)
%     file = allnewfiles{1,1}{1,I};
% %     file = allnewfiles{I}; % This used to work, but doesn't any more for some reason
%     k = strfind(file,'\');
%     folder = file(1:k(end)-1);
%     if I==1 || strcmp(folder,allnewfolders{end})==0
%         n=n+1;
%         allnewfolders{n} = folder;
%     end
% end
% allnewfolders = allnewfolders';

%% Old part that found any folder with E_out files but no x100 files
% This unfortunately also picked up E_out files from parallel instances
% before they were complete
% eoutfolders = findfolderswith('C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\','E_out','dat');
% simefolders = findfolderswith('C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\','stat_sim_1mm_x100','mat');
% newfolders = setdiff(eoutfolders, simefolders);

%% This reads in the E_out .dat files, calculates and saves the stats and creates x100
% create_1mm_func(allnewfolders);