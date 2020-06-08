function[newfiles] = create_opt_sim_efields(pitchR, celltR, cellwR, RminR, RmaxR, runR, lambdaR, noR, neR, inst)

% Create director and parameter file!
% pitchR = 200:200:400;
% celltR = 5;
% cellwR = 5;
% RminR = 10;
% RmaxR = 20;
% runR = 1:1:2;
% lambda = 632.8;
% noR = 1.5;
% neR = 1.7;

for pitch=pitchR
    for cellt=celltR
        for cellw=cellwR
            for R=1:length(RminR)
                for lambda=lambdaR
                    for N=1:length(noR)
                        for run=runR
                            % Check if domain files of this type already
                            % exist
                            name = ['p',num2str(pitch),'_t',num2str(cellt),'_w',num2str(cellw),'_',num2str(RminR(R)),'-',num2str(RmaxR(R))];
                            loc=['C:\SimData\',name,'\'];
                            q=dir([loc,'*dir_sub_*.dat']);
                            qfile={q.name};
                            if length(q) < 10
                                disp('No full set of 10 dir_sub files, will create new ones')
                                [loc, time] =  create_director_profile(pitch, cellt, cellw, RminR(R), RmaxR(R), run, inst);
                                disp('dir_sub created')
                                q=dir([loc,'*dir_sub_*.dat']);
                                qfile={q.name};
                            elseif length(q) >= 10
                                disp('Found at least 10 pre-existing dir_sub_10 file, will re-use')
                            end
                            
                            [locE qname] = edit_parameters(loc, lambda, noR(N), neR(N), qfile{run});
                            copyfile ([locE,qname,'.txt'], ['C:\SimData\E_out_temp',num2str(inst),'\parameters.txt']);
                            disp('Parameters created')
                            system(['run_e_out',num2str(inst),'.bat']);
                            copyfile (['C:\SimData\E_out_temp',num2str(inst),'\E_out.dat'], [locE,qname(1:15),'E_out',qname(23:end),'.dat']);
                            delete (['C:\SimData\E_out_temp',num2str(inst),'\E_out.dat'], ['C:\SimData\E_out_temp',num2str(inst),'\parameters.txt'], ['C:\SimData\E_out_temp',num2str(inst),'\diffracted.dat'], ['C:\SimData\E_out_temp',num2str(inst),'\E_field.dat'], ['C:\SimData\E_out_temp',num2str(inst),'\intensity_T.dat']);
                        end
                    end
                end
            end
        end
    end
end
disp('Finished!')
oldloc = 'C:\SimData\';
newloc = 'C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\';
search = 'E_out';
newfiles = copynewfiles(oldloc, newloc, search);

subject = 'Simulation complete';
message = ['Instance ',num2str(inst),' complete. Pitch: ',num2str(pitch),' Cellt: ',num2str(cellt),' Cellw: ',num2str(cellw),' Domain size: ',num2str(RminR),'-',num2str(RmaxR),' Wavelength: ',num2str(lambdaR),' Refractive indices: ',num2str(noR),'-',num2str(neR),' with ',num2str(max(runR)),' runs.'];
emailme(subject, message)