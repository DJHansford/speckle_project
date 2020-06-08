function[A] = create_opt_sim_efields(A)

%{
Create director and parameter file!
pitchR = 500;
celltR = 0.1;
cellwR = 100;
RminR = 20;
RmaxR = 41;
runR = 1;
lambdaR = 632.8;
noR = 1.5;
neR = 1.7;
scat = 0;
nscat = 2.5;
inst = 6;
%}

for pitch=A.pitchR
    A.pitch=pitch;
    dgrid = 24.418; % of LC director profile, in nm
    A.domain_lo = round(A.pitch/dgrid,0); %Comment out for set domain size, otherwise keep in for p-2p
    A.domain_hi = round(2*A.pitch/dgrid,0);
    for cellt=A.celltR
        A.cellt=cellt;
        for cellw=A.cellwR
            A.cellw=cellw;
%             for R=1:length(A.domain_loR)
%                 A.domain_lo=A.domain_loR(R);
%                 A.domain_hi=A.domain_hiR(R);
                for lambda=A.lambdaR
                    A.lambda=lambda;
                    for N=1:length(A.noR)
                        A.no=A.noR(N);
                        A.ne=A.neR(N);
                        for run=A.runR
                            A.run=run;
                            % Check if domain files of this type already exist
                            A.folder1name = ['p',num2str(A.pitch),'_t',num2str(A.cellt),'_w',num2str(A.cellw),'_',num2str(A.domain_lo),'-',num2str(A.domain_hi)];
                            A.folder1loc=['C:\SimData\',A.folder1name,'\'];
                            
                            q=dir([A.folder1loc,'*dir_sub_',num2str(A.run),'.dat']);
                            
                            % If not, make it
                            if isempty(q)
                                disp(['dir_sub_',num2str(A.run),'.dat not found, making new one'])
                                A = create_director_profile(A);
                            else
                                disp(['dir_sub_',num2str(A.run),'.dat found, using existing one'])
                                A.dir_sub_name = q.name(1:end-4);
                            end
                            
                            % Check if respective E_out already exists without scattering particles
                            A.folder2loc=[A.folder1loc,num2str(A.lambda),'_',num2str(A.no),'_',num2str(A.ne),'\'];
                            p=dir([A.folder2loc,A.dir_sub_name(1:15),'E_out_',num2str(A.run),'.dat']);
                            
                            % If not, make it
                            if isempty(p)
                                disp(['E_out_',num2str(A.run),'.dat not found, making new one'])
                                A = run_beam_prop(A, 0);
                            else
                                disp(['E_out_',num2str(A.run),'.dat found'])
                            end
                            
                            % If scattering particles are required, use domain file and overwrite scattering particles
                            if A.scat
                                disp('Adding scattering particles and running BeamProp')
                                A.folder2loc=[A.folder1loc,num2str(A.lambda),'_',num2str(A.no),'_',num2str(A.ne),'_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat),'\'];
                                
                                % Check if dir_sub with scat already exists
                                r=dir([A.folder1loc,A.dir_sub_name,'_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat),'.dat']);
                                if isempty(r)
                                    disp(['dir_sub',num2str(A.run),'_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat),'.dat not found, making new one'])
                                    A = add_scat_particles(A);
                                else
                                    disp(['dir_sub',num2str(A.run),'_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat),'.dat found, using existing new one'])
                                    A.dir_sub_name = [A.dir_sub_name,'_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat)];
                                end
                                
                                % Check if respective E_out alreayd exists
                                s=dir([A.folder2loc,A.dir_sub_name(1:15),'E_out_',num2str(A.scat),'_',num2str(A.nscat),'_',num2str(A.rscat),'_',num2str(A.run),'.dat']);
                                if isempty(s)
                                    disp(['E_out_',num2str(A.run),'_',num2str(A.nscat),'_',num2str(A.rscat),'_',num2str(A.run),'.dat not found, making new one'])
                                    A = run_beam_prop(A, 1);
                                else
                                    disp(['E_out_',num2str(A.run),'_',num2str(A.nscat),'_',num2str(A.rscat),'_',num2str(A.run),'.dat found, using existing one'])
                                end
                            end
                            
                        end
                    end
                end
%             end
        end
    end
end
disp('Finished!')

oldloc = 'C:\SimData\';
newloc = 'C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\';
search = 'E_out';
copynewfiles(oldloc, newloc, search);

subject = 'Simulation complete';
message = ['Instance ',num2str(A.inst),' complete. Pitch: ',num2str(A.pitch),' Cellt: ',num2str(A.cellt),' Cellw: ',num2str(A.cellw),' Wavelength: ',num2str(A.lambdaR),' Refractive indices: ',num2str(A.noR),'-',num2str(A.neR),' ',num2str(A.scat),'% scattering particles of refractive index ',num2str(A.nscat),' and size ',num2str(A.rscat),' particles,  with ',num2str(max(A.runR)),' runs.'];
emailme(subject, message)
end