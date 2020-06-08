function[loc, time] =  create_director_profile(pitch, cellt, cellw, Rmin, Rmax, run, inst)
% CREATE_DIRECTOR_PROFILE for light propagation code
% CREATE_DIRECTOR_PROFILE(PITCH, RMAX, RMIN, CELLT)
% PITCH of chiral nematic in nm
% RMAX: max domain radius in grid points
% RMIN: min domain radius in grid points
% CELLW: cell width in microns (laser width)
% CELLT: cell thickness in microns
% RUN: for multiple runs of the same parameters

% clear all
% 
% tic
% pitch = 300;
% Rmax = 20;
% Rmin = 10;
% cellw = 100;
% cellt = 20;
% run=1;

%% Temporary ne and no! Add link to chosen ne and no later
%---------------------------------------------------------
no = 1.5;
ne = 1.7;
eps_perp = no*no;
del_eps = (ne*ne) - (no*no);
%---------------------------------------------------------
%%

dgrid = 24.418e-9; % Grid spacing
dpitch = 2*pi*dgrid/(pitch*1e-9);
NX = round(cellw*1e-6/dgrid +1,0); % Width of device in grid points (4095 is 100um)
NZ = round(cellt*1e-6/dgrid +1,0); % Thickness of device in grid points (819 is 20um)

nk=ones(NX,NZ);
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
    r = round(Rmin + rand*(Rmax-Rmin),0);
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

% For InputOfType 2
eps_xx = eps_perp + del_eps*(nx.*nx);
eps_yy = eps_perp + del_eps*(ny.*ny);
eps_zz = eps_perp + del_eps*(nz.*nz);
eps_xy =            del_eps*(nx.*ny);
eps_xz =            del_eps*(nx.*nz);
eps_yz =            del_eps*(ny.*nz);

time = datestr(now,'yymmdd_HHMM');
name = ['p',num2str(pitch),'_t',num2str(cellt),'_w',num2str(cellw),'_',num2str(Rmin),'-',num2str(Rmax)];

% OLD CODE for saving to file - much slower!
% fp = fopen(dir_name, 'w');
% % fq = fopen(dir_sub_name, 'w');
% disp('Writing to file');
% for i=1:NX
%     for j=1:NZ
%         fprintf(fp,'%e\t',nx(i,j));
% %         fprintf(fq,'%i\t%i\t%f\t%f\n',i,j,theta_out(i,j),phi_out(i,j));
%     end
%     fprintf(fp,'\n');
% end
% fclose(fp);
% fclose(fq);

% fq = fopen(dir_sub_name, 'w');
% for i=1:NX
%     for j=1:NZ
%         fprintf(fq,'%i\t%i\t%f\t%f\n',i,j,theta_out(i,j),phi_out(i,j));
%     end
% end
% fclose(fq);

loc=['C:\SimData\',name,'\'];
if ~exist(loc, 'dir')
    mkdir(loc);
end

% Create array in format required for e_out code and save to .dat
i1=repmat(linspace(1,NX, NX)',1,NZ)';
i2=i1(:);
j2=repmat(linspace(1,NZ, NZ)',NX,1);
th1=theta_out';
th2=th1(:);
ph1=phi_out';
ph2=ph1(:);
data=horzcat(i2,j2,th2,ph2);
fq = fopen([loc,time,'_i',num2str(inst),'_dir_sub_',num2str(run),'.dat'], 'w');
fprintf(fq,'%i\t%i\t%f\t%f\n',data');
fclose(fq);

% Create array in TypeOfInput style 2: dielectric tensor matrix


% Save nx to .dat
% fp = fopen([loc,time,'_dir_',num2str(run),'.dat'], 'w');
% fmt = [repmat('%e\t', 1, size(nx,2)-1),'%e\n'];
% fprintf(fp,fmt,nx');
% fclose(fp);
% % toc
% 
% % % Show nx as colormap (like in thesis)
% figure
% imagesc(nx)
% pbaspect([cellt/cellt cellw/cellt 1])
% colormap jet

end