function[A] = add_scat_particles(A)
%{
Take dir_sub_n in and add scattering particles following parameters set in
A. Save this data as ten_sub_n_xx_xx_xx.dat (with scattering parameters in
name). Rename A.dir_sub_name to suit this before calling run_beam_prop
next.
%}

% Read in director profile without scattering particles
data = import_dir_sub([A.folder1loc,A.dir_sub_name,'.dat']);

% Make output folder if it doesn't already exist
if ~exist(A.folder2loc, 'dir')
    mkdir(A.folder2loc);
end

% Set some constants
dgrid = 24.418e-9; % Grid spacing
NX = round(A.cellw*1e-6/dgrid +1,0); % Width of device in grid points (4095 is 100um)
NZ = round(A.cellt*1e-6/dgrid +1,0); % Thickness of device in grid points (819 is 20um)
eps_perp = A.no*A.no;
del_eps = (A.ne*A.ne) - (A.no*A.no);

% Convert back to theta and phi arrays
i2 = data(:,1);
j2 = data(:,2);
theta_out = reshape(data(:,3),NZ,NX)';
phi_out = reshape(data(:,4),NZ,NX)';

ct = cos(theta_out);
ct2 = cos(theta_out).*cos(theta_out);
st = sin(theta_out);
st2 = sin(theta_out).*sin(theta_out);

cp = cos(phi_out);
cp2 = cos(phi_out).*cos(phi_out);
sp = sin(phi_out);
sp2 = sin(phi_out).*sin(phi_out);

% Convert to dielectric tensor matrix
eps_xx = eps_perp + del_eps*(ct2.*cp2);
eps_yy = eps_perp + del_eps*(ct2.*sp2);
eps_zz = eps_perp + del_eps*(st2);
eps_xy =            del_eps*(ct2.*sp.*cp);
eps_xz =            del_eps*(st.*ct.*cp);
eps_yz =            del_eps*(st.*ct.*sp);

% Use 
try
    load([A.folder1loc,A.dir_sub_name(1:15),'nx_scat_',num2str(A.run),'.mat'],'nx_plot');
catch
    disp('Cannot find nx_plot')
    nx_plot = ones(NX,NZ);
end

nsq = A.nscat*A.nscat;
for i = 1:round(NX*NZ*A.scat/(A.rscat*A.rscat),0)
    x = ceil(rand*(NX-A.rscat));
    z = ceil(rand*(NZ-A.rscat));
    eps_xx(x:x+(A.rscat-1),z:z+(A.rscat-1)) = nsq;
    eps_yy(x:x+(A.rscat-1),z:z+(A.rscat-1)) = nsq;
    eps_zz(x:x+(A.rscat-1),z:z+(A.rscat-1)) = nsq;
    eps_xy(x:x+(A.rscat-1),z:z+(A.rscat-1)) = 0;
    eps_xz(x:x+(A.rscat-1),z:z+(A.rscat-1)) = 0;
    eps_yz(x:x+(A.rscat-1),z:z+(A.rscat-1)) = 0;
    nx_plot(x:x+(A.rscat-1),z:z+(A.rscat-1)) = A.nscat;
end

% Convert back into columns and save
exx1 = eps_xx';
exx2 = exx1(:);
eyy1 = eps_yy';
eyy2 = eyy1(:);
ezz1 = eps_zz';
ezz2 = ezz1(:);
exy1 = eps_xy';
exy2 = exy1(:);
exz1 = eps_xz';
exz2 = exz1(:);
eyz1 = eps_yz';
eyz2 = eyz1(:);
data2=horzcat(i2,j2,exx2,eyy2,ezz2,exy2,eyz2,exz2);
A.dir_sub_name = [A.dir_sub_name,'_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat)];
fq1 = fopen([A.folder1loc,A.dir_sub_name,'.dat'], 'w');
fprintf(fq1,'%i\t%i\t%f\t%f\t%f\t%f\t%f\t%f\n',data2');
fclose(fq1);

if A.plot_dir_scat
    if A.run == 1
        figure
        imagesc(nx_plot)
        pbaspect([A.cellt/A.cellt A.cellw/A.cellt 1])
        colormap jet
        colorbar
        caxis([min([A.no,A.ne,A.nscat]) max([A.no,A.ne,A.nscat])])
        title([num2str(A.pitch),' ',num2str(A.domain_lo),'-',num2str(A.domain_hi),' ',num2str(A.no),'-',num2str(A.ne),' ',num2str(A.scat),' ',num2str(A.nscat),' ',num2str(A.rscat)])
        saveas(gcf,[A.folder2loc,'director profile.fig'])
        close all
    end
end

save([A.folder2loc,A.dir_sub_name(1:15),'nx_scat_',num2str(A.run),'.mat'],'nx_plot')

end