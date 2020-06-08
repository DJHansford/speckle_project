function[locE, qname] = edit_parameters(loc, lambda, no, ne, qfile)
% This code creates a parameter file (input for beam propagation code) that
% points at the right director profile file, and modifies the parameters
% (lambda, ne and no).

locE=[loc,num2str(lambda),'_',num2str(no),'_',num2str(ne),'\'];
if ~exist(locE, 'dir')
    mkdir(locE);
end
qname = qfile(1:end-4);
InputFile='C:\Users\bras2756\Google Drive\Uni Work\Simulation\LC Code\bpm_2d_david\parameters.txt';
OutputFile=[locE,qname,'.txt'];

f1 = fopen(InputFile);
data = textscan(f1, '%s', 'Delimiter', '\n', 'CollectOutput', true);
fclose(f1);

data{1}{5} = ['ASCII file with LC profile						InFile			: ',loc,qfile];
data{1}{10} = ['Free space wavelength in [m]					wlength			: ',num2str(lambda),'e-09'];
data{1}{11} = ['Ordinary refractive index						no				: ',num2str(no)];
data{1}{12} = ['Extra-ordinary refractive index					ne				: ',num2str(ne)];

 f2 = fopen(OutputFile, 'w');
 for I = 1:length(data{1})
     fprintf(f2, '%s\r\n', char(data{1}{I}));
 end
 
 fclose(f2);
 
end