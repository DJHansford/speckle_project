%% This script looks through all files in GDrive\SimData
% to make sure an x100 simulated data file has been created for every
% folder that has a E_out10 file in it. For some reason the code sometimes
% misses some folders out and they don't get simulated.

clear all

eoutfolders = findfolderswith('C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\','E_out*10','dat');
simefolders = findfolderswith('C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\','stat_sim_1mm_x100','mat');
folders=setdiff(eoutfolders,simefolders);

for I = 1:length(folders)
    create_1mm_func(folders(I));
end