%{
This code will do the following:
1a. Create director profile based on input to create_opt_efields
1b. Create necessary parameter files
1c. Do optical simulation through LC at 100um
2a. Read in E_out .dat files, calculate stats and make x100 stat sim
    fields at 1mm
All the necessary files are stored in Google Drive in organised folders
%}
clear all
cd 'C:\SimData'

% Use the next four lines to make domain size = 1-2*pitch
A.pitchR = 500; % in nm
A.celltR = 20; % in µm
A.cellwR = 100; % in µm
% A.domain_lo = 10; % in pixels - these get overwritten in creat_opt_sim_efields unless you change it
% A.domain_hi = 20; % in pixels
A.runR = 1:10;
A.lambdaR = 632.8; % in nm
A.noR = 1.550;
A.neR = 1.650;
A.scat = 0.01; % in decimal: 5% is 0.05 - 0 for no scattering particles
A.nscat = 1.7;
A.rscat = round(1000/24.418,0); % in pixels (24.418 nm is grid size for conversion into pixels)
% A.rscat = 1000; % in pixels
A.inst = 2;

A.plot_dir = 1;
A.plot_dir_scat = 1;

% Run code that creates E_out files and copies them into GD
%{
Inputs are as follows:
pitch (nm)
cell thickness (um
cell/laser width for BeamProp (um)
min domain size (pixels - 24.18nm)
max domain size (pixels - 24.18nm)
runs (usually 1:10 for 10 runs)
laser wavelength (nm)
n_o of LC
n_e of LC
fraction of scattering particles in cell (0 = no scattering particles)
n_scat - refractive index of scattering particles
instance - run multiple MATLABs and give them unique instance number (1-7)
%}
A = create_opt_sim_efields(A);

% Search GD for any folders with an E_out_10.dat and no x100.mat file,
% create x100.mat files for these folders
do_missing_x100_files

% Check that all x100.mat files were created using all E_out files in
% respective folders
check_x100_files