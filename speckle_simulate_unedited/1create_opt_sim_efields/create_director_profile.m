function[A] =  create_director_profile(A)
% CREATE_DIRECTOR_PROFILE for light propagation code

%{
% clear all
A.pitch = 600;
A.domain_hi = 49;
A.domain_lo = 25;
A.cellw = 100;
A.cellt = 20;
A.run=2;
A.inst=1;
A.scat = 0; % Fraction of scattering particles

plot_graph = 0;
eps_perp = A.no*A.no;
del_eps = (A.ne*A.ne) - (A.no*A.no);
%}

dgrid = 24.418e-9; % Grid spacing
dpitch = 2*pi*dgrid/(A.pitch*1e-9);
NX = round(A.cellw*1e-6/dgrid +1,0); % Width of device in grid points (4095 is 100um)
NZ = round(A.cellt*1e-6/dgrid +1,0); % Thickness of device in grid points (819 is 20um)

% nk=ones(NX,NZ); % NOT NEEDED?
nx=zeros(NX,NZ);
ny=zeros(NX,NZ);
nz=zeros(NX,NZ);

kn=1;
k=NX*NZ;
flag=0;
while k > 0
    theta = pi*rand;
    phi = 2*pi*rand;
    if k > 1000
        ipos = round(1 + rand*(NX-1),0);
        jpos = round(1 + rand*(NZ-1),0);
    else
        [i0,j0] = find (nx == 0);
        k=length(i0)-1;
        if k<0
            flag=1;
            break
        end
        ipos = i0(round(rand*(k) +1,0));
        jpos = j0(round(rand*(k) +1,0));
    end
    if flag
        break
    end
    r = round(A.domain_lo + rand*(A.domain_hi-A.domain_lo),0);
    ct=cos(theta);
    st=sin(theta);
    cp=cos(phi);
    sp=sin(phi);
    
    for i=-1*r:r
        jroot= round(sqrt(r*r-i*i),0);
        for j=-1*jroot:jroot
            if ipos+i>0 && ipos+i<NX+1 && jpos+j>0 && jpos+j<NZ+1
                dist = dpitch*(i*ct*cp + j*st);
                nx(ipos+i,jpos+j) = st*cp*cos(dist) + sp*sin(dist);
                ny(ipos+i,jpos+j) = st*sp*cos(dist) + cp*sin(dist);
                nz(ipos+i,jpos+j) = ct*cos(dist);
            end
        end
    end
    
    if mod(kn,1000)==1 && k>1000
        k=sum(sum(nx==0));
    end
    kn=kn+1;
end

theta_out=atan(nz./sqrt(nx.*nx + ny.*ny));
phi_out=atan(ny./nx);

% Make a matrix of actual refractive index values (travelling along x-axis)
% to use in a plot (if required)
nx_plot = 0.5*(nx+1)*(A.ne-A.no) + A.no;
    
time = datestr(now,'yymmdd_HHMM');

if ~exist(A.folder1loc, 'dir')
    mkdir(A.folder1loc);
end

% Create array in format required for e_out code and save to .dat
% InputOfType 1
i1=repmat(linspace(1,NX, NX)',1,NZ)';
i2=i1(:);
j2=repmat(linspace(1,NZ, NZ)',NX,1);

th1=theta_out';
th2=th1(:);
ph1=phi_out';
ph2=ph1(:);
data=horzcat(i2,j2,th2,ph2);
A.dir_sub_name = [time,'_i',num2str(A.inst),'_dir_sub_',num2str(A.run)];
fq = fopen([A.folder1loc,A.dir_sub_name,'.dat'], 'w');
fprintf(fq,'%i\t%i\t%f\t%f\n',data');
fclose(fq);

%{
% Create and save ten_sub too for comparison
ct = cos(theta_out);
ct2 = cos(theta_out).*cos(theta_out);
st = sin(theta_out);
st2 = sin(theta_out).*sin(theta_out);

cp = cos(phi_out);
cp2 = cos(phi_out).*cos(phi_out);
sp = sin(phi_out);
sp2 = sin(phi_out).*sin(phi_out);

eps_xx = eps_perp + del_eps*(ct2.*cp2);
eps_yy = eps_perp + del_eps*(ct2.*sp2);
eps_zz = eps_perp + del_eps*(st2);
eps_xy =            del_eps*(ct2.*sp.*cp);
eps_xz =            del_eps*(st.*ct.*cp);
eps_yz =            del_eps*(st.*ct.*sp);

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
A.ten_sub_name = [time,'_i',num2str(A.inst),'_ten_sub_',num2str(A.run)];
fq1 = fopen([A.folder1loc,A.ten_sub_name,'.dat'], 'w');
fprintf(fq1,'%i\t%i\t%f\t%f\t%f\t%f\t%f\t%f\n',data2');
fclose(fq1);
%}

save([A.folder1loc,A.dir_sub_name(1:15),'nx_scat_',num2str(A.run),'.mat'],'nx_plot')

if A.plot_dir
    if A.run == 1
        figure
        imagesc(nx_plot)
        pbaspect([A.cellt/A.cellt A.cellw/A.cellt 1])
        colormap jet
        colorbar
        caxis([min([A.no,A.ne,A.nscat]) max([A.no,A.ne,A.nscat])])
        title([num2str(A.pitch),' ',num2str(A.domain_lo),'-',num2str(A.domain_hi),' ',num2str(A.no),'-',num2str(A.ne)])
        saveas(gcf,[A.folder1loc,'director profile.fig'])
        close all
    end

end
end