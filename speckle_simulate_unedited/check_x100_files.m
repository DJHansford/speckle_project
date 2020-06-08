%% This script looks through all files in GDrive\SimData
% to make sure all the x100 files were had their stats calculated from all
% the E_out files available. (Earlier version of master_dir_statgen
% accidentally ran the x100 code on folders that were still being
% populated). It then reruns the stats calc and x100 creation with all the
% data

clear all

eoutfolders = findfolderswith('C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\','E_out','dat');
simefolders = findfolderswith('C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\','stat_sim_1mm_x100','mat');
folders=intersect(eoutfolders,simefolders);

for I = 1:length(folders)
    q=dir([folders{I},'\*E_out*.dat']);
    n = length(q);
    p=dir([folders{I},'\*complex.mat']);
    load([p.folder,'\',p.name],'x_power')
    if length(x_power)~= n
        disp([folders{I},' with ',num2str(n),' E_out files'])
        create_1mm_func(folders(I));
    end
    clear x_f_abs n
end