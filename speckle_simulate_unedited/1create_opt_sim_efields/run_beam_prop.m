function[A] = run_beam_prop(A, scat)
%{
This code creates a parameter file (input for beam propagation code) that
points at the right director profile file, and modifies the parameters
(lambda, ne and no). Then runs beam prop code and copies output files into
A.folder2loc. It will create this folder if it doesn't already exist. It
will then delete unecessary files.
%}

if ~exist(A.folder2loc, 'dir')
    mkdir(A.folder2loc);
end
InputFile='C:\Users\bras2756\Google Drive\Uni Work\Simulation\LC Code\bpm_2d_david\parameters.txt';
OutputFile=[A.folder2loc,A.dir_sub_name,'.txt'];

f1 = fopen(InputFile);
data = textscan(f1, '%s', 'Delimiter', '\n', 'CollectOutput', true);
fclose(f1);

data{1}{5} = ['ASCII file with LC profile						InFile			: ',A.folder1loc,A.dir_sub_name,'.dat'];
data{1}{10} = ['Free space wavelength in [m]					wlength			: ',num2str(A.lambda),'e-09'];
data{1}{11} = ['Ordinary refractive index						no				: ',num2str(A.no)];
data{1}{12} = ['Extra-ordinary refractive index					ne				: ',num2str(A.ne)];

if scat
    data{1}{6} = 'Flag indicating content of Infile (1 or 2)		TypeOfInput		: 2';
    A.E_out_scat = [num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat),'_'];
else
    A.E_out_scat = '';
end

f2 = fopen(OutputFile, 'w');
for I = 1:length(data{1})
    fprintf(f2, '%s\r\n', char(data{1}{I}));
end

fclose(f2);

copyfile ([A.folder2loc,A.dir_sub_name,'.txt'], ['C:\SimData\E_out_temp',num2str(A.inst),'\parameters.txt']);
system(['run_e_out',num2str(A.inst),'.bat']);
A.E_out_name = [A.dir_sub_name(1:15),'E_out_',A.E_out_scat,num2str(A.run)];
copyfile (['C:\SimData\E_out_temp',num2str(A.inst),'\E_out.dat'], [A.folder2loc,A.E_out_name,'.dat']);
delete (['C:\SimData\E_out_temp',num2str(A.inst),'\E_out.dat'], ['C:\SimData\E_out_temp',num2str(A.inst),'\parameters.txt'], ['C:\SimData\E_out_temp',num2str(A.inst),'\diffracted.dat'], ['C:\SimData\E_out_temp',num2str(A.inst),'\E_field.dat'], ['C:\SimData\E_out_temp',num2str(A.inst),'\intensity_T.dat']);
end